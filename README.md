# MEG_BCI_2020_Datatset

We have provided the MEG BCI dataset in three different file formats:

1. Functional Image File Format **(.fif)** files. To read more [click](https://www.dropbox.com/s/q58whpso2jt9tx0/Fiff.pdf?dl=0) 
2. MAT-file is the data file format MATLAB **(.mat)**. To read more [click](https://in.mathworks.com/help/matlab/import_export/mat-file-versions.html) 
3. Brain Imaging Data Structure **(BIDS)**. To read more [click](https://bids.neuroimaging.io/index.html)

In this repository, we have provided Matlab scripts for the following tasks:

1. **(.fif)** files to extract the MEG BCI data in **(.mat)** format. 

2. **(.mat)** files to extract the motor and cognitive imagery features using common spatail patterns (CSP) algorithm. 

3. A script for single-trial MEG classification to produce the baseline results. 


** Note: We have used [fieldtrip](https://www.fieldtriptoolbox.org/) toolbox for basic pre-processing of MEG BCI dataset. As a dependency we recommend to download the add fieldtrip to your Matlab path if you want to reproduce our results. 


