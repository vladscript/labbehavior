% AIMs Plot and Stats
%% DataAIMsExcel
% It reas Excel Files withh: Columns 3 first columnas:
% ID | Evaluation Date | Conditon
% An Excel file per MOUSE!!!!!!!!

[file,Location]=uigetfile('*.xlsx');
AIMsDATA=readtable([Location,file]);
AIMS=AIMsDATA(:,4:end);
% lo li ax
DatTbl=AIMsDATA(1:2:end,2);
Dates=datetime(DatTbl.Var2,'Format','dd/MM/yyyy');
% dates
% Readings Intel 
[R,C]=size(AIMsDATA);
% [R,C]=size(AIMS);
Nevals=round(R/2);
TimesEval=(C-1)/3;
Cond=AIMsDATA.Var3(1:2:end);
% unique(Cond)
if Nevals==numel(Dates)
    fprintf('\n>OK\n')
else
    fprintf('\n>Missing something\n')
end
%% Get Glboal Scores
nrow=2; % amplitude & phasic
ncol=3; % thre evals: lo li ax
IDmouse={}; % initializae empty
Global=[]; % initializae empty
for n=1:Nevals
    for t=1:TimesEval
        aims=table2array(AIMS(n*nrow-nrow+1:n*nrow-nrow+2,t*ncol-ncol+1:t*ncol-ncol+3));
        Global(n,t)=sum(prod(aims));
    end
    Labels=AIMsDATA(n*nrow-nrow+1:n*nrow-nrow+2,1);
    ID{n}=sprintf('%s_%s',Labels.Var1{1},Dates(n));
    IDmouse{n}=sprintf('%s',Labels.Var1{1});
end

[Ncond, Colors]=ColorsAIMs(Cond);

%% Colors
% COnditions=unique(Cond,'stable');
% Ncond=numel(COnditions);
% maxrep=0;
% for i=1:Ncond
%     Nreps(i)=sum(ismember(Cond,COnditions(i)));
%     
%     if Nreps(i)>maxrep
%         maxrep=Nreps(i);
%     end
% end
% % 5 Condtions with gradients
% NameColor={'Blues','Purples','Greens','Oranges','Reds','Greys'};
% 
% if Ncond<numel(NameColor)
%     disp('Color OK')
%     for i=1:Ncond
%         ColorsPal=cbrewer('seq', NameColor{i},2*Nreps(i)+1);
%         ColorsC{i}=ColorsPal(2:2:end,:);
%     end
% else
%     ColorsC{1}=cbrewer('qual', 'Set1', Nevals);
% end


%% Plots
figure
hold on
DateSorting=[];
AllColors=[];
for i=1:Ncond
    IndexAims=find(ismember(Cond,COnditions(i)));
    % Sort By Date
    [DateCond,SirtIndx]=sort(Dates(ismember(Cond,COnditions(i))));
    DateSorting=[DateSorting;find(ismember(Dates,DateCond))];
    if numel(COnditions)>1
        CC=ColorsC{i};
        AllColors=[AllColors;CC];
    else
        CC=ColorsC{1};
    end
    for j=1:numel(IndexAims)
        plot(Global(IndexAims(j),:)','LineWidth',2,'Color',CC(j,:)); 
    end
end
% plot(Global','LineWidth',2)
ylabel('Global AIMs')
xlabel('min')
ax=gca;
ax.XTick=[1:10];
ax.XTickLabel={'20','40','60','80','100','120','140','160','180'};
grid on
l=legend(ID(DateSorting));
l.Interpreter='none';
%%
figure
TotalGlobal=sum(Global');
Cbar=bar(TotalGlobal(DateSorting),'FaceColor','flat');
for i=1:Nevals
    Cbar.CData(i,:)=AllColors(i,:);
end
% disp(sum(Global'));
ylabel('Sum of Global AIMs')
ax=gca;
ax.XTickLabel=ID(DateSorting);
ax.XTickLabelRotation=45;
ax.TickLabelInterpreter='none';
%% Export GlobalScores
fprintf('\n>Exporting table:') 
DotsIndx=strfind(file,'.');
fileout=file(1:DotsIndx(end)-1);
IDs=IDmouse';
writetable([table(Cond,IDs,Dates),array2table(Global,'VariableNames',{'20','40','60','80','100','120','140','160','180'})],...
    [Location,'GlobalScores_',fileout,'.csv']);
fprintf('saved.\n')
% 