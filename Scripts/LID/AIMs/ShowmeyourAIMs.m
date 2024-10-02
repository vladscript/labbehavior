% AIMs Plot and Stats
%% DataAIMsExcel
[file,Location]=uigetfile(pwd,'.xlsx');
AIMsDATA=readtable([Location,file]);
AIMS=AIMsDATA(:,2:end);
% lo li ax
%% Readings Intel 
[R,C]=size(AIMsDATA);
Nevals=round(R/2);
TimesEval=(C-1)/3;
%% Get Glboal Scores
nrow=2; % amplitude & phasic
ncol=3; % thre evals: lo li ax
for n=1:Nevals
    for t=1:TimesEval
        aims=table2array(AIMS(n*nrow-nrow+1:n*nrow-nrow+2,t*ncol-ncol+1:t*ncol-ncol+3));
        Global(n,t)=sum(prod(aims));
    end
    Labels=AIMsDATA(n*nrow-nrow+1:n*nrow-nrow+2,1);
    L{n}=sprintf('%s_%s',Labels.Var1{1},Labels.Var1{2});
end
%% Plots
figure
plot(Global')
ylabel('Global AIMs')
ax=gca;
ax.XTick=[1:10];
ax.XTickLabel={'20','40','60','80','100','120','140','160','180'};
grid on
l=legend(L);
l.Interpreter='none';
figure
bar(sum(Global'));
ylabel('Sum of Global AIMs')
ax=gca;
ax.XTickLabel=L;
ax.XTickLabelRotation=90;
ax.TickLabelInterpreter='none';