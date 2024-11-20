%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
function matlabbatch = Pain_1stlevel_job(ID,ExSep,outputdir,prefix,onsetdir)
            clear matlabbatch
            run01=[prefix 's8_sub-' ID '_task-' ExSep '_run-01' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
            run02=[prefix 's8_sub-' ID '_task-' ExSep '_run-02' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
            run03=[prefix 's8_sub-' ID '_task-' ExSep '_run-03' '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii'];
            onset1 = [onsetdir 'sub' ID '_' ExSep '1.mat'];A1 = load(onset1);doubleArray1 = cellfun(@double, A1.names)-48;[label_idx1,~] = BinaryData(doubleArray1); idx1 = one_zero(label_idx1);
            onset2 = [onsetdir 'sub' ID '_' ExSep '2.mat'];A2 = load(onset2);doubleArray2 = cellfun(@double, A2.names)-48;[label_idx2,~] = BinaryData(doubleArray2); idx2 = one_zero(label_idx2);
            onset3 = [onsetdir 'sub' ID '_' ExSep '3.mat'];A3 = load(onset3);doubleArray3 = cellfun(@double, A3.names)-48;[label_idx3,~] = BinaryData(doubleArray3); idx3 = one_zero(label_idx3);
            all_values = ([A1.names A2.names A3.names]); %
            unique_values = unique([all_values{:}]);
            covfiles1 = [prefix 'sub-' ID '_task-task-' ExSep '_run-01_nuis_matrix.mat'];
            covfiles2 = [prefix 'sub-' ID '_task-task-' ExSep '_run-02_nuis_matrix.mat'];
            covfiles3 = [prefix 'sub-' ID '_task-task-' ExSep '_run-03_nuis_matrix.mat'];
            matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw';
            matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                                 {run01}
                                                                                 {run02}
                                                                                 {run03}
                                                                                 }';
            matlabbatch{2}.spm.stats.fmri_spec.dir = {outputdir};
            matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
            matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
            matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 36;
            matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 18;
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi = {onset1};
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi_reg = {covfiles1};
            matlabbatch{2}.spm.stats.fmri_spec.sess(1).hpf = 128;% high-pass filter 
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).scans = cfg_dep('Named File Selector: raw(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).multi = {onset2};
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).multi_reg = {covfiles2};
            matlabbatch{2}.spm.stats.fmri_spec.sess(2).hpf = 128;
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).scans = cfg_dep('Named File Selector: raw(3) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{3}));
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).multi = {onset3};
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).multi_reg = {covfiles3};
            matlabbatch{2}.spm.stats.fmri_spec.sess(3).hpf = 128;
            matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
            matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];% HRF derivatives
            matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
            matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
            matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0;
            matlabbatch{2}.spm.stats.fmri_spec.mask = {'rGM_mask(2mm).nii'};%%%%%%%%%mask
            matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
            matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
            matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
            matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
            matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
            if length(unique_values) == 6
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = (unique_values(1));
                weight = [idx1(str2num(unique_values(1)),:) zeros(1,24) idx2(str2num(unique_values(1)),:) zeros(1,24) idx3(str2num(unique_values(1)),:) zeros(1,27)];a=length(find(weight ==1));  
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = (unique_values(2));
                weight = [idx1(str2num(unique_values(2)),:) zeros(1,24) idx2(str2num(unique_values(2)),:) zeros(1,24) idx3(str2num(unique_values(2)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = (unique_values(3));
                weight = [idx1(str2num(unique_values(3)),:) zeros(1,24) idx2(str2num(unique_values(3)),:) zeros(1,24) idx3(str2num(unique_values(3)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = (unique_values(4));
                weight = [idx1(str2num(unique_values(4)),:) zeros(1,24) idx2(str2num(unique_values(4)),:) zeros(1,24) idx3(str2num(unique_values(4)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.name = (unique_values(5));
                weight = [idx1(str2num(unique_values(5)),:) zeros(1,24) idx2(str2num(unique_values(5)),:) zeros(1,24) idx3(str2num(unique_values(5)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.sessrep = 'none';%replsc   none
                matlabbatch{4}.spm.stats.con.consess{6}.tcon.name = (unique_values(6));
                weight = [idx1(str2num(unique_values(6)),:) zeros(1,24) idx2(str2num(unique_values(6)),:) zeros(1,24) idx3(str2num(unique_values(6)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{6}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{6}.tcon.sessrep = 'none';%replsc   none
            elseif length(unique_values) == 5 
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = (unique_values(1));
                weight = [idx1(str2num(unique_values(1)),:) zeros(1,24) idx2(str2num(unique_values(1)),:) zeros(1,24) idx3(str2num(unique_values(1)),:) zeros(1,27)];a=length(find(weight ==1));  
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = (unique_values(2));
                weight = [idx1(str2num(unique_values(2)),:) zeros(1,24) idx2(str2num(unique_values(2)),:) zeros(1,24) idx3(str2num(unique_values(2)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = (unique_values(3));
                weight = [idx1(str2num(unique_values(3)),:) zeros(1,24) idx2(str2num(unique_values(3)),:) zeros(1,24) idx3(str2num(unique_values(3)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = (unique_values(4));
                weight = [idx1(str2num(unique_values(4)),:) zeros(1,24) idx2(str2num(unique_values(4)),:) zeros(1,24) idx3(str2num(unique_values(4)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.name = (unique_values(5));
                weight = [idx1(str2num(unique_values(5)),:) zeros(1,24) idx2(str2num(unique_values(5)),:) zeros(1,24) idx3(str2num(unique_values(5)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{5}.tcon.sessrep = 'none';%replsc   none
            elseif length(unique_values) == 4
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = (unique_values(1));
                weight = [idx1(str2num(unique_values(1)),:) zeros(1,24) idx2(str2num(unique_values(1)),:) zeros(1,24) idx3(str2num(unique_values(1)),:) zeros(1,27)];a=length(find(weight ==1));  
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = (unique_values(2));
                weight = [idx1(str2num(unique_values(2)),:) zeros(1,24) idx2(str2num(unique_values(2)),:) zeros(1,24) idx3(str2num(unique_values(2)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = (unique_values(3));
                weight = [idx1(str2num(unique_values(3)),:) zeros(1,24) idx2(str2num(unique_values(3)),:) zeros(1,24) idx3(str2num(unique_values(3)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.name = (unique_values(4));
                weight = [idx1(str2num(unique_values(4)),:) zeros(1,24) idx2(str2num(unique_values(4)),:) zeros(1,24) idx3(str2num(unique_values(4)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
            elseif length(unique_values) == 3
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = (unique_values(1));
                weight = [idx1(str2num(unique_values(1)),:) zeros(1,24) idx2(str2num(unique_values(1)),:) zeros(1,24) idx3(str2num(unique_values(1)),:) zeros(1,27)];a=length(find(weight ==1));  
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = (unique_values(2));
                weight = [idx1(str2num(unique_values(2)),:) zeros(1,24) idx2(str2num(unique_values(2)),:) zeros(1,24) idx3(str2num(unique_values(2)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = (unique_values(3));
                weight = [idx1(str2num(unique_values(3)),:) zeros(1,24) idx2(str2num(unique_values(3)),:) zeros(1,24) idx3(str2num(unique_values(3)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            elseif length(unique_values) == 2
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = (unique_values(1));
                weight = [idx1(str2num(unique_values(1)),:) zeros(1,24) idx2(str2num(unique_values(1)),:) zeros(1,24) idx3(str2num(unique_values(1)),:) zeros(1,27)];a=length(find(weight ==1));  
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = (unique_values(2));
                weight = [idx1(str2num(unique_values(2)),:) zeros(1,24) idx2(str2num(unique_values(2)),:) zeros(1,24) idx3(str2num(unique_values(2)),:) zeros(1,27)];a=length(find(weight ==1));
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = weight;
                matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            end             
            matlabbatch{4}.spm.stats.con.delete = 0;      
end