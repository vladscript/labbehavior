% LickeRatesGroup
clc; clear; % close all;
[f,D]=uigetfile('MultiSelect','on','.csv');
%% Merge Data
Tfeatures=table;
DR=table; % Data Raton ALL
for i=1:numel(f)
    % Load and alligne curves
    t=readtable([D,f{i}]);
    Nsess(i)=size(t,1);
    Tfeatures=[Tfeatures;t];
end
%%  NUmerical treat
MaxSess=max(Nsess);
LRGoStart=NaN*ones(numel(f),max(Nsess));
LRGoAntic=LRGoStart;
LRGopost=LRGoStart;
LRNoGoStart=LRGoStart;
LRNoGoAntic=LRGoStart;
LRNoGopost=LRGoStart;
a=1;
b=0;
for i=1:numel(f)
    b=b+Nsess(i);
    LRGoStart(i,1:Nsess(i))=table2array(Tfeatures(a:b,6));
    LRGoAntic(i,1:Nsess(i))=table2array(Tfeatures(a:b,7));
    LRGopost(i,1:Nsess(i))=table2array(Tfeatures(a:b,8));
    LRNoGoStart(i,1:Nsess(i))=table2array(Tfeatures(a:b,9));
    LRNoGoAntic(i,1:Nsess(i))=table2array(Tfeatures(a:b,10));
    LRNoGopost(i,1:Nsess(i))=table2array(Tfeatures(a:b,11));
    a=b+1;
end

%% Plots
figure
line1=errorbar(mean(LRGoStart,'omitnan'),std(LRGoStart,'omitnan')./sqrt(numel(f))); hold on;
line1.LineWidth=2;
line1.Marker='o';
line1.Color=[0,0.9,0];
line1.LineWidth=3;


line2=errorbar(mean(LRGoAntic,'omitnan'),std(LRGoAntic,'omitnan')./sqrt(numel(f))); hold on;
line2.LineWidth=2;
line2.Marker='o';
line2.Color=[0,0.5,0];
line2.LineWidth=2;


line3=errorbar(mean(LRGopost,'omitnan'),std(LRGopost,'omitnan')./sqrt(numel(f))); hold on;
line3.LineWidth=2;
line3.Marker='o';
line3.Color=[0,0.2,0];
line3.LineWidth=1;


line4=errorbar(mean(LRNoGoStart,'omitnan'),std(LRNoGoStart,'omitnan')./sqrt(numel(f))); hold on;
line4.LineWidth=2;
line4.Marker='o';
line4.Color=[0.9,0,0];
line4.LineWidth=3;


line5=errorbar(mean(LRNoGoAntic,'omitnan'),std(LRNoGoAntic,'omitnan')./sqrt(numel(f))); hold on;
line5.LineWidth=2;
line5.Marker='o';
line5.Color=[0.5,0,0];
line5.LineWidth=2;


line6=errorbar(mean(LRNoGopost,'omitnan'),std(LRNoGopost,'omitnan')./sqrt(numel(f))); hold on;
line6.LineWidth=2;
line6.Marker='o';
line6.Color=[0.2,0,0];
line6.LineWidth=1;

legend('GOstart','AnticipatoryGO','postGO','NOGOstart','AnticipatoryNOGO','postNOGO')


grid on;
ylabel('Lick Rate (Hz)')
xlabel('Sessions')
%% Correlation: lick rate and Hits/P/FA

[R_1,P_1]=corr(Tfeatures.Var3,Tfeatures.Var6_Var1);
% Performance vs Anticpatory Go
[R_2,P_2]=corr(Tfeatures.Var3,Tfeatures.Var6_Var2);
% Performance vs Post Rewward Go
[R_3,P_3]=corr(Tfeatures.Var3,Tfeatures.Var6_Var3);

% FA vs Anticpatory No Go
[R_4,P_4]=corr(Tfeatures.Var5,Tfeatures.Var7_Var2);
% FA vs Post Reward No Go
[R_5,P_5]=corr(Tfeatures.Var5,Tfeatures.Var7_Var3);

figure
subplot(221)
scatter(Tfeatures.Var6_Var2,Tfeatures.Var3,[],Tfeatures.i,'filled')
ylabel('Performance')
xlabel('Anticipatory Lick Rate Go')
cb=colorbar;
cb.Label.String='Sesiones';


subplot(222)
scatter(Tfeatures.Var6_Var3,Tfeatures.Var3,[],Tfeatures.i,'filled')
ylabel('Performance')
xlabel('Lick Rate post Go')
cb=colorbar;
cb.Label.String='Sesiones';

subplot(223)
scatter(Tfeatures.Var7_Var2,Tfeatures.Var5,[],Tfeatures.i,'filled')
ylabel('Performance')
xlabel('Lick Rate Anticipatory No Go')
cb=colorbar;
cb.Label.String='Sesiones';

subplot(224)
scatter(Tfeatures.Var7_Var3,Tfeatures.Var5,[],Tfeatures.i,'filled')
ylabel('Performance')
xlabel('Lick Rate Post No Go')
cb=colorbar;
cb.Label.String='Sesiones';

%% Save
% FNames={'ID','Age_days','OrigWeight_g','Max_Per','Max_Per_Sess','AVG_Pi','AVG_DP'...
%     'Corr_ISH_SP','p_val1','Corr_MSA_Pi','p_val2',...
%     'AC_Hits','AC_Per','AC_Pi','AC_Pf','AC_DP','PVAL_DP'};
% Tfeatures.Properties.VariableNames=FNames;