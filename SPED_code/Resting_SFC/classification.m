%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
path = ['SFC_data/'];
subj = dir(fullfile(path,'SFC*'));
mask_all = dir(fullfile('mask/file'));
OXT_Group = [19:29,31:35,87:89,91:95,97:103];
AVP_Group = [37:44,46:52,105:120];
PLC_Group = [53:54,56:57,59:66,68:70,121:137];
num = 0;O_data = zeros(length(OXT_Group),(length(mask_all)^2-length(mask_all))/2);
for sub_num = OXT_Group
    num = num+1;
    load(['SFC_data\' subj(sub_num).name])
    curr_dat = SFC_mat_z;
    O_data(num,:) = curr_dat(tril(true(size(curr_dat)), -1))';
end
num = 0;A_data = zeros(length(AVP_Group),(length(mask_all)^2-length(mask_all))/2);
for sub_num = AVP_Group
    num = num+1;
    load(['SFC_data\' subj(sub_num).name])
    curr_dat = SFC_mat_z;
    A_data(num,:) = curr_dat(tril(true(size(curr_dat)), -1))';
end
num = 0;P_data = zeros(length(PLC_Group),(length(mask_all)^2-length(mask_all))/2);
for sub_num = PLC_Group
    num = num+1;
    load(['SFC_data\' subj(sub_num).name])
    curr_dat = SFC_mat_z;
    P_data(num,:) = curr_dat(tril(true(size(curr_dat)), -1))';
end
%% classification
X = [A_data; P_data]; % feature A_data; 
Y = [ones(31, 1);  2*ones(31, 1)]; % label 2*ones(31, 1);
X = zscore(X);
for KFold_time = 1:1000
    cv = cvpartition(Y, 'KFold', 10, 'Stratify', true);
    accuracies = zeros(cv.NumTestSets, 1);
    for k = 1:cv.NumTestSets
        trainIdx = training(cv, k);
        testIdx = test(cv, k);
        X_train = X(trainIdx, :);
        Y_train = Y(trainIdx);
        X_test = X(testIdx, :);
        Y_test = Y(testIdx);
        svmModel = fitcsvm(X_train, Y_train, 'Standardize', true, 'KernelFunction', 'linear');
        Y_pred = predict(svmModel, X_test);
        accuracy = sum(Y_pred == Y_test) / numel(Y_test);
        accuracies(k) = accuracy;
    end
    acc(KFold_time) = mean(accuracies);
end
%%
clear,clc
[~, ~, raw] = xlsread('Acc_data.xlsx');
mean(cell2mat(raw(:,3)))
std(cell2mat(raw(:,3)))
%% 10000 boot
X = [O_data; P_data]; % feature A_data; 
Y = [ones(31, 1);  2*ones(32, 1)]; % label 2*ones(31, 1);
bs_b=bootstrp(10000,@bootsvm,X,Y); 

