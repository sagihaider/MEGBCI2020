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
pathdatain = 'G:\Data\MEG\MEG_Mat_Nature\DataMEG\';
do_resample = 0;

if do_resample
    frq_resample = 250;
    pathdataout = 'G:\Data\MEG\MEG_Feature_Nature\MuAlphaBetaResamp';
end

%% Subject indexes and Channel labels
indsub=[1,2,3,4,5,6,7,9,11,12,13,14,15,16,17,18,19,20]; % Sub 4 has issues with triggers
% indsub=[7,9,11,12,13,14,15,16,17,18,19,20]; % Sub 4 has issues with triggers (Already extracted features until Sub 6)
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

toi=[0.5 3.5]; % time duration of interest after que in secs.

for iSub=1:length(indsub)
    
    % Load training data
    filenamein = ['Session_01\P00' num2str(indsub(iSub)) '_S01.mat'];
    
    disp(['Processing ' filenamein]);
    fullfilenamein = fullfile(pathdatain,filenamein);
    load(fullfilenamein);
    
    cfg = [];
    cfg.channel = ChanSel;
    data_tr=ft_selectdata(cfg,dataMAT);
    
    disp(['Session 1 number of trails ' num2str(length(data_tr.trial))]);
    clear dataMAT
    
    % Load test data
    filenamein = ['Session_02\P00' num2str(indsub(iSub)) '_S02.mat'];
    disp(['Processing ' filenamein]);
    fullfilenamein = fullfile(pathdatain,filenamein);
    load(fullfilenamein);
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
                pathdataout = 'G:\Data\MEG\MEG_Feature_NatureFinal\MuBeta';
                
            case 2
                % FBCSP
                lowpass_freq =  [ 8, 10, 12, 14, 16, 18, 20, 22, 24, 26];
                highpass_freq = [12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
                pathdataout = 'G:\Data\MEG\MEG_Feature_NatureFinal\FBCSP';
                
            case 3
                % MuAlphaBeta
                lowpass_freq = [8,8,16];
                highpass_freq = [12,15,31];
                pathdataout = 'G:\Data\MEG\MEG_Feature_NatureFinal\MuAlphaBeta';
        end
        
        
        if do_resample
            cfg = [];
            cfg.resamplefs = frq_resample;
            data_tr = ft_resampledata(cfg, data_tr);
            data_ts = ft_resampledata(cfg, data_ts);
        end
        
        nComb = nchoosek(1:4,2);
        nBands=length(lowpass_freq);
        
        for iComb = 1:size(nComb,1)
            
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
                cfg.lpfilter = 'yes';
                cfg.lpfreq = lowpass_freq(iBand);
                data_tr_comb_lp = ft_preprocessing(cfg,data_tr_comb);
                
                cfg = [];
                cfg.hpfilter = 'yes';
                cfg.hpfreq = highpass_freq(iBand);
                data_tr_comb_bp = ft_preprocessing(cfg,data_tr_comb_lp);
                
                % Test data bandPass filtering
                cfg = [];
                cfg.lpfilter = 'yes';
                cfg.lpfreq = lowpass_freq(iBand);
                data_ts_comb_lp = ft_preprocessing(cfg,data_ts_comb);
                
                cfg = [];
                cfg.hpfilter = 'yes';
                cfg.hpfreq = highpass_freq(iBand);
                data_ts_comb_bp = ft_preprocessing(cfg,data_ts_comb_lp);
                
                % ft_componentanalysis fucntion
                data_tr_comb_bp.trialinfo(data_tr_comb_bp.trialinfo==nComb(iComb,1))=1;
                data_tr_comb_bp.trialinfo(data_tr_comb_bp.trialinfo==nComb(iComb,2))=2;
                data_ts_comb_bp.trialinfo(data_ts_comb_bp.trialinfo==nComb(iComb,1))=1;
                data_ts_comb_bp.trialinfo(data_ts_comb_bp.trialinfo==nComb(iComb,2))=2;
                
                %select the time of interest from the complete trial
                cfg=[];
                cfg.latency = [0.5 3.5];
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
                
                % Take log variance of the trails for Training
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




