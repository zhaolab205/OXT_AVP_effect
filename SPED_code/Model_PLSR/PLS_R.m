%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
%% OXT
clear,clc 
load('Data\OTAVPPLC_end_dataset.mat');
subset_dat_OXT = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 2));
bs_b=bootstrp(10000,@bootpls20dim,subset_dat_OXT.dat',subset_dat_OXT.Y); 
bs_b_OT_PLC = bs_b;
r_bs_b=bs_b_OT_PLC(:,2:end,:);
b_mean_coeff = (mean(r_bs_b));
b_ste_coeff = (std(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);
%% AVP
clear,clc 
load('Data\OTAVPPLC_end_dataset.mat');
subset_dat_AVP = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 3));
bs_b=bootstrp(10000,@bootpls20dim,subset_dat_AVP.dat',subset_dat_AVP.Y); 
bs_b_OT_PLC = bs_b;
r_bs_b=bs_b_OT_PLC(:,2:end,:);
b_mean_coeff = (mean(r_bs_b));
b_ste_coeff = (std(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);
%% PLC
clear,clc 
load('Data\OTAVPPLC_end_dataset.mat');
subset_dat_PLC = get_wh_image(OTAVPPLC_end_dataset, find(OTAVPPLC_end_dataset.Y_names == 4));
bs_b=bootstrp(10000,@bootpls20dim,subset_dat_PLC.dat',subset_dat_PLC.Y); 
bs_b_OT_PLC = bs_b;
r_bs_b=bs_b_OT_PLC(:,2:end,:);
b_mean_coeff = (mean(r_bs_b));
b_ste_coeff = (std(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);

