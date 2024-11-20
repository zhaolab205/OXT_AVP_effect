%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
load('Data\OTAVPPLC_end_dataset.mat');
subset_dat_OXT = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 2));
subset_dat_AVP = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 3));
subset_dat_PLC = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 4));
[label_idx_OXT,data_OXT] = BinaryData(subset_dat_OXT.Y);label_idx_OXT = logical(label_idx_OXT);
[label_idx_AVP,data_AVP] = BinaryData(subset_dat_AVP.Y);label_idx_AVP = logical(label_idx_AVP);
[label_idx_PLC,data_PLC] = BinaryData(subset_dat_PLC.Y);label_idx_PLC = logical(label_idx_PLC);
%% OXT
nsub = data_OXT(end); % number of participants in the discovery cohort
nrepeat = 10; % for 10×10 cross-validation
nlevel = 5; % 5 ratings
yhat = zeros(length(subset_dat_OXT.Y),nrepeat);
for repeat = 1:nrepeat
    CVindex = GenerateCV(nsub, nlevel, repeat); 
    CVindex = CVindex(label_idx_OXT);
    for i =1:10
        sub_ind=find(CVindex==i);
        xtrain=subset_dat_OXT.dat(:,CVindex~=i);
        ytrain= subset_dat_OXT.Y(CVindex~=i);
        xtest=subset_dat_OXT.dat(:,sub_ind);
        [xl,yl,xs,ys,b_pls,pctvar] = plsregress(xtrain', ytrain, 20);
        PE = [ones(length(find(sub_ind)),1) xtest'] * b_pls;
        yhat(sub_ind,repeat) = PE;
    end
end
[xl,yl,xs,ys,b_pls,pctvar] = plsregress(subset_dat_OXT.dat', subset_dat_OXT.Y, 20);
yhat2 = [ones(length(find(data_AVP)),1) subset_dat_AVP.dat'] * b_pls;
yhat3 = [ones(length(find(data_PLC)),1) subset_dat_PLC.dat'] * b_pls;
%% AVP
nsub = data_AVP(end); % number of participants in the discovery cohort
nrepeat = 10; % for 10×10 cross-validation
nlevel = 5; % 5 ratings
yhat = zeros(length(subset_dat_AVP.Y),nrepeat);
for repeat = 1:nrepeat
    CVindex = GenerateCV(nsub, nlevel, repeat); 
    CVindex = CVindex(label_idx_AVP);
    for i =1:10
        sub_ind=find(CVindex==i);
        xtrain=subset_dat_AVP.dat(:,CVindex~=i);
        ytrain= subset_dat_AVP.Y(CVindex~=i);
        xtest=subset_dat_AVP.dat(:,sub_ind);
        [xl,yl,xs,ys,b_pls,pctvar] = plsregress(xtrain', ytrain, 20);
        PE = [ones(length(find(sub_ind)),1) xtest'] * b_pls;
        yhat(sub_ind,repeat) = PE;
    end
end
[xl,yl,xs,ys,b_pls,pctvar] = plsregress(subset_dat_AVP.dat', subset_dat_AVP.Y, 20);
yhat2 = [ones(length(find(data_OXT)),1) subset_dat_OXT.dat'] * b_pls;
yhat3 = [ones(length(find(data_PLC)),1) subset_dat_PLC.dat'] * b_pls;
%% PLC
nsub = data_PLC(end); % number of participants in the discovery cohort
nrepeat = 10; % for 10×10 cross-validation
nlevel = 5; % 5 ratings
yhat = zeros(length(subset_dat_PLC.Y),nrepeat);
for repeat = 1:nrepeat
    CVindex = GenerateCV(nsub, nlevel, repeat); 
    CVindex = CVindex(label_idx_PLC);
    for i =1:10
        sub_ind=find(CVindex==i);
        xtrain=subset_dat_PLC.dat(:,CVindex~=i);
        ytrain= subset_dat_PLC.Y(CVindex~=i);
        xtest=subset_dat_PLC.dat(:,sub_ind);
        [xl,yl,xs,ys,b_pls,pctvar] = plsregress(xtrain', ytrain, 20);
        PE = [ones(length(find(sub_ind)),1) xtest'] * b_pls;
        yhat(sub_ind,repeat) = PE;
    end
end
[xl,yl,xs,ys,b_pls,pctvar] = plsregress(subset_dat_PLC.dat', subset_dat_PLC.Y, 20);
yhat2 = [ones(length(find(data_OXT)),1) subset_dat_OXT.dat'] * b_pls;
yhat3 = [ones(length(find(data_AVP)),1) subset_dat_AVP.dat'] * b_pls;
%% prediction-outcome corrs
true_ratings = subset_dat_OXT.Y;
subject = repmat(1:nsub, nlevel,1);subject = subject(:);subject = subject(label_idx_OXT);
within_subj_corrs = zeros(nsub, 2);
within_subj_rmse = zeros(nsub, 1);
for i = 1:nsub
    subY = true_ratings(subject==i);
    subyfit = yhat(subject==i);
    [within_subj_corrs(i, 1)] = corr(subY, subyfit, 'Type', 'Pearson');
    err = subY - subyfit;
    mse = (err' * err)/length(err);
    within_subj_rmse(i, 1) = sqrt(mse);
end
mean(corr(yhat, true_ratings))
std(corr(yhat, true_ratings)) / sqrt(length(corr(yhat, true_ratings)))
mean(within_subj_corrs)
std(within_subj_corrs) / sqrt(length(within_subj_corrs))
mean(within_subj_rmse)
std(within_subj_rmse) / sqrt(length(within_subj_rmse))
[r, p_value] = corr(yhat2, subset_dat_AVP.Y, 'Type', 'Pearson')
[r, p_value] = corr(yhat3, subset_dat_AVP.Y, 'Type', 'Pearson')
corr(yhat2, subset_dat_OXT.Y)
corr(yhat3, subset_dat_AVP.Y)
prediction_outcome = Reshape(mean(yhat,2),label_idx_OXT,data_OXT);
true_outcome = Reshape(mean(subset_dat_OXT.Y,2),label_idx_OXT,data_OXT);
xlswrite('F:\Python\prediction_outcome.xlsx', prediction_outcome , 1);
xlswrite('F:\Python\true_outcome.xlsx', true_outcome , 1);
    %% classifications
    Accuracy_per_level = zeros(nrepeat, 4);
    Accuracy_se_per_level = zeros(nrepeat, 4);
    Accuracy_p_per_level = zeros(nrepeat, 4);
    Accuracy_low_medium_high = zeros(nrepeat, 3);
    Accuracy_se_low_medium_high = zeros(nrepeat, 3);
    Accuracy_p_low_medium_high = zeros(nrepeat, 3);
    for n = 1:nrepeat
        PEE = yhat(:, n);
        num_1 = 0;PE_new = zeros(length(label_idx_PLC), 1);
        for xx = 1:length(label_idx_PLC)
            if label_idx_PLC(xx) == 1
                num_1 = num_1+1;
                PE_new(xx,1) = PEE(num_1,1);
            else
                PE_new(xx,1) = NaN;
            end
        end

        PE_new = reshape(PE_new, [5, nsub])';
        PE_low = nanmean(PE_new(:, 1:2), 2);
        PE_medium = PE_new(:, 3);
        PE_high = nanmean(PE_new(:, 4:5), 2);
        % level 2 vs. 1
        ROC = roc_plot([PE_new(:, 2);PE_new(:,1)], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_per_level(n, 1) = ROC.accuracy;
        Accuracy_se_per_level(n, 1) = ROC.accuracy_se;
        Accuracy_p_per_level(n, 1) = ROC.accuracy_p;
        % level 3 vs. 2
        ROC = roc_plot([PE_new(:, 3);PE_new(:,2)], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_per_level(n, 2) = ROC.accuracy;
        Accuracy_se_per_level(n, 2) = ROC.accuracy_se;
        Accuracy_p_per_level(n, 2) = ROC.accuracy_p;
        % level 4 vs. 3
        ROC = roc_plot([PE_new(:, 4);PE_new(:,3)], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_per_level(n, 3) = ROC.accuracy;
        Accuracy_se_per_level(n, 3) = ROC.accuracy_se;
        Accuracy_p_per_level(n, 3) = ROC.accuracy_p;
        % level 5 vs. 4
        ROC = roc_plot([PE_new(:, 5);PE_new(:,4)], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');  
        Accuracy_per_level(n, 4) = ROC.accuracy;
        Accuracy_se_per_level(n, 4) = ROC.accuracy_se;
        Accuracy_p_per_level(n, 4) = ROC.accuracy_p;
        % low vs. medium
        ROC = roc_plot([PE_medium;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_low_medium_high(n,1) = ROC.accuracy;
        Accuracy_se_low_medium_high(n,1) = ROC.accuracy_se;
        Accuracy_p_low_medium_high(n,1) = ROC.accuracy_p;
        % medium vs. high
        ROC = roc_plot([PE_high;PE_medium], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_low_medium_high(n,2) = ROC.accuracy;
        Accuracy_se_low_medium_high(n,2) = ROC.accuracy_se;
        Accuracy_p_low_medium_high(n,2) = ROC.accuracy_p;
        % low vs. high
        ROC = roc_plot([PE_high;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice','noplot','nooutput');
        Accuracy_low_medium_high(n,3) = ROC.accuracy;
        Accuracy_se_low_medium_high(n,3) = ROC.accuracy_se;
        Accuracy_p_low_medium_high(n,3) = ROC.accuracy_p;
    end
    mean(Accuracy_per_level) 
    mean(Accuracy_p_per_level)
    mean(Accuracy_low_medium_high) 
    mean(Accuracy_p_low_medium_high)
    ddddd = [0.0000    0.0031         0];
    mafdr(ddddd, 'BHFDR','T')
    %% plot
    
    create_figure('Whole-brain Prediction');
%     prediction_outcome_OXT = Reshape(mean(yhat,2),label_idx_OXT,data_OXT);
    prediction_outcome_AVP = Reshape(mean(yhat2,2),label_idx_AVP,data_AVP);
    prediction_outcome_PLC = Reshape(mean(yhat3,2),label_idx_PLC,data_PLC);
%     lineplot_columns(prediction_outcome_OXT, 'color', [55 183 158]/255, 'markerfacecolor', [55 183 158]/255,'w',2);
    lineplot_columns(prediction_outcome_AVP, 'color', [69 76 160]/255, 'markerfacecolor', [69 76 160]/255,'w',2);
    lineplot_columns(prediction_outcome_PLC, 'color', [73 46 87]/255, 'markerfacecolor', [73 46 87]/255,'w',2);
    
    xlabel('True Rating');ylabel('Averaged prediction')
    set(gca,'FontSize',20);set(gca,'linewidth', 2);set(gca, 'XTick', 1:5)
    xlim([0.8 5.2])
    ylim([0 5])
    set(gcf, 'Color', 'w');

