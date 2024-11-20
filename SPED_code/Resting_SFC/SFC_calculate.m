%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
path = ['resting/data/'];
subj = dir(fullfile(path,'sub*'));
for sub_num = 1:length(subj)
    load(['resting/data/subj/data/'])
    SFC_mat = corr(sub_re_data');
    SFC_mat_z = fisherZ(SFC_mat);
    save('output/file');
    clear sub_re_data SFC_mat
end


