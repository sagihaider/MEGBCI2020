Code by @ Dr Haider Raza
School of Computing and Electronics Engineering, University of Essex, Colchester, England
contact: h.raza@essex.ac.uk
Date: 13/05/2019

Classes: 1-Both Hand Imagery, 2-Both Feet Imagery
3-Word generation, 4-Subtraction

close all; clc;
clear;
warning off

% PATH to data
pathdatain = 'G:\Data\MEG\MEG_Raw_Natrure\'; % Give path of fif files as input data
pathdataout = 'G:\Data\MEG\MEG_BIDS\'; % Path to store the data in BIDS format

% PATH to add for dependencies
addpath('C:\Users\hr17576\OneDrive - University of Essex\Software\fieldtrip-20201001'); %fieldtrip
addpath(genpath('C:\Users\hr17576\OneDrive - University of Essex\Research\MEG\MI_MEG_HR_DR\TNSRE\fieldtrip')); %fieldtrip
ft_defaults;
addpath(genpath('C:\Users\hr17576\OneDrive - University of Essex\Research\MEG\MI_MEG_HR_DR\TNSRE\functions'));

% Subject indexes
indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20];
age = [37, 36, 23, 23, 32, 28, 32, 23, 29, 26, 30, 24, 36, 27, 40, 22, 23];
sex = ['m', 'm', 'm', 'f', 'f', 'm', 'm', 'm', 'm', 'm', 'f', 'm', 'm', 'm', 'm', 'm', 'm'];

for sub=1:2%:length(indsub)
    Create a folder name  'sub-' num2str(indsub(sub))
    foldername = fullfile(pathdataout,['sub-' num2str(indsub(sub))]);
    mkdir(foldername)
    for sess = 1:2
        mkdir(fullfile(foldername,['ses-' num2str(indsub(sess))]))
        fullfilepathnameout = fullfile(foldername,['ses-' num2str(indsub(sess))],['meg']);
        mkdir(fullfilepathnameout);
                    filename  = filenames_cell{cellfun(@isempty,regexp(filenames_cell,...
                        ['P00' num2str(indsub(sub)) '_IM_B0' num2str(blk) '_S0' num2str(sess) '_(\d*)_mc.fif'],'match')) == 0};
        filenamein = ['P00' num2str(indsub(sub)) '_IM_S0' num2str(sess) '_merged.fif'];
        filenameout = ['sub-' num2str(indsub(sub)) '_ses-' num2str(sess) '_task-bcimici_meg.fif'];
        disp(['Processing ' filenamein]);
         fullfilenamein = fullfile(pathdatain,filenamein);
        fullfilenameout = fullfile(fullfilepathnameout,filenameout);
        
        
        The configuration structure should contains
        cfg.method       = 'copy';
        cfg.dataset      = fullfilenamein;
        cfg.outputfile   = fullfilenameout;
        cfg.task         = 'bcimici';
        cfg.InstitutionName = 'Ulster University';
        cfg.InstitutionalDepartmentName = 'Intelligent System research Centre';
        cfg.coordsystem.MEGCoordinateSystem = 'ElektaNeuromag';
        cfg.coordsystem.HeadCoilCoordinateSystem  = 'ElektaNeuromag';
        cfg.bidsroot                = pathdataout;
        cfg.sub                     = sub;
        cfg.ses                     = sess;
        cfg.datatype                = 'meg';
        cfg.participants.age        = age(sub);
        cfg.participants.sex        = sex(sub);
        cfg.dataset_description.Authors = {'Rathee, D., Raza, H., Roy, S., Prasad, G.'};
        cfg.TaskDescription             = 'Motor and Cognitive Imagery Tasks';
        cfg.Instructions                = 'Both hand movement, Both feet movement, Sustraction, Word';
        cfg.meg.PowerLineFrequency      = 50;
        cfg.meg.DewarPosition           = 'Upright';
        cfg.meg.RecordingType           = 'continuous';
        cfg.meg.EpochLength             = 0;
        cfg.meg.ContinuousHeadLocalization= false;
        cfg.meg.SoftwareFilters         = {"None":{"None":"None"}};
        cfg.meg.DigitizedLandmarks      = false;
        cfg.meg.DigitizedHeadPoints     = true;
        cfg.dataset_description.BIDSVersion = '1.4';
        cfg.dataset_description.Name    = 'write something here'
        cfg.dataset_description.Sponsorship = 'here as well'
        
           
        data2bids(cfg);

    end
end
