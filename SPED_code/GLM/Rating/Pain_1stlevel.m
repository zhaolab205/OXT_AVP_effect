%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
spm('defaults', 'FMRI');

subdirs = dir(fullfile('data/file'));
for i = 1:length(subdirs)   
    name = subdirs(i).name;
        ID = name(5:7);Treatment = name(6:7);
        ExSep = cell2mat(ES(tepyyy));
        outputdir = ['output/file'];
        prefix = ['data/file/subj/file'];
        onsetdir = ['onset/file'];
        matlabbatch = Pain_1stlevel_job(ID,ExSep,outputdir,prefix,onsetdir);
        spm_jobman('run', matlabbatch);
    end
end
