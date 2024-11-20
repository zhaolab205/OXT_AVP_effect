%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
clear,clc
%gene_name = {'OXTR','CD38','OXT','DRD1','DRD2','DRD3','DRD4','DRD5','COMT','CHRM1','CHRM2','CHRM3','CHRM4','CHRM5','AVPR1A','AVPR1B','OPRM1','OPRD1','OPRK1'};
gene_name = {'AVPI1','AVPR2','AVP'};
[~, ~, probe] = xlsread('Probes.csv');
for gene_num = 1:length(gene_name)
    num = 0;
    PROBE_NUM = [];
    for i = 1:length(probe)
        if strcmp(probe{i,4},gene_name{gene_num})
            num = num+1;
            PROBE_NUM(num) = probe{i,1};
        end
    end
    for j = 1:length(PROBE_NUM)
        create_expression_map('Gene/subs/normalized_microarray_donor9861', PROBE_NUM(j), 'linear', ['Gene/Gene_network/9861/' gene_name{gene_num}]);
    end
end

%% PLSR gene analysis
clear,clc
load('Gene\regional_expression');
X=gene_regional_expression'; % Predictors
Y=A_SPED_regional_expression'; % Response variable
X=zscore(X);
Y=zscore(Y);

%perform full PLS and plot variance in Y explained by top 15 components
%typically top 2 or 3 components will explain a large part of the variance
%(hopefully!)
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Y);
dim=22;
figure;
plot(1:dim,(100*PCTVAR(2,1:dim)),'-o','LineWidth',1.5,'Color',[140/255,0,0]);
set(gca,'Fontsize',14)
xlabel('Number of PLS components','FontSize',14);
ylabel('Percent Variance Explained in Y','FontSize',14);
grid on

dim=2;
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Y,dim); % no need to do this but it keeps outputs tidy
%%% plot correlation of PLS component 1 with t-statistic (from Cobre as an example):
figure
plot(XS(:,1),Y,'r.', 'MarkerSize',20)
% Compute and plot the regression line
% Fit a linear model
p = polyfit(XS(:,1), Y, 1);
% Compute the fitted values
Yfit = polyval(p, XS(:,1));
hold on
plot(XS(:,1), Yfit, 'b-', 'LineWidth', 2); % 'b-' is the blue line with width 2
% legend('Data points', 'Fit line', 'Location', 'Best');
hold off
[R,p]=corrcoef(XS(:,1),Y) 
xlabel('XS scores for PLS component 1','FontSize',14);
ylabel('Cobre t-statistic- lh','FontSize',14);
grid on
% permutation testing to assess significance of PLS result as a function of
% the number of components (dim) included:

rep=1000;
for dim=1:22
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Y,dim);
temp=cumsum(100*PCTVAR(2,1:dim));
Rsquared = temp(dim);
    for j=1:rep
        %j
        order=randperm(size(Y,1));
        Yp=Y(order,:);

        [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Yp,dim);

        temp=cumsum(100*PCTVAR(2,1:dim));
        Rsq(j) = temp(dim);
    end
dim;
R(dim)=Rsquared;
p(dim)=length(find(Rsq>=Rsquared))/rep;
end
figure 
plot(1:dim, p,'ok','MarkerSize',8,'MarkerFaceColor','r');
xlabel('Number of PLS components','FontSize',14);
ylabel('p-value','FontSize',14);
grid on

dim=2;
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Y,dim);

%% Bootstrap to get the gene list
clear,clc
load('Gene\regional_expression');
X=gene_regional_expression'; % Predictors
Y=A_SPED_regional_expression'; % Response variable
X=zscore(X);
Y=zscore(Y);
Gene = dir(fullfile(['F:\OT_AVP\Gene\Gene_network_flirt\mean_gene_expression'], '\r*'));
for i = 1:numel(Gene)
    tokens = regexp(Gene(i).name, '^r(.*?)_', 'tokens');
    if ~isempty(tokens)
        genes{i} = tokens{1}{1};
    else
        genes{i} = ''; 
    end
end
% genes=genes20647; % this needs to be imported first
geneindex=1:22;

%number of bootstrap iterations:
bootnum=10000;

% Do PLS in 2 dimensions (with 2 components):
dim=2;
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(X,Y,dim);

%store regions' IDs and weights in descending order of weight for both components:
[R1,p1]=corr([XS(:,1),XS(:,2)],Y);

%align PLS components with desired direction for interpretability 
if R1(1,1)<0  %this is specific to the data shape we were using - will need ammending
    stats.W(:,1)=-1*stats.W(:,1);
    XS(:,1)=-1*XS(:,1);
end
if R1(2,1)<0 %this is specific to the data shape we were using - will need ammending
    stats.W(:,2)=-1*stats.W(:,2);
    XS(:,2)=-1*XS(:,2);
end

[PLS1w,x1] = sort(stats.W(:,1),'descend');
PLS1ids=genes(x1);
geneindex1=geneindex(x1);
[PLS2w,x2] = sort(stats.W(:,2),'descend');
PLS2ids=genes(x2);
geneindex2=geneindex(x2);

%print out results
% csvwrite('PLS1_ROIscores.csv',XS(:,1));
% csvwrite('PLS2_ROIscores.csv',XS(:,2));

%define variables for storing the (ordered) weights from all bootstrap runs
PLS1weights=[];
PLS2weights=[];

%start bootstrap
for i=1:bootnum
    myresample = randsample(size(X,1),size(X,1),1);
    res(i,:)=myresample; %store resampling out of interest
    Xr=X(myresample,:); % define X for resampled subjects
    Yr=Y(myresample,:); % define X for resampled subjects
    [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(Xr,Yr,dim); %perform PLS for resampled data
      
    temp=stats.W(:,1);%extract PLS1 weights
    newW=temp(x1); %order the newly obtained weights the same way as initial PLS 
    if corr(PLS1w,newW)<0 % the sign of PLS components is arbitrary - make sure this aligns between runs
        newW=-1*newW;
    end
    PLS1weights=[PLS1weights,newW];%store (ordered) weights from this bootstrap run
    
    temp=stats.W(:,2);%extract PLS2 weights
    newW=temp(x2); %order the newly obtained weights the same way as initial PLS 
    if corr(PLS2w,newW)<0 % the sign of PLS components is arbitrary - make sure this aligns between runs
        newW=-1*newW;
    end
    PLS2weights=[PLS2weights,newW]; %store (ordered) weights from this bootstrap run    
end

%get standard deviation of weights from bootstrap runs
PLS1sw=std(PLS1weights');
PLS2sw=std(PLS2weights');

%get bootstrap weights
temp1=PLS1w./PLS1sw';
temp2=PLS2w./PLS2sw';

%order bootstrap weights (Z) and names of regions
[Z1 ind1]=sort(temp1,'descend');
PLS1=PLS1ids(ind1);
geneindex1=geneindex1(ind1);
[Z2 ind2]=sort(temp2,'descend');
PLS2=PLS2ids(ind2);
geneindex2=geneindex2(ind2);








