function x2D = f_3D_2_2D_MEG(x)

% Code by @ Dr Haider Raza
% Institute for Analytics and Data Science, School of Computing and
% Electronics Engineering, University of Essex, Colchester, England
% contact: h.raza@essex.ac.uk
% Date: 13/05/2019

% x2D = f_3D_2_2D_MEG(x): Convert the 3D MEG trial to 2D

x2D=[];
[nrow ,ncells]=size(x);
for i = 1:ncells    
    x2D = [x2D, x{nrow,i}];    
end
