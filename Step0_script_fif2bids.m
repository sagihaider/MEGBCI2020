% Code by @ Dr Haider Raza
% School of Computing and Electronics Engineering, University of Essex, Colchester, England
% contact: h.raza@essex.ac.uk
% Date: 13/05/2019
% Last updated: 31/12/2020

% Classes: 1-Both Hand Imagery, 2-Both Feet Imagery
% 3-Word generation, 4-Subtraction
%% Close all windows, clear command prompt, and clear workspace
close all; clc;
clear;
warning off
%% PATH to data

% add filedtrip to path of your Matlab. You can download it from
% https://github.com/sagihaider/fieldtrip.git 
restoredefaultpath
addpath '/Users/sagihaider/GitHub/fieldtrip-20201001'
ft_defaults

currFolder = pwd;
addpath(genpath(currFolder));

pathdatain = '/Users/sagihaider/MEG/DataMEG_fif';
pathdataout = '/Users/sagihaider/MEG/MEG_BIDS'; % Path to store the data in BIDS format

%% Subject indexes
indsub=[1,2,3,4,6,7,9,11,12,13,14,15,16,17,18,19,20];
age = [37, 36, 23, 23, 32, 28, 32, 23, 29, 26, 30, 24, 36, 27, 40, 22, 23];
sex = ['m'; 'm'; 'm'; 'f'; 'f'; 'm'; 'm'; 'm'; 'm'; 'm'; 'f'; 'm'; 'm'; 'm'; 'm'; 'm'; 'm'];

%% Read each subject fif files to convert them into BIDS 
for sub=1:length(indsub)
    % Create a folder name  'sub-' num2str(indsub(sub))
    foldername = fullfile(pathdataout,['sub-' num2str(indsub(sub))]);
    mkdir(foldername)
    for sess = 1:2
        mkdir(fullfile(foldername,['ses-' num2str(indsub(sess))]))
        fullfilepathnameout = fullfile(foldername,['ses-' num2str(indsub(sess))],['meg']);
        mkdir(fullfilepathnameout);
        
        filenamein = ['P00' num2str(indsub(sub)) '_S0' num2str(sess) '.fif'];
        filenameout = ['sub-' num2str(indsub(sub)) '_ses-' num2str(sess) '_task-bcimici_meg.fif'];
        disp(['Processing ' filenamein]);
        
        switch sess
            case 1
                fullfilenamein = fullfile(pathdatain, 'Session_01' , filenamein);
            case 2
                fullfilenamein = fullfile(pathdatain, 'Session_02' , filenamein);
        end
        
%         hdr = ft_read_header(fullfilenamein);
%         
%         headshape = ft_read_headshape(fullfilenamein);
%         cfg.coordsystem.HeadCoilCoordinates  = {'NAS': [12.7,21.3,13.9], 'LPA': [5.2,11.3,9.6], 'RPA': [20.2,11.3,9.1]}
% cfg = [];
% cfg.method = 'headshape';
% fid = ft_electrodeplacement(headshape);
        
        %         fullfilenamein = fullfile(pathdatain,filenamein);
        fullfilenameout = fullfile(fullfilepathnameout,filenameout);
        
        
        % The configuration structure should contains
        cfg.method       = 'copy';
        cfg.dataset      = fullfilenamein;
        cfg.outputfile   = fullfilenameout;
        cfg.TaskName     = 'bcimici'; 
        cfg.InstitutionName = 'Ulster University';
        cfg.InstitutionalDepartmentName = 'Intelligent System Research Centre';
        cfg.bidsroot                = pathdataout;
        cfg.sub                     = num2str(indsub(sub));
        cfg.ses                     = num2str(sess);
        cfg.datatype                = 'meg';
        cfg.TaskDescription             = 'Motor and Cognitive Imagery Tasks';
        cfg.Instructions                = 'Both hands movement, Both feet movement, Sustraction, Word';
        
        cfg.participants.age        = age(sub);
        cfg.participants.sex        = sex(sub);

        
        % MEG Discription
        cfg.meg.SamplingFrequency             = 1000; %ft_getopt(cfg.meg, 'SamplingFrequency'           ); % REQUIRED. Sampling frequency (in Hz) of all the data in the recording, regardless of their type (e.g., 2400)
        cfg.meg.PowerLineFrequency            = 50; %ft_getopt(cfg.meg, 'PowerLineFrequency'          ); % REQUIRED. Frequency (in Hz) of the power grid at the geographical location of the MEG instrument (i.e. 50 or 60)
        cfg.meg.DewarPosition                 = 'upright'; %ft_getopt(cfg.meg, 'DewarPosition'               ); % REQUIRED. Position of the dewar during the MEG scan: "upright", "supine" or "degrees" of angle from vertical: for example on CTF systems, upright=15??, supine = 90??.
        cfg.meg.SoftwareFilters               = 'n/a'; %ft_getopt(cfg.meg, 'SoftwareFilters'             ); % REQUIRED. List of temporal and/or spatial software filters applied, orideally key:valuepairsofpre-appliedsoftwarefiltersandtheir parameter values: e.g., {"SSS": {"frame": "head", "badlimit": 7}}, {"SpatialCompensation": {"GradientOrder": Order of the gradient compensation}}. Write "n/a" if no software filters applied.
        cfg.meg.DigitizedLandmarks            = true; %ft_getopt(cfg.meg, 'DigitizedLandmarks'          ); % REQUIRED. Boolean ("true" or "false") value indicating whether anatomical landmark points (i.e. fiducials) are contained within this recording.
        cfg.meg.DigitizedHeadPoints           = true; %ft_getopt(cfg.meg, 'DigitizedHeadPoints'         ); % REQUIRED. Boolean ("true" or "false") value indicating whether head points outlining the scalp/face surface are contained within this recording.
        cfg.meg.RecordingType                 = 'continuous';
        cfg.meg.ContinuousHeadLocalization= true;
        
        % Dataset Discription
        cfg.dataset_description.Name                = 'write something here'
        cfg.dataset_description.BIDSVersion         = '1.4';
        %   cfg.dataset_description.License         = 'CCO'
        cfg.dataset_description.Authors             = {'Raza, H.', 'Rathee, D.', 'Roy, S.', 'Prasad, G.'};
        %   cfg.dataset_description.Acknowledgements    = string
        %   cfg.dataset_description.HowToAcknowledge    = string
        cfg.dataset_description.Funding             = {'InvestNI', 'DST-UKIERI-2016-17-0128', 'ESRC'};
        %   cfg.dataset_description.ReferencesAndLinks  = string or cell-array of strings
        %   cfg.dataset_description.DatasetDOI          = string
        cfg.dataset_description.Sponsorship = 'here as well';
        
        % information for the coordsystem.json file for MEG, EEG and iEEG
%         cfg.coordsystem.HeadCoilCoordinates        = {};
        cfg.coordsystem.MEGCoordinateSystem        = 'ElektaNeuromag'; % REQUIRED. Defines the coordinate system for the MEG sensors. See Appendix VIII: preferred names of Coordinate systems. If "Other", provide definition of the coordinate system in [MEGCoordinateSystemDescription].
        cfg.coordsystem.MEGCoordinateUnits         = 'cm'; %ft_getopt(cfg.coordsystem, 'MEGCoordinateUnits'                             ); % REQUIRED. Units of the coordinates of MEGCoordinateSystem. MUST be ???m???, ???cm???, or ???mm???.
        cfg.coordsystem.HeadCoilCoordinateSystem  = 'ElektaNeuromag';
        cfg.coordsystem.HeadCoilCoordinateUnits  = 'cm';
        cfg.coordsystem.HeadCoilCoordinateSystemDescription = 'Neuromag head coordinates, orientation RAS, origin between the ears';

        % %% columns in the channels.tsv
        % cfg.channels.name               = ft_getopt(cfg.channels, 'name'               , nan);  % REQUIRED. Channel name (e.g., MRT012, MEG023)
        % cfg.channels.type               = ft_getopt(cfg.channels, 'type'               , nan);  % REQUIRED. Type of channel; MUST use the channel types listed below.
        % cfg.channels.units              = ft_getopt(cfg.channels, 'units'              , nan);  % REQUIRED. Physical unit of the data values recorded by this channel in SI (see Appendix V: Units for allowed symbols).
        

        data2bids(cfg);
    end
end
