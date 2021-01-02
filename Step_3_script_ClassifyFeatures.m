% Code by @ Dr Haider Raza
% Institute for Analytics and Data Science, School of Computing and
% Electronics Engineering, University of Essex, Colchester, England
% contact: h.raza@essex.ac.uk
% Date: 13/05/2019

% Classes: 1-Both Hand Imagery, 2-Both Feet Imagery
% 3-Word generation, 4-Subtraction
close all; clc;
clear;
warning off

%% PATH to data
currFolder = pwd;
addpath(genpath(currFolder));

% pathdatain = '/Users/sagihaider/MEG/DataMEG_matFeatures/MuBeta';
pathdatain = '/Users/sagihaider/MEG/DataMEG_matFeatures/FBCSP';
% pathdatain = '/Users/sagihaider/MEG/DataMEG_matFeatures/MuAlphaBeta';

%% Subject indexes
indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20]; 
acc_sub=[];
n_comp_csp=[1 6];
for iSub=1:length(indsub)
    nComb = nchoosek(1:4,2);
    for iComb = 1:size(nComb,1)
        
        % Load training data
        filenamein = ['P00' num2str(indsub(iSub)) 'ClassComb_' num2str(nComb(iComb,1)) '_' num2str(nComb(iComb,2)) '_Features.mat'];
        disp(['Processing ' filenamein]);
        fullfilenamein = fullfile(pathdatain,filenamein);
        
        load(fullfilenamein);
        
        [nrow, ncells]=size(features_tr);
        X_tr=[];
        X_ts=[];
        
        for i = 1:ncells
            X_tr = [X_tr features_tr{1,i}(:,n_comp_csp)];
            X_ts = [X_ts features_ts{1,i}(:,n_comp_csp)];
        end
        
        model = fitcsvm(X_tr, Y_tr);
        [Label ,scores]=predict(model, X_ts);
        
        % Perform 10-Fold Cross_validation
        disp('########  Applying Cross-Validation    #################')
        CASE='SVM';
        [c_acc]=Cross_Validation_Haider(X_tr, Y_tr,CASE);

        % %         SVMModel = fitcsvm(X_tr,Y_tr,'Standardize',true);
        CVSVMModel = crossval(model)
        kloss=kfoldLoss(CVSVMModel, 'LossFun', 'classiferror', 'Folds', 10);
        kloss_mat=(1-kloss)*100;
        
        cp = classperf(Y_ts, Label);
        acc=cp.CorrectRate*100;
        disp(filenamein)
        disp(acc)
        
        acc_sub(iSub, iComb) = acc;
        cv_acc(iSub, iComb) = c_acc;
        cv_acc_mat(iSub, iComb) = kloss_mat;
        Y_tr=[];
        Y_ts=[];
    end
end