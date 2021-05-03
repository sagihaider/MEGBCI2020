# MEGBCI2020

We release a 306-channel MEG-BCI data recorded at 1KHz sampling frequency during four mental imagery tasks (i.e. hand imagery, feet imagery, subtraction imagery, and word generation imagery). The dataset contains two sessions of MEG recordings performed on separate days from 17 healthy participants using a typical BCI imagery paradigm. The current dataset will be the only publicly available MEG imagery BCI dataset as per our knowledge. The dataset can be used by the scientific community towards the development of novel pattern recognition machine learning methods to detect brain activities related to MI and CI tasks using MEG signals.

Dataset and Article Links:

```
Dataset: https://doi.org/10.6084/m9.figshare.c.5101544&#x201D 

Article: https://doi.org/10.1038/s41597-021-00899-7 
```

We have provided the MEG BCI dataset in two different file formats:

1. Brain Imaging Data Structure **(BIDS)**. To read more [click](https://bids.neuroimaging.io/index.html) and under BIDS format the raw data is avialable in Functional Image File Format **(.fif)** files. To read more [click](https://www.dropbox.com/s/q58whpso2jt9tx0/Fiff.pdf?dl=0) 
2. MAT-file is the data file format MATLAB **(.mat)**. To read more [click](https://in.mathworks.com/help/matlab/import_export/mat-file-versions.html) 

In this repository, we have provided Matlab scripts for the following tasks:

1. **Step0_script_fif2bids.m** :  Script to convert MEG data from Elekta MEG format (.fif) to .MAT format. 

2. **Step1_script_bids2mat.m** :  Script to convert MEG data from BIDS format to .MAT format. 

3. **Step2_script_mat2features.m** :Script to extract the motor and cognitive imagery features using common spatial patterns (CSP) algorithm. 

4. **Step3_script_ClassifyFeatures.m** :Script for single-trial MEG classification to produce the baseline results. 


** Note: We have used [fieldtrip](https://www.fieldtriptoolbox.org/) toolbox for basic pre-processing of MEG BCI dataset. As a dependency we recommend to download and add fieldtrip to your Matlab path if you want to reproduce our results. 


***
References:

Please cite our work: 
```
@article{Rathee2021,
title = {{A magnetoencephalography dataset for motor and cognitive imagery-based brain-computer interface}},
author = {Rathee, Dheeraj and Raza, Haider and Roy, Sujit and Prasad, Girijesh},
doi = {10.1038/s41597-021-00899-7},
issn = {2052-4463},
journal = {Scientific Data},
number = {1},
pages = {120},
url = {https://doi.org/10.1038/s41597-021-00899-7},
volume = {8},
year = {2021}
}
```
