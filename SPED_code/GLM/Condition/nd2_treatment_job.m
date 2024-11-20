%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
function matlabbatch = nd2_treatment_job(outputdir,file1,file2,sp)

    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                          file1
                                                                          file2
                                                                         }';
    matlabbatch{2}.spm.stats.factorial_design.dir = {outputdir};
    
    matlabbatch{2}.spm.stats.factorial_design.des.t2.scans1(1) = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{2}.spm.stats.factorial_design.des.t2.scans2(1) = cfg_dep('Named File Selector: raw(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
    matlabbatch{2}.spm.stats.factorial_design.des.t2.dept = 0;
    matlabbatch{2}.spm.stats.factorial_design.des.t2.variance = 1;
    matlabbatch{2}.spm.stats.factorial_design.des.t2.gmsca = 0;
    matlabbatch{2}.spm.stats.factorial_design.des.t2.ancova = 0;
     
    matlabbatch{2}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{2}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{2}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{2}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{2}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{2}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{2}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{2}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = [sp];
    matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{4}.spm.stats.con.delete = 0;
end
