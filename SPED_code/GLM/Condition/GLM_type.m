%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear
path='Data/file';
subdirs = dir(fullfile(path,'sub-*'));%read origin fmri data
for i = 1:length(subdirs)   
    name = subdirs(i).name; 
    ID = name(5:7);
    prefix = ['Data/file/subj/file'];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read func file
    onsetdir = ['onsets/file'];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read onsets file
    matlabbatch = GLM_type_job(ID,prefix,onsetdir);
    spm_jobman('run', matlabbatch);   
end
