%% AutDeTAIMst
X=readtable('C:\Users\vladi\OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO\WORK\Data Analysis\Datos\Conducta\LID\LIDDETECT.xlsx')
%% Pre - Processing
% 1. Ignores Scores=0
IndxOK=find(X.SCORE>0);
FeatsOK=2:12;
Xaims=X(IndxOK,FeatsOK);
% Boxplots
columns2boxplot(Xaims.SCORE(Xaims.DOSIS==1),Xaims.SCORE(Xaims.DOSIS==6),Xaims.SCORE(Xaims.DOSIS==12),{'1','6','12'});
%% Minutes & Dates
Mins=zeros(1,numel(X.ID) );
for i=1: numel(X.ID)
    t=X.ID{i};
    GuionBajo=strfind(t,'_');
    Mins(i)=round(str2double( t(GuionBajo(end-1)+1:GuionBajo(end)-1) ));
    Date=t(GuionBajo(2)+1:GuionBajo(3)-1);
    Dates(i)=datetime(Date, 'Format', 'dd-M-yyyy');
end
X.("Minutes")=Mins';
X.("Dates")=Dates';
%% Doses
Dosis=unique(X.DOSIS);
AllFechas=[];
SumAIM=[];
for d=1:numel(Dosis)
    Xdata=X(X.DOSIS==Dosis(d),:); % Single Dose Data
    [fechas,indx]=sort(Xdata.Dates);
    F=unique(fechas);
    for f=1:numel(F)
        x=Xdata(Xdata.Dates==F(f),:);
        xnum=table2array(x(:,2:end-1));
        AllFechas=[AllFechas;F(f)];
        SumAIM=[SumAIM;sum(x.SCORE)];
        yyaxis left
        plot(x.Minutes,x.SCORE); 
        yyaxis right
        plot(x.Minutes,x.PercRight); 
        disp(F(f))
        pause;
    end
end
figure;
bar(AllFechas,SumAIM)
figure; scatter(X.(Feature{i}),X.SCORE,[],X.DOSIS)
%% Correlations
Feature=X.Properties.VariableNames;
figure;
for i=2:numel(Feature)-1
    scatter(X.(Feature{i}),X.SCORE,[],X.DOSIS)
    title(Feature{i})
    disp(Feature{i})
    [R,P]=corr(X.(Feature{i}),X.SCORE)
    pause;
end

% dose=12;
% [R,P]=corr(X.SCORE(X.DOSIS==dose),X.PercRight(X.DOSIS==dose))
% [R,P]=corr(X.SCORE,X.FraccAxis);
%% Sensibility by dose