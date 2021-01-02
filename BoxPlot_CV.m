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

% acc_cv_mb = load('acc_cv_mubeta.mat');
% acc_cv_fbcsp = load('acc_cv_fbcsp.mat');
% boxplot([acc_cv_mb.cv_acc,acc_cv_fbcsp.cv_acc])

% 
acc_test_mb = load('acc_test_mubeta.mat');
acc_test_fbcsp = load('acc_test_fbcsp.mat');
% % boxplot([acc_test_mb.acc_sub, acc_test_fbcsp.acc_sub])
% 
% 
% boxplot(acc_test_mb.acc_sub,'Positions',xc-offset,'Widths',w,'Colors','r');
% boxplot(acc_test_fbcsp.acc_sub,'Positions',xc+offset,'Widths',w,'Colors','k');

% Data

x = 1:5;
y = randn(5, 3, 100);

% Plot boxplots

h = boxplot2(y,x);

% Alter linestyle and color

cmap = get(0, 'defaultaxescolororder');
for ii = 1:3
    structfun(@(x) set(x(ii,:), 'color', cmap(ii,:), ...
        'markeredgecolor', cmap(ii,:)), h);
end
set([h.lwhis h.uwhis], 'linestyle', '-');
set(h.out, 'marker', '.');