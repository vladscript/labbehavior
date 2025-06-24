%% AIM2GRoups: read table of custom mice list
[file,Location]=uigetfile('*.xlsx');
AIMsDATA=readtable([Location,file],'RowNamesColumn',0);
COND=unique(AIMsDATA.Var1(2:end));

[Ncond, Colors]=ColorsAIMs(Cond);

% Sort conditions for boxplots
%% SORT CONDITIONS GUI
CONDfil=COND;
SortCOND=[];
for n=1:numel(COND)
    f = listdlg('PromptString',{'Selecciona orden',...
    '.',''},...
    'SelectionMode','single','ListString',CONDfil);
    SortCOND=[SortCOND;CONDfil(f)];
    CONDfil=setdiff(CONDfil,CONDfil(f));
end
%% MAIN LOOP
% Colors
Intervals=1:9;
Labels={'Male','F trt','F-non trt'}
[Ncond, Colors]=ColorsAIMs(Labels);
plot_mean_std([Colors{1};Colors{2};Colors{3}],Labels,'SEM',A,B,C);


%% Parametric Tests #######################################################
alphaval=0.01;
% 2-WAY ANOVA
% Factor Treatment Factor Time 
MCmethod='bonferroni';
% AMANTADINE
Nmice=size(DYSKAaims,1);
[p,tbl,stats] = anova2([A;B],Nmice);
c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);
% CLOZAPINE
Nmice=size(DYSKCaims,1);
[p,tbl,stats] = anova2([DYSKCaims;CLZaims],Nmice);
c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);
% bonferroni
c = multcompare(stats,'Estimate','row','CType',MCmethod,'Alpha',alphaval);

% SESSION SCORES TESTS  ###################################################
% 1-way ANOVA
[~,~,stats] = anova1([ScoresAMAN,ScoresCLZ]);
c = multcompare(stats,'CType','bonferroni','Alpha',alphaval);
% 'tukey-kramer' (default) | 'hsd' | 'lsd' | 'bonferroni' | 'dunn-sidak' | 'scheffe'

% t-TESTs *****************************************************************
% Paired Conditions
[h,p]=ttest(ScoresAMAN(:,1),ScoresAMAN(:,2),'Alpha',alphaval)
[h,p]=ttest(ScoresCLZ(:,1),ScoresCLZ(:,2),'Alpha',alphaval)
% Unpaired Conditions
[h,p]=ttest2(ScoresAMAN(:,1),ScoresCLZ(:,1),'Alpha',alphaval)
[h,p]=ttest2(ScoresAMAN(:,2),ScoresCLZ(:,2),'Alpha',alphaval)

%% Non-Parametric Tests ####################################################

% SESSION Scores

% Friedman Test is similar to classical balanced two-way ANOVA, but it 
% tests only for column effects after adjusting for possible row effects. 
% It does not test for row effects or interaction effects. 
% [p,tbl,stats] = friedman([ScoresAMAN,ScoresCLZ]);
% c = multcompare(stats,'CType','bonferroni');

% Kruskal-Wallis test
% is a nonparametric version of classical one-way ANOVA, and an extension 
% of the Wilcoxon rank sum test to more than two groups.

[p,tbl,stats] = kruskalwallis([ScoresAMAN,ScoresCLZ])
c = multcompare(stats,'CType','bonferroni');

% Wilcoxon signed rank test PAIRED
[p,h] = signrank(ScoresAMAN(:,1),ScoresAMAN(:,2))
[p,h] = signrank(ScoresCLZ(:,1),ScoresCLZ(:,2))
[p,h,stats] = signrank(ScoresAMAN(:,1),ScoresAMAN(:,2),'method','approximate')
[p,h,stats] = signrank(ScoresCLZ(:,1),ScoresCLZ(:,2),'method','approximate')
% Wilcoxon rank sum test UNPAIRED 
[p,h,Zval]=ranksum(DeltaScoreAMAN,DeltaScoreCLZ,'method','approximate')
[p,h]=ranksum(ScoresAMAN(:,1),ScoresCLZ(:,1))
[p,h]=ranksum(ScoresAMAN(:,2),ScoresCLZ(:,2))