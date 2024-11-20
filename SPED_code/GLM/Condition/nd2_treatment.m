%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
subdirs = dir(fullfile(['1st_condition/file/subj']));%读原始文件
num1 = 0;
for i = [37:44,46:52,105:120] %OXT [19:29,31:35,87:89,91:95,97:103] AVP [37:44,46:52,105:120] PLC [53:54,56:57,59:66,68:70,121:137]
    num1 = num1+1;
    file1(num1,1) = cellstr([subdirs(1).folder '\' subdirs(i).name '\con_0001.nii']);
    num1 = num1+1;
    file1(num1,1) = cellstr([subdirs(1).folder '\' subdirs(i).name '\con_0006.nii']);
end
num2 = 0;
for i = [53:54,56:57,59:66,68:70,121:137] %PLC
    num2 = num2+1;
    file2(num2,1) = cellstr([subdirs(1).folder '\' subdirs(i).name '\con_0001.nii']);
    num2 = num2+1;
    file2(num2,1) = cellstr([subdirs(1).folder '\' subdirs(i).name '\con_0006.nii']);
end
outputdir = 'output/file';
sp = 'AVP-PLC'; 
matlabbatch = nd2_treatment_job(outputdir,file1,file2,sp);
spm_jobman('run', matlabbatch);
