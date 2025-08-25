%% setup
clc;
clear; 
%% N-Groups
prompt = {'Number of conditions'};
dlgtitle = 'N:';
dims = [1 40];
definput = {'2'};
opts.Interpreter = 'none';
Nstr = inputdlg(prompt,dlgtitle,dims,definput,opts);
N=str2num(Nstr{1});
for n=1:N
    CondNameDefault{n}=sprintf('Condition_%i',n);
end
% Name of Conditions

dlgtitle = 'Input';
dims = [1 35];
CondNames = inputdlg(CondNameDefault,dlgtitle,dims,CondNameDefault);

%% AIM2GRoups: read table of custom mice list
% indx=1;
AIMs=cell(N,1);
Folder=pwd;
for n=1:N
    CondName=CondNames{n};
    AIMSTABLE{n}=table;
    [file,Location,indx]=uigetfile('*.csv',sprintf('Select AIMs Score ConditioN: %s',CondName),Folder);

    while indx>0
        AIMsDATA=readtable([Location,file],'RowNamesColumn',0);
        AIMs=table2array( AIMsDATA(:,4:12));
        IDMouse=AIMsDATA.Var2{2};
        % Unique Conditions:
        COND=unique(AIMsDATA.Var1(2:end));
        [indxC,tf] = listdlg('ListString',COND);
        SelCondition=COND{indxC};
        Dats=find(strcmp(AIMsDATA.Var1,SelCondition));
        Dates=AIMsDATA.Var3(Dats);
        [indxD,tf] = listdlg('ListString',Dates);
        aims=AIMs(Dats(indxD),:);
        rowtab=[table({IDMouse},{SelCondition},Dates(indxD)),array2table(aims)];
        AIMSTABLE{n}=[AIMSTABLE{n};rowtab];
        Folder=Location;
        [file,Location,indx]=uigetfile('*.csv',sprintf('Select AIMs Score ConditioN: %s',CondName),Folder);
        disp(AIMSTABLE{n}.Var1)
    end
%     AIMSTABLE{n}=[AIMSTABLE{n},sum(table2array(AIMSTABLE{n}(:,4:end)),2)];
end
%% PLOTS

plot_mean_std(AIMSTABLE,CondNames,'STD');

%% Check parinngs
SumAIMs=sum(AIMSTABLE(:,4:end))

%% STATS

% 
% 
% %% Parametric Tests #######################################################
% alphaval=0.01;
% % 2-WAY ANOVA
% % Factor Treatment Factor Time 
% MCmethod='bonferroni';
% % AMANTADINE
% Nmice=size(DYSKAaims,1);
% [p,tbl,stats] = anova2([A;B],Nmice);
% c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);
% % CLOZAPINE
% Nmice=size(DYSKCaims,1);
% [p,tbl,stats] = anova2([DYSKCaims;CLZaims],Nmice);
% c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);
% % bonferroni
% c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);
% 
% % SESSION SCORES TESTS  ###################################################
% % 1-way ANOVA
% [~,~,stats] = anova1([ScoresAMAN,ScoresCLZ]);
% c = multcompare(stats,'CType','bonferroni','Alpha',alphaval);
% % 'tukey-kramer' (default) | 'hsd' | 'lsd' | 'bonferroni' | 'dunn-sidak' | 'scheffe'
% 
% % t-TESTs *****************************************************************
% % Paired Conditions
% [h,p]=ttest(ScoresAMAN(:,1),ScoresAMAN(:,2),'Alpha',alphaval)
% [h,p]=ttest(ScoresCLZ(:,1),ScoresCLZ(:,2),'Alpha',alphaval)
% % Unpaired Conditions
% [h,p]=ttest2(ScoresAMAN(:,1),ScoresCLZ(:,1),'Alpha',alphaval)
% [h,p]=ttest2(ScoresAMAN(:,2),ScoresCLZ(:,2),'Alpha',alphaval)
% 
% %% Non-Parametric Tests ####################################################
% 
% % SESSION Scores
% 
% % Friedman Test is similar to classical balanced two-way ANOVA, but it 
% % tests only for column effects after adjusting for possible row effects. 
% % It does not test for row effects or interaction effects. 
% % [p,tbl,stats] = friedman([ScoresAMAN,ScoresCLZ]);
% % c = multcompare(stats,'CType','bonferroni');
% 
% % Kruskal-Wallis test
% % is a nonparametric version of classical one-way ANOVA, and an extension 
% % of the Wilcoxon rank sum test to more than two groups.
% 
% [p,tbl,stats] = kruskalwallis([ScoresAMAN,ScoresCLZ])
% c = multcompare(stats,'CType','bonferroni');
% 
% % Wilcoxon signed rank test PAIRED
% [p,h] = signrank(ScoresAMAN(:,1),ScoresAMAN(:,2))
% [p,h] = signrank(ScoresCLZ(:,1),ScoresCLZ(:,2))
% [p,h,stats] = signrank(ScoresAMAN(:,1),ScoresAMAN(:,2),'method','approximate')
% [p,h,stats] = signrank(ScoresCLZ(:,1),ScoresCLZ(:,2),'method','approximate')
% % Wilcoxon rank sum test UNPAIRED 
% [p,h,Zval]=ranksum(DeltaScoreAMAN,DeltaScoreCLZ,'method','approximate')
% [p,h]=ranksum(ScoresAMAN(:,1),ScoresCLZ(:,1))
% [p,h]=ranksum(ScoresAMAN(:,2),ScoresCLZ(:,2))