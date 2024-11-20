%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
load('Data\OTAVPPLC_end_dataset.mat');
image = fmri_data('Bootstrap_end\OT_all.nii','Data\rGM_mask(2mm).nii');
subset_dat_OXT = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 2));
subset_dat_AVP = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 3));
subset_dat_PLC = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 4));
[label_idx_OXT,data_OXT] = BinaryData(subset_dat_OXT.Y);label_idx_OXT = logical(label_idx_OXT);
[label_idx_AVP,data_AVP] = BinaryData(subset_dat_AVP.Y);label_idx_AVP = logical(label_idx_AVP);
[label_idx_PLC,data_PLC] = BinaryData(subset_dat_PLC.Y);label_idx_PLC = logical(label_idx_PLC);
nlevel = 5; % 5 ratings
num =0;
for thre = 0.1:0.1:100
    num = num+1;
    abs_vec = abs(image.dat);
    threshold = prctile(abs_vec, thre);  
    vec_filtered = image.dat .* (abs(image.dat) <= threshold);
    true_ratings = subset_dat_OXT.Y;
    yhat = subset_dat_OXT.dat' * vec_filtered;
    nsub = data_OXT(end); % number of participants in the discovery cohort
    subject = repmat(1:nsub, nlevel,1);subject = subject(:);subject = subject(label_idx_OXT);
    within_subj_corrs = zeros(nsub, 1);
    within_subj_rmse = zeros(nsub, 1);
    for i = 1:nsub
        subY = true_ratings(subject==i);
        subyfit = yhat(subject==i);
        [within_subj_corrs(i, 1)] = corr(subY, subyfit, 'Type', 'Pearson');
        err = subY - subyfit;
        mse = (err' * err)/length(err);
        within_subj_rmse(i, 1) = sqrt(mse);
    end
    Output_within_r(num,1) = mean(within_subj_corrs);
    Output_within_rmse(num,1) = mean(within_subj_rmse);
    true_ratings = subset_dat_AVP.Y;
    yhat = subset_dat_AVP.dat' * vec_filtered;
    nsub = data_AVP(end); % number of participants in the discovery cohort
    subject = repmat(1:nsub, nlevel,1);subject = subject(:);subject = subject(label_idx_AVP);
    within_subj_corrs = zeros(nsub, 1);
    within_subj_rmse = zeros(nsub, 1);
    for i = 1:nsub
        subY = true_ratings(subject==i);
        subyfit = yhat(subject==i);
        [within_subj_corrs(i, 1)] = corr(subY, subyfit, 'Type', 'Pearson');
        err = subY - subyfit;
        mse = (err' * err)/length(err);
        within_subj_rmse(i, 1) = sqrt(mse);
    end
    Output_within_r(num,2) = mean(within_subj_corrs);
    Output_within_rmse(num,2) = mean(within_subj_rmse);
    true_ratings = subset_dat_PLC.Y;
    yhat = subset_dat_PLC.dat' * vec_filtered;
    nsub = data_PLC(end); % number of participants in the discovery cohort
    subject = repmat(1:nsub, nlevel,1);subject = subject(:);subject = subject(label_idx_PLC);
    within_subj_corrs = zeros(nsub, 1);
    within_subj_rmse = zeros(nsub, 1);
    for i = 1:nsub
        subY = true_ratings(subject==i);
        subyfit = yhat(subject==i);
        [within_subj_corrs(i, 1)] = corr(subY, subyfit, 'Type', 'Pearson');
        err = subY - subyfit;
        mse = (err' * err)/length(err);
        within_subj_rmse(i, 1) = sqrt(mse);
    end
    Output_within_r(num,3) = mean(within_subj_corrs);
    Output_within_rmse(num,3) = mean(within_subj_rmse);
end
percentages = linspace(0, 100, 1000);
figure;
hold on;
plot(percentages, Output_within_r(:,1), '-o', 'DisplayName', 'Line 1', 'LineWidth', 1.5, 'Color', [55 183 158]/255);
plot(percentages, Output_within_r(:,2), '-x', 'DisplayName', 'Line 2', 'LineWidth', 1.5, 'Color', [69 76 160]/255);
plot(percentages, Output_within_r(:,3), '-s', 'DisplayName', 'Line 3', 'LineWidth', 1.5, 'Color', [73 46 87]/255);
%%
window_size = 50;
diff_data = abs(diff(Output_within_r));
threshold = 0.001;
for i = 1:(1000 - window_size)
    window_diff = diff_data(i:i+window_size-1, :);
    mean_window_diff = mean(mean(window_diff, 1));
    if all(mean_window_diff < threshold)
        stable_point = i
        break;
    end
end