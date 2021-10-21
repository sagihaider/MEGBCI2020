% Code for the data-set associated with the following paper.
%
% Rathee, D., Raza, H., Roy, S., & Prasad, G. (2021). A magnetoencephalography dataset for motor and cognitive imagery-based 
% brain–computer interface. Scientific Data-Nature , 8(1), [120],  https://doi.org/10.1038/s41597-021-00899-7. 
%
% Task Classes: 1-Both Hand Imagery, 2-Both Feet Imagery,  3-Word generation, 4-Subtraction.
%
close all; clc;
clear;
warning off

%% Set necessary PATHs.
currFolder = pwd;
addpath(genpath(currFolder));

%Note: Using the script in Step2_script_mat2features_CN3lab.m, the features
%will be generated in three folders: .../MuBeta, .../FBCSP,
%.../MuAlphaBeta. Accordigly the path to features which are used to devise
%and test task decoding classifiers should be set. For example, the paths may look like:

pathdatain = 'C:\Users\girijesh\OneDrive - Ulster University\Supervision\Dheeraj\Papers\Version-2\Data_sets\Session_1\DataMEG_matFeatures\MuBeta';
%pathdatain = 'C:\Users\girijesh\OneDrive - Ulster University\Supervision\Dheeraj\Papers\Version-2\Data_sets\Session_1\DataMEG_matFeatures\FBCSP';
%pathdatain = 'C:\Users\girijesh\OneDrive - Ulster University\Supervision\Dheeraj\Papers\Version-2\Data_sets\Session_1\DataMEG_matFeatures\MuAlphaBeta';

%% Subject indexes

indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20]; 
acc_sub=[];
n_comp_csp=[1 6];

%For various subjects, build  classifiers on session-1 data and evaluate decoding accuracy on the session-2 data.
for iSub = 1:2    %Build and evaluate classifiers for subject-1 and subject-2, whose indices are 1 and 2 in indsub. For all subjects, you may use, 1:length(indsub)
    nComb = nchoosek(1:4,2);
    for iComb = 1:size(nComb,1)
        
        % Load training data subject-wise for every combination of class pairs, eg. for subject-1 and class pair-1_2: P001ClassComb_1_2_Features.mat
        filenamein = ['P00' num2str(indsub(iSub)) 'ClassComb_' num2str(nComb(iComb,1)) '_' num2str(nComb(iComb,2)) '_Features.mat'];
        disp(['Processing ' filenamein]);
        fullfilenamein = fullfile(pathdatain,filenamein);
        
        load(fullfilenamein);
   
        [nrow, ncells]=size(features_tr); 
        %nrow: Number of trial feature vector pairs.
        %ncells: Number of cells columns corresponding to classes. 
        
        X_tr=[];
        X_ts=[];
        
        for i = 1:ncells
            X_tr = [X_tr features_tr{1,i}(:,n_comp_csp)]; %First and last CSP componets.
            X_ts = [X_ts features_ts{1,i}(:,n_comp_csp)]; %First and last CSP componets.
        end
        
        model = fitcsvm(X_tr, Y_tr);
        
        [Label_tr, scores_tr]=predict(model, X_tr);
        
        [Label, scores]=predict(model, X_ts);
        
        cp_tr = classperf(Y_tr, Label_tr);
        acc_tr = cp_tr.CorrectRate*100;
        
        cp = classperf(Y_ts, Label);
        acc=cp.CorrectRate*100;
        
        disp(filenamein)
        disp(acc)
        
        %Perform 10-Fold Cross_validation.
        disp('########  Applying Cross-Validation    #################')
        CASE='SVM';
        [c_acc]=Cross_Validation_Haider(X_tr, Y_tr,CASE);

        % SVMModel = fitcsvm(X_tr,Y_tr,'Standardize',true);
        CVSVMModel = crossval(model)
        kloss=kfoldLoss(CVSVMModel, 'LossFun', 'classiferror', 'Folds', 10);
        kloss_mat=(1-kloss)*100;
        %---------
       
        %Training session accuracy using traing (session-1) data.
        acc_sub_tr(iSub, iComb) = acc_tr;
        
        %10-fold cross-validation accuracy using traing (session-1) data.
        cv_acc(iSub, iComb) = c_acc;
        cv_acc_mat(iSub, iComb) = kloss_mat;
        
        %Test session accuracy using test (session-2) data.
        acc_sub(iSub, iComb) = acc;
        
        
        Y_tr=[];
        Y_ts=[];
    end
    acc_sub(iSub, :)
end

disp('Cross-Validation decoding accuracy:')
cv_acc(1:iSub, :)

disp('Test session-2 decoding accuracy:')
acc_sub(1:iSub, :)