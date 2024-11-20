%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
function matlabbatch = GLM_type_job(ID,prefix,onsetdir)
        outputdir = ['output/file'];
        run01=[prefix 's8_sub-' ID '_task-ex'  '_run-01' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        run02=[prefix 's8_sub-' ID '_task-ex'  '_run-02' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        run03=[prefix 's8_sub-' ID '_task-ex'  '_run-03' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        run04=[prefix 's8_sub-' ID '_task-sep'  '_run-01' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        run05=[prefix 's8_sub-' ID '_task-sep'  '_run-02' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        run06=[prefix 's8_sub-' ID '_task-sep'  '_run-03' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
        
        onset{1} = [onsetdir 'sub' ID '_ex'  '1.mat'];
        onset{2} = [onsetdir 'sub' ID '_ex'  '2.mat'];
        onset{3} = [onsetdir 'sub' ID '_ex'  '3.mat'];
        onset{4} = [onsetdir 'sub' ID '_sep'  '1.mat'];
        onset{5} = [onsetdir 'sub' ID '_sep'  '2.mat'];
        onset{6} = [onsetdir 'sub' ID '_sep'  '3.mat'];
        covfiles{1} = [prefix 'sub-' ID '_task-task-ex'  '_run-01_nuis_matrix.mat'];
        covfiles{2} = [prefix 'sub-' ID '_task-task-ex'  '_run-02_nuis_matrix.mat'];
        covfiles{3} = [prefix 'sub-' ID '_task-task-ex'  '_run-03_nuis_matrix.mat'];
        covfiles{4} = [prefix 'sub-' ID '_task-task-sep'  '_run-01_nuis_matrix.mat'];
        covfiles{5} = [prefix 'sub-' ID '_task-task-sep'  '_run-02_nuis_matrix.mat'];
        covfiles{6} = [prefix 'sub-' ID '_task-task-sep'  '_run-03_nuis_matrix.mat'];

        matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw';
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                             {run01}%%%%%%%%%%%%%%
                                                                             {run02}%%%%%%%%%%%%%%%%%%
                                                                             {run03}%%%%%%%%%%%%%%
                                                                             {run04}%%%%%%%%%%%%%%
                                                                             {run05}%%%%%%%%%%%%%%%%%%
                                                                             {run06}%%%%%%%%%%%%%%
                                                                             }';
        matlabbatch{2}.spm.stats.fmri_spec.dir = {outputdir};
        matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 36;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 18;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi = {cell2mat(onset(1))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi_reg = {cell2mat(covfiles(1))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(1).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).scans = cfg_dep('Named File Selector: raw(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).multi = {cell2mat(onset(2))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).multi_reg = {cell2mat(covfiles(2))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(2).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).scans = cfg_dep('Named File Selector: raw(3) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{3}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).multi = {cell2mat(onset(3))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).multi_reg = {cell2mat(covfiles(3))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(3).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).scans = cfg_dep('Named File Selector: raw(4) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{4}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).multi = {cell2mat(onset(4))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).multi_reg = {cell2mat(covfiles(4))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(4).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).scans = cfg_dep('Named File Selector: raw(5) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{5}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).multi = {cell2mat(onset(5))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).multi_reg = {cell2mat(covfiles(5))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(5).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).scans = cfg_dep('Named File Selector: raw(6) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{6}));
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).multi = {cell2mat(onset(6))};%%%%%%%%%%%%%%%%
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).multi_reg = {cell2mat(covfiles(6))};
        matlabbatch{2}.spm.stats.fmri_spec.sess(6).hpf = 128;
        
        matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0;
        matlabbatch{2}.spm.stats.fmri_spec.mask = {'E:\PAIN\Control_group_artical\VIES\Data\rGM_mask(2mm).nii'};
        matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
        
        matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
        
        matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
            matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'Exclusion';
            matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 zeros(1,24) 1 0 0 0 zeros(1,24) 1 0 0 0 zeros(1,24) zeros(1,90)];
            matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'Inclusion';
            matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 zeros(1,24) 0 1 0 0 zeros(1,24) 0 1 0 0 zeros(1,24) zeros(1,90)];
            matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = 'Control';
            matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 zeros(1,24) 0 0 1 0 zeros(1,24) 0 0 1 0 zeros(1,24) zeros(1,90)];
            matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = 'Exclusion-Control';
            matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = [1 0 -1 0 zeros(1,24) 1 0 -1 0 zeros(1,24) 1 0 -1 0 zeros(1,24) zeros(1,90)];
            matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{5}.tcon.name = 'Inclusion-Control';
            matlabbatch{4}.spm.stats.con.consess{5}.tcon.weights = [0 1 -1 0 zeros(1,24) 0 1 -1 0 zeros(1,24) 0 1 -1 0 zeros(1,24) zeros(1,90)];
            matlabbatch{4}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
            
            
            matlabbatch{4}.spm.stats.con.consess{6}.tcon.name = 'Separation';
            matlabbatch{4}.spm.stats.con.consess{6}.tcon.weights = [zeros(1,84) 1 0 0 0 zeros(1,24) 1 0 0 0 zeros(1,24) 1 0 0 0 zeros(1,30) ];
            matlabbatch{4}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{7}.tcon.name = 'Company';
            matlabbatch{4}.spm.stats.con.consess{7}.tcon.weights = [zeros(1,84) 0 1 0 0 zeros(1,24) 0 1 0 0 zeros(1,24) 0 1 0 0 zeros(1,30) ];
            matlabbatch{4}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{8}.tcon.name = 'Control';
            matlabbatch{4}.spm.stats.con.consess{8}.tcon.weights = [zeros(1,84) 0 0 1 0 zeros(1,24) 0 0 1 0 zeros(1,24) 0 0 1 0 zeros(1,30) ];
            matlabbatch{4}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{9}.tcon.name = 'Separation-Control';
            matlabbatch{4}.spm.stats.con.consess{9}.tcon.weights = [zeros(1,84) 1 0 -1 0 zeros(1,24) 1 0 -1 0 zeros(1,24) 1 0 -1 0 zeros(1,30) ];
            matlabbatch{4}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
            matlabbatch{4}.spm.stats.con.consess{10}.tcon.name = 'Company-Control';
            matlabbatch{4}.spm.stats.con.consess{10}.tcon.weights = [zeros(1,84) 0 1 -1 0 zeros(1,24) 0 1 -1 0 zeros(1,24) 0 1 -1 0 zeros(1,30) ];
            matlabbatch{4}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
        
        matlabbatch{4}.spm.stats.con.delete = 0;
end