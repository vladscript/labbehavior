%% Script to Watch Data Setup #############################################
close all;
% It requires previously loaded data at: \Data Demo\AIMs.mat
% Labels @AIMs.mat:
% DYSKA, DYSKC, AMAN, CLZ
load([pwd,'\Data Demo\AIMsData.mat']);
Labels={'DYSK_A','+Amantadine','DYSK_C','+Clozapine'};
% Run once and paste AIMs data from sheet
% DYSKA=[];
% AMAN=[];
% DYSKC=[];
% CLZ=[];

%  AIMs Score Options ##############################################
% See Description:
% >>help plot_aims
% /global/global-sum/,
% /basic/amplitude/,
% /ALO-sum/ALO-basic/
TypeDysk='global';
% TimeIntervals: indexes for Minute Intervals:
%   [20,40,60,80,100,120,140,160,180]
%   [ 1, 2, 3, 4,  5,  6,  7,  8,  9]
% Intervals=[2,3,4];
Intervals=1:9;

% plot_sessiocn(S_DYSKA,S_AMAN,S_DYSKC,S_CLZ,Labels);
%% TIME BOXPLOTS AIMs                                 [All Together]
% AIMs Time Boxplots Series in the same Figure
[~,AIMS_DYSKA]=plot_aims(DYSKA,TypeDysk,Intervals);
[~,AIMS_AMAN]=plot_aims(AMAN,TypeDysk,Intervals);
[~,AIMS_DYSKC]=plot_aims(DYSKC,TypeDysk,Intervals);
[~,AIMS_CLZ]=plot_aims(CLZ,TypeDysk,Intervals);
FigAimsCLZ=gcf;
FigAimsCLZ.Name=['All Boxplots '];

%% GET DATA                              [SESSION,TEMPORAL,DELTASESSION]          
% Setup:
%                  *   *   *
% AIMs: {all, lo, li, Ax, Ol}
KindofAIMs='all';

% Get Data: ##############################################################
% Matrices to make statistical tests
DYSKAaims=getfield(AIMS_DYSKA,KindofAIMs);
AMANaims=getfield(AIMS_AMAN,KindofAIMs);
DYSKCaims=getfield(AIMS_DYSKC,KindofAIMs);
CLZaims=getfield(AIMS_CLZ,KindofAIMs);

%% RAINCLOUDs & SESSION SCORES ############################################
% of AIMs Time & Raincloud+Boxplot of Session *****************************
[~,~,ColorsALL]=plot_aims_time(DYSKAaims,AMANaims,...
                    DYSKCaims,CLZaims,...
                    Labels,Intervals);

[ScoresAMAN,DeltaScoreAMAN,ColorsAMAN]=plot_aims_time(DYSKAaims,AMANaims,...
                    Labels(1:2),Intervals);
[ScoresCLZ,DeltaScoreCLZ,ColorsCLZ]=plot_aims_time(DYSKCaims,CLZaims,...
                    Labels(3:4),Intervals);
%% Deltas Figure **********************************************************
% Simple Boxplot:
% columns2boxplot(100-DeltaScoreAMAN,100-DeltaScoreCLZ,{'+AMAN';'+CLZ'})
% DeltaFig=gca;
% DeltaFig.YLim=[0,100];
% DeltaFig.Title.String='% Total AIMs Reduction ';
% DeltaFig.Title.Interpreter='tex';

% Raincloud:
figure;
stepplot=0.10;
stepoffset=0.30;
% FIRST:
ActualColor=double(imadd(uint8(255*ColorsAMAN(1,:)),uint8(255*ColorsAMAN(2,:)),'uint8'))/255;
DeltaPlotA=raincloud_plot(100-DeltaScoreAMAN,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+stepoffset;
% SECOND:
ActualColor=double(imadd(uint8(255*ColorsCLZ(1,:)),uint8(255*ColorsCLZ(2,:)),'uint8'))/255;
DeltaPlotC=raincloud_plot(100-DeltaScoreCLZ,'color',ActualColor,'box_on',1,'alphaval',1,...
    'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', ...
    stepplot, 'box_col_match',0);
stepplot=stepplot+stepoffset;
DeltaFig2=gca;
DeltaFig2.Title.String='% Total AIMs Reduction';
DeltaFig2.Title.Interpreter='tex';
legend([DeltaPlotA{1},DeltaPlotC{1}],'+Amantadine','+Clozapine')
grid on;

%% TIME BOXPLOTS AIMs 
% % AIMs Time Boxplots Series in the seme Figure
% plot_aims(DYSKA,TypeDysk,Intervals,ColorsAMAN);
% plot_aims(AMAN,TypeDysk,Intervals,ColorsAMAN);
% FigAimsAMAN=gcf;
% FigAimsAMAN.Name=['Boxplots ',Labels{1},' & ',Labels{2}];
% plot_aims(DYSKC,TypeDysk,Intervals,ColorsCLZ);
% plot_aims(CLZ,TypeDysk,Intervals,ColorsCLZ);
% FigAimsCLZ=gcf;
% FigAimsCLZ.Name=['Boxplots ',Labels{3},' & ',Labels{4}];

%% PLOTS ****************************************************************
% % STD BAR:
% plot_mean_std(ColorsALL,Labels,KindofAIMs,'STD',DYSKAaims,AMANaims,DYSKCaims,CLZaims,DYSKACaims,AMANCLZaims)
% % SEM bar
plot_mean_std([ColorsAMAN;ColorsCLZ],Labels,KindofAIMs,'SEM',DYSKAaims,...
    AMANaims,DYSKCaims,CLZaims);

%% Parametric Tests #######################################################
alphaval=0.01;
% 2-WAY ANOVA
% Factor Treatment Factor Time 
MCmethod='bonferroni';
% AMANTADINE
Nmice=size(DYSKAaims,1);
[p,tbl,stats] = anova2([DYSKAaims;AMANaims],Nmice);
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

% Friedman Test
% is similar to classical balanced two-way ANOVA, but it 
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
% 
% 
%% TIME EVALUATION COMPARATION ############################################
% AIMs: {all, lo, li, Ax, Ol}
KindofAIMs='all';
DYSKAaims=getfield(AIMS_DYSKA,KindofAIMs);
AMANaims=getfield(AIMS_AMAN,KindofAIMs);
DYSKCaims=getfield(AIMS_DYSKC,KindofAIMs);
CLZaims=getfield(AIMS_CLZ,KindofAIMs);

% Tests for all Time Sets of paired AIMs 
for n=1:9
    %     AMANTADINE        # # #
    A=DYSKAaims(:,n);
    B=AMANaims(:,n);
    %     CLOZAPINE         # # #
    C=DYSKCaims(:,n);
    D=CLZaims(:,n);
    % Wilcoxon signed rank test
    [PVALW_A(n),WILCTEST_A(n)] = signrank(A,B);
    [PVALW_C(n),WILCTEST_C(n)] = signrank(C,D);
%     % t.test
%     [TTEST_A(n),PVAL_A(n)]=ttest(A,B);
%     [TTEST_C(n),PVAL_C(n)]=ttest(C,D);
    fprintf('*')
end
fprintf('\n')
% Estimate false discovery rate (FDR) for multiple hypothesis testing
% by Benjamini and Hochberg, 1995
fdrBH_A = mafdr(PVALW_A,'BHFDR','true');
fdrBH_C = mafdr(PVALW_C,'BHFDR','true');
%% END OF THE WORLD #######################################################