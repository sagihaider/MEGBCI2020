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

%% Load Data

load('acc_cv_mubeta.mat');
cv_mb = cv_acc;
load('acc_cv_fbcsp.mat');
cv_fbcsp = cv_acc;

load('acc_test_mubeta.mat');
acc_mb = acc_sub;
load('acc_test_fbcsp.mat');
acc_fbcsp = acc_sub;

[nsub,bp] = size(cv_acc); % nsub: number of subjects and bp: no.of.binary pairs


%% Code for cross-validation accuracy plot
threeD=[];
for i=1:bp
    twoD=[];
    twoD(:,1)=cv_mb(:,i);
    twoD(:,2)=cv_fbcsp(:,i);
    threeD(i,:,:)=twoD';   
end

h=boxplot2(threeD, 1:6)
xlabel('Pair-wise binary conditions')
ylabel('Classification Accuracy in %')
title('Session 1 CV accuracy (%) FB1 vs FB2')
xticklabels({'','H-F','H-W','H-S', 'F-W', 'F-S', 'W-S'})

% Alter linestyle and color

cmap = get(0, 'defaultaxescolororder');
for ii = 1:2
    structfun(@(x) set(x(ii,:), 'color', cmap(ii,:), ...
        'markeredgecolor', cmap(ii,:)), h);
end
set([h.lwhis h.uwhis], 'linestyle', '-');
set(h.out, 'marker', '.');



%% Code for session-2: test accuracy plot
% threeD=[];
% for i=1:bp
%     twoD=[];
%     twoD(:,1)=acc_mb(:,i);
%     twoD(:,2)=acc_fbcsp(:,i);
%     threeD(i,:,:)=twoD';   
% end
% a = 'l-f';
% h=boxplot2(threeD, 1:6)
% xlabel('Pair-wise binary conditions')
% ylabel('Classification Accuracy in %')
% title('Session 2 classification accuracy (%) FB1 vs FB2')
% xticklabels({'','H-F','H-W','H-S', 'F-W', 'F-S', 'W-S'})
% 
% Alter linestyle and color
% 
% cmap = get(0, 'defaultaxescolororder');
% for ii = 1:2
%     structfun(@(x) set(x(ii,:), 'color', cmap(ii,:), ...
%         'markeredgecolor', cmap(ii,:)), h);
% end
% set([h.lwhis h.uwhis], 'linestyle', '-');
% set(h.out, 'marker', '.');

%% Dheeraj Idea

% twoD=[];
% j=0;
% for i=1:bp
%     j = j+1;
%     twoD(:,j)=acc_mb(:,i);
%     j = j+1; 
%     twoD(:,j)=acc_fbcsp(:,i);
% end
% 
% boxplot(twoD)
% set(gca,'xtick',1:12,'xticklabel',{'MB' 'FBCSP' 'MB' 'FBCSP' 'MB' 'FBCSP' 'MB' 'FBCSP' 'MB' 'FBCSP' 'MB' 'FBCSP'}) 