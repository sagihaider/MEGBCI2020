function [trl_file] = fn_megbci_get_trial_details(filename,sample_before_cue,sample_after_cue)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

hdr = ft_read_header(filename);
dat = ft_read_data(filename,'header',hdr);

trigger = dat(ismember(hdr.label,'STI101'),:);
lineT1 = (trigger > 2) & (trigger < 7);
lineT1 = floor((lineT1.*trigger)/4);
lineT1 = [0 diff(lineT1)];
lineT1(lineT1<0) = 0;
onset1 = find(lineT1);

lineT2 = (trigger > 7) & (trigger < 14);
lineT2 = floor((lineT2.*trigger)/4);
lineT2 = [0 diff(lineT2)];
lineT2(lineT2<0) = 0;
onset2 = find(lineT2);

lineT3 = (trigger > 14) & (trigger < 24);
lineT3 = floor((lineT3.*trigger)/4);
lineT3 = [0 diff(lineT3)];
lineT3(lineT3<0) = 0;
onset3 = find(lineT3);

lineT4 = (trigger > 24) & (trigger < 38);
lineT4 = floor((lineT4.*trigger)/4);
lineT4 = [0 diff(lineT4)];
lineT4(lineT4<0) = 0;
onset4 = find(lineT4);

OnsetAllClass=[onset1 onset2 onset3 onset4];
tmpclasscode=[ones(1,length(onset1)) repmat(2,1,length(onset2)) repmat(3,1,length(onset3)) repmat(4,1,length(onset4))]';
[SortOnsetAllClass,indx]=sort(OnsetAllClass);
tmptrl=[SortOnsetAllClass' tmpclasscode(indx)];
trl_file = [tmptrl(:,1)-sample_before_cue+1, tmptrl(:,1)+sample_after_cue, repmat(-sample_before_cue,size(tmptrl,1),1), tmptrl(:,2)];


end

