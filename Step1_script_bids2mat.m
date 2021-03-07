% Code by @ Dr Haider Raza
% Institute for Analytics and Data Science, School of Computing and
% Electronics Engineering, University of Essex, Colchester, England
% contact: h.raza@essex.ac.uk
% Date: 13/05/2019
% Last updated: 09/01/2021

% TODO: error with subject where data is not recoreded into two bloocks

% Classes: 1-Both Hand Imagery, 2-Both Feet Imagery
% 3-Word generation, 4-Subtraction

close all; clc;
clear;
warning off
%% PATH to data

% add filedtrip to path of your Matlab. You can download it from
% https://github.com/sagihaider/fieldtrip.git 

restoredefaultpath
% addpath '/Users/sagihaider/GitHub/fieldtrip-20201001'
addpath 'C:\Users\hr17576\OneDrive - University of Essex\Research\MEGNature\fieldtrip'
ft_defaults

currFolder = pwd;
addpath(genpath(currFolder));

rootpathData = 'E:\Data\MEG';
rootpathdatain = fullfile(rootpathData,'MEG_BIDS');
rootpathdataout = fullfile(rootpathData,'MEG_mat');
if ~exist(rootpathdataout, 'dir')
    mkdir(rootpathdataout);
end

%% Choose options
chansel_option = 'all'; %('all'-all channels (306), 'grad'- gradiometers (204), 'mag'-magnetometers (102))
sample_before_cue = 2000; % after 2000 samples the cue to appearing; so here the subject is starting imagery
sample_after_cue = 5000; % at 5000 sample the subject stop imagery

%% Subject indexes

indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20];

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

classesinfo = {1, 'Both Hand Imagery'; 2 , 'Both Feet Imagery'; 3, 'Word generation'; 4, 'Subtraction'};

for sub=1:length(indsub)
    for ses = 1:2
        
        filenamein = ['sub-' num2str(indsub(sub)) '_ses-' num2str(ses) '_task-bcimici_meg.fif'];
        filenameout = strrep(filenamein,'fif','mat');
        disp(['Processing ' filenamein]);
        fullfilenamein = fullfile(rootpathdatain,['sub-' num2str(indsub(sub))],['ses-' num2str(ses)],'meg',filenamein);
        
        sessfolderpath = fullfile(rootpathdataout,['Session_0' num2str(ses)]);
        if ~exist(sessfolderpath, 'dir')
            mkdir(sessfolderpath);
        end
        switch ses
            case 1
                fullfilenameout = fullfile(sessfolderpath,filenameout);
            case 2
                fullfilenameout = fullfile(sessfolderpath,filenameout);
        end
        
        trlFile = fn_megbci_get_trial_details(fullfilenamein,sample_before_cue,sample_after_cue); % Reading fif files
        cfg              = [];
        cfg.dataset      = fullfilenamein;
        cfg.channel      = ChanSel;
        cfg.trl          = trlFile;
        cfg.continuous   = 'no';
        dataAll = ft_preprocessing(cfg);
        fields_remove={'hdr','sampleinfo','cfg'};
        dataMAT=rmfield(dataAll,fields_remove);
        dataMAT.trialclass = classesinfo;
        save(fullfilenameout, 'dataMAT', '-v7.3');
    end
end
