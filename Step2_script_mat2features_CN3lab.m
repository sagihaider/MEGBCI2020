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
%% Set necessary PATHs

% Add filedtrip to the path of your Matlab. You can download it from
% https://github.com/sagihaider/fieldtrip.git
% if you download as fieldtrip-master.zip, after extracting the folder, your path may look like the
% folloiwng.

addpath 'C:\Users\girijesh\OneDrive - Ulster University\Supervision\Dheeraj\Papers\Version-2\Data_sets\fieldtrip-master'

ft_defaults

currFolder = pwd;
addpath(genpath(currFolder));

%Download the MEG data in .mat format (MEG_mat). It is available at:
% https://springernature.figshare.com/collections/A_magnetoencephalography_dataset_for_motor_and_cognitive_imagery_BCI/5101544 the rootpathData = 'E:\Data\MEG';
% Depending on where you download the data as MEG_mat.zip, you need to set the folder name to rootpathData and extract the data, which will normally be extracted 
% in the folder .../MEG_mat, add the folder name to rootpathData, as in the
% following example. 

rootpathData = 'C:\Users\girijesh\OneDrive - Ulster University\Supervision\Dheeraj\Papers\Version-2\Data_sets\Session_1';
rootpathdatain = fullfile(rootpathData,'MEG_mat');

do_resample = 1;

if do_resample
    frq_resample = 250;
    rootpathdataout = fullfile(rootpathData,'DataMEG_matFeatures'); % Folder for outputing the extracted features.
    if ~exist(rootpathdataout, 'dir')
        mkdir(rootpathdataout);
    end
end

%% Subject indexes and Channel labels
indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20]; 

chansel_option = 'grad'; %('all'-all channels (306), 'grad'- gradiometers (204), 'mag'-magnetometers (102))

%% Select Channel for further processing
load('Elekta_Neuromag_Sensors.mat');
switch chansel_option
    case 'grad'
        ChanSel = [SensorLabels.L_Frontal_Grad,SensorLabels.R_Frontal_Grad,...
            SensorLabels.L_Parietal_Grad,SensorLabels.R_Parietal_Grad...
            SensorLabels.L_Temporal_Grad,SensorLabels.R_Temporal_Grad...
            SensorLabels.L_Occipital_Grad,SensorLabels.R_Occipital_Grad];
    case  'mag'
        ChanSel = [SensorLabels.L_Frontal_Mag,SensorLabels.R_Frontal_Mag,...
            SensorLabels.L_Parietal_Mag,SensorLabels.R_Parietal_Mag...
            SensorLabels.L_Temporal_Mag,SensorLabels.R_Temporal_Mag...
            SensorLabels.L_Occipital_Mag,SensorLabels.R_Occipital_Mag];
    case  'all'
        ChanSel = [SensorLabels.L_Frontal_Grad,SensorLabels.R_Frontal_Grad,...
            SensorLabels.L_Parietal_Grad,SensorLabels.R_Parietal_Grad...
            SensorLabels.L_Temporal_Grad,SensorLabels.R_Temporal_Grad...
            SensorLabels.L_Occipital_Grad,SensorLabels.R_Occipital_Grad...
            SensorLabels.L_Frontal_Mag,SensorLabels.R_Frontal_Mag,...
            SensorLabels.L_Parietal_Mag,SensorLabels.R_Parietal_Mag...
            SensorLabels.L_Temporal_Mag,SensorLabels.R_Temporal_Mag...
            SensorLabels.L_Occipital_Mag,SensorLabels.R_Occipital_Mag];
end

toi= [0.5 3.5]; %Time duration of interest after cue in secs (i.e. 3 s currently).

%For various subjects, extract trial-wise features from both the sesion_01 data and and the sesion_02 data.
for iSub=1:2 % Extract features for subject-1 and subject-2, whose indices are 1 and 2 in indsub. For all subjects,1:length(indsub).
    
    % Load training data subject-wise eg.,Session_01/sub-1_ses-1_task-bcimici_meg.mat.
    filenamein = ['Session_01/sub-' num2str(indsub(iSub)) '_ses-1_task-bcimici_meg.mat'];
    
    disp(['Processing ' filenamein]);
    fullfilenamein = fullfile(rootpathdatain,filenamein);
    
    load(fullfilenamein);
    %The above loads the data in the struct variable dataMAT. You may like
    %to have a good look into its various fields.
    dataMAT
    
    cfg = [];
    cfg.channel = ChanSel;
    data_tr=ft_selectdata(cfg,dataMAT);
    
    disp(['Session 1 number of trials ' num2str(length(data_tr.trial))]);
    clear dataMAT
    
    % Load test data for the same above subject from the Sesson 2 using the similar steps.
    filenamein = ['Session_02/sub-' num2str(indsub(iSub)) '_ses-2_task-bcimici_meg.mat'];
    disp(['Processing ' filenamein]);
    fullfilenamein = fullfile(rootpathdatain,filenamein);
    load(fullfilenamein);
    
    %Select the required group of channels mag and/or grad. 
    cfg = [];
    cfg.channel = ChanSel;
    data_ts=ft_selectdata(cfg,dataMAT);
    clear dataMAT
    disp(['Session 2 number of trails ' num2str(length(data_ts.trial))]);
    %
    
    for filtertype = 1:3 % 1:MuBeta ; 2: FBCSP; 3: MuAlphaBeta
        switch filtertype
            case 1
                % MuBeta
                lowpass_freq = [8,14];
                highpass_freq = [12,30];
                pathdataout=fullfile(rootpathdataout,'MuBeta');
                if ~exist(pathdataout, 'dir')
                    mkdir(pathdataout);
                end
                
            case 2
                % FBCSP
                lowpass_freq =  [ 8, 10, 12, 14, 16, 18, 20, 22, 24, 26];
                highpass_freq = [12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
                pathdataout=fullfile(rootpathdataout,'FBCSP');
                if ~exist(pathdataout, 'dir')
                    mkdir(pathdataout);
                end
                
            case 3
                % MuAlphaBeta
                lowpass_freq = [8,8,16];
                highpass_freq = [12,15,31];
                pathdataout=fullfile(rootpathdataout,'MuAlphaBeta');
                if ~exist(pathdataout, 'dir')
                    mkdir(pathdataout);
                end
        end
        
        
        if do_resample
            cfg = [];
            cfg.resamplefs = frq_resample;
            data_tr = ft_resampledata(cfg, data_tr);
            data_ts = ft_resampledata(cfg, data_ts);
        end
        
        %Create all possible combinations of class pairs from the four
        %classes: 1-Both Hand Imagery, 2-Both Feet Imagery 3-Word
        %generation, 4-Subtraction.
        nComb = nchoosek(1:4,2);
        
        %Number of frequency bands for band-pass filtering.
        nBands=length(lowpass_freq);
        
        for iComb = 1:size(nComb,1)
            
            %Collect trials corresponding to task classess nComb(iComb,1)
            %and nComb(iComb,2).
            cfg=[];
            cfg.trials = sort([find(data_tr.trialinfo==nComb(iComb,1)); find(data_tr.trialinfo==nComb(iComb,2))]);
            data_tr_comb = ft_selectdata(cfg,data_tr);
            
            cfg=[];
            cfg.trials = sort([find(data_ts.trialinfo==nComb(iComb,1)); find(data_ts.trialinfo==nComb(iComb,2))]);
            data_ts_comb = ft_selectdata(cfg,data_ts);
            
            features_tr = cell(1,nBands);
            features_ts = cell(1,nBands);
            
            for iBand = 1:nBands
                
                
                % Training data bandPass filtering
                cfg = [];
                cfg.hpfilter = 'yes';
                cfg.hpfreq = lowpass_freq(iBand);
                data_tr_comb_lp = ft_preprocessing(cfg,data_tr_comb);
                
                cfg = [];
                cfg.lpfilter = 'yes';
                cfg.lpfreq = highpass_freq(iBand);
                data_tr_comb_bp = ft_preprocessing(cfg,data_tr_comb_lp);
                
                % Test data bandPass filtering
                cfg = [];
                cfg.hpfilter = 'yes';
                cfg.hpfreq = lowpass_freq(iBand);
                data_ts_comb_lp = ft_preprocessing(cfg,data_ts_comb);
                
                cfg = [];
                cfg.lpfilter = 'yes';
                cfg.lpfreq = highpass_freq(iBand);
                data_ts_comb_bp = ft_preprocessing(cfg,data_ts_comb_lp);
                
                % ft_componentanalysis fucntion
                data_tr_comb_bp.trialinfo(data_tr_comb_bp.trialinfo==nComb(iComb,1))=1;
                data_tr_comb_bp.trialinfo(data_tr_comb_bp.trialinfo==nComb(iComb,2))=2;
                data_ts_comb_bp.trialinfo(data_ts_comb_bp.trialinfo==nComb(iComb,1))=1;
                data_ts_comb_bp.trialinfo(data_ts_comb_bp.trialinfo==nComb(iComb,2))=2;
                
                %select the time of interest from the complete trial
                cfg=[];
                cfg.latency = [0.5 3.5]; %Time duration of interest after cue in secs (i.e. 3 s currently).
                data_tr_toi_comb_bp = ft_selectdata(cfg,data_tr_comb_bp);
                data_ts_toi_comb_bp = ft_selectdata(cfg,data_ts_comb_bp);
                
                % Apply CSP
                cfg_csp=[];
                cfg_csp.method = 'csp';
                cfg_csp.csp.classlabels = data_tr_toi_comb_bp.trialinfo;
                cfg_csp.csp.numfilters  = 6;
                comp_csp_tr = ft_componentanalysis(cfg_csp, data_tr_toi_comb_bp);
                
                
                data_ts_toi_comb_bp = rmfield(data_ts_toi_comb_bp,'trialinfo');
                cfg           = [];
                cfg.method = 'csp';
                cfg.unmixing  = comp_csp_tr.unmixing;
                cfg.topolabel = comp_csp_tr.topolabel;
                cfg.topo = comp_csp_tr.topo;
                comp_csp_ts = ft_componentanalysis(cfg, data_ts_toi_comb_bp);
                
                
                % Take log variance of the trails for Training
                [nRow, nTrials]=size(comp_csp_tr.trial);
                feat_tr=[];
                for t=1:nTrials
                    singleTrial=comp_csp_tr.trial{nRow,t};
                    %                 MI_Block=singleTrial(:,toi);
                    for f=1:cfg_csp.csp.numfilters
                        feat_tr(t,f) = log(var(singleTrial(f,:)));
                    end
                end
                
                features_tr{iBand}=feat_tr;
                
                % Take log variance of the trails for Testing
                [nRow, nTrials]=size(comp_csp_ts.trial);
                feat_ts=[];
                for t=1:nTrials
                    singleTrial=comp_csp_ts.trial{nRow,t};
                    %                 MI_Block=singleTrial(:,toi); %toi is already selected
                    %                 before csp
                    for f=1:cfg_csp.csp.numfilters
                        feat_ts(t,f) = log(var(singleTrial(f,:)));
                    end
                end
                
                features_ts{iBand}=feat_ts;
                clear data_tr_comb_lp data_tr_comb_bp data_ts_comb_lp data_ts_comb_bp
            end
            
            filenameout = ['P00' num2str(indsub(iSub)) 'ClassComb_' num2str(nComb(iComb,1)) '_' num2str(nComb(iComb,2)) '_Features.mat'];
            fullfilenameout =fullfile(pathdataout,filenameout);
            
            Y_tr=data_tr_comb.trialinfo;
            Y_ts=data_ts_comb.trialinfo; % There you go fella!!! I catch this - using training labels here as well.
            
            clear data_tr_comb data_ts_comb
            
            save(fullfilenameout, 'features_tr','features_ts', 'Y_tr', 'Y_ts', 'lowpass_freq', 'highpass_freq', 'toi');
            
        end
    end
end




