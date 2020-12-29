% Code by @ Dr Haider Raza
% Institute for Analytics and Data Science, School of Computing and
% Electronics Engineering, University of Essex, Colchester, England
% contact: h.raza@essex.ac.uk
% Date: 13/05/2019

% TODO: error with subject where data is not recoreded into two bloocks

% Classes: 1-Both Hand Imagery, 2-Both Feet Imagery
% 3-Word generation, 4-Subtraction
close all; clc;
clear;
warning off
%% PATH to data
currFolderName = pwd; 
addpath(genpath(currFolderName));
ft_defaults;
pathdatain = 'G:\Data\MEG\MEG_Raw_Natrure\'; 
pathdatain = '..\\'; 
pathdataout = 'G:\Data\MEG\MEG_Mat_Nature\DataMEG\';


%% PATH to add for dependencies
% addpath(genpath('C:\Users\hr17576\OneDrive - University of Essex\Research\MEG\MI_MEG_HR_DR\TNSRE\fieldtrip')); %fieldtrip
% ft_defaults;
% addpath(genpath('C:\Users\hr17576\OneDrive - University of Essex\Research\MEG\MI_MEG_HR_DR\TNSRE\functions'));
%% Choose options
chansel_option = 'all'; %('all'-all channels (306), 'grad'- gradiometers (204), 'mag'-magnetometers (102))
sample_before_cue = 2000;
sample_after_cue = 5000;

%% Subject indexes
indsub=[1,2,3,4,5,6,7,9,11,12,13,14,15,16,17,18,19,20];

%% Create trials in 3D (cloumn- channel, rows- samples, 3d - trials)
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

for sub=1:length(indsub)
    for sess = 1:2
        
        %             filename  = filenames_cell{cellfun(@isempty,regexp(filenames_cell,...
        %                 ['P00' num2str(indsub(sub)) '_IM_B0' num2str(blk) '_S0' num2str(sess) '_(\d*)_mc.fif'],'match')) == 0};
        filenamein = ['P00' num2str(indsub(sub)) '_IM_S0' num2str(sess) '_merged.fif'];
        filenameout = ['P00' num2str(indsub(sub)) '_S0' num2str(sess) '.mat'];
        disp(['Processing ' filenamein]);
        fullfilenamein = fullfile(pathdatain,filenamein);
        
        switch sess
            case 1
                fullfilenameout = fullfile(pathdataout,'Session_01',filenameout);
            case 2
                fullfilenameout = fullfile(pathdataout,'Session_02',filenameout);
        end
         
        trlFile = fn_megbci_get_trial_details(fullfilenamein,sample_before_cue,sample_after_cue);
        cfg              = [];
        cfg.dataset      = fullfilenamein;
        cfg.channel      = ChanSel;
        cfg.trl          = trlFile;
        cfg.continuous   = 'no';
        dataAll = ft_preprocessing(cfg);
        % Edit the data struct for upload
        fields_remove={'hdr','sampleinfo','cfg'};
        dataMAT=rmfield(dataAll,fields_remove);
        
        save(fullfilenameout, 'dataMAT', '-v7.3');
    end
end
