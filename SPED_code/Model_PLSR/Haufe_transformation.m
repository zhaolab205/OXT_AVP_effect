%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc 
load('Data\OTAVPPLC_combine_dataset.mat');
Y = double(OTAVPPLC_combine_dataset.Y_names == 2);
OTAVPPLC_combine_dataset.Y = OTAVPPLC_combine_dataset.Y .* Y;
bs_b=bootstrp(1000,@bootpls20dim,OTAVPPLC_combine_dataset.dat',OTAVPPLC_combine_dataset.Y); 
bs_b_OT = bs_b;
data1=bs_b_OT(:,2:end,:);
Haufe_pattern_OT = fast_haufe(double(OTAVPPLC_combine_dataset.dat'), double(data1(i,:)'), 500);
%%
clear,clc 
load('Data\OTAVPPLC_combine_dataset.mat');
Y = double(OTAVPPLC_combine_dataset.Y_names == 3);
OTAVPPLC_combine_dataset.Y = OTAVPPLC_combine_dataset.Y .* Y;
bs_b=bootstrp(1000,@bootpls20dim,OTAVPPLC_combine_dataset.dat',OTAVPPLC_combine_dataset.Y); 
bs_b_AVP = bs_b;
data2=bs_b_AVP(:,2:end,:);
Haufe_pattern_AVP = fast_haufe(double(OTAVPPLC_combine_dataset.dat'), double(data2(i,:)'), 500);
%%
clear,clc 
load('Data\OTAVPPLC_combine_dataset.mat');
Y = double(OTAVPPLC_combine_dataset.Y_names == 4);
OTAVPPLC_combine_dataset.Y = OTAVPPLC_combine_dataset.Y .* Y;
bs_b=bootstrp(1000,@bootpls20dim,OTAVPPLC_combine_dataset.dat',OTAVPPLC_combine_dataset.Y); 
bs_b_PLC = bs_b;
data3 = bs_b_PLC(1:300,2:end);
Haufe_pattern_PLC = fast_haufe(double(OTAVPPLC_combine_dataset.dat'), double(data3(i,:)'), 500);



