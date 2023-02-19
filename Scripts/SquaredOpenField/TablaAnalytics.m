%% Data Analysis of OPen Field
clear
clc;
fprintf('\n>Read data:')
X=readtable('CSV_ALLDATA_CM_OK_CENTROID.csv');
Labels={'pre';'pst';'ctrl';'6-ohda';'day1';'day4'};
[Nmice,Nfeats]=size(X);
fprintf('done.\n')
% [CM,ColorIndx]=Color_Selector(Labels);
% ColorsN=CM(ColorIndx,:);
%% Finding grouprs: pre and pst
fprintf('\n>Groups with : \n')
% Exps2Exlcuede={'CA_CFd4pre_190322D','CA_PEd4pst_190322D',...
%     'CA_PEd4pre_190322D'};
Exps2Exlcuede={'CA_CGd4pst_070722D','CA_P1d4pst_070722D','CA_P1d4pre_070722D'};
VideoNames=X.VideoName;
indx2excllude=find(ismember(VideoNames,Exps2Exlcuede));
NamesParameters=X.Properties.VariableNames(2:end);
VideoNames=VideoNames(setdiff(1:Nmice,indx2excllude));

CTRLindex=[];
LXindex=[];
PREindex=[];
PSTindex=[];
D1index=[];
D4index=[];
for n=1:Nmice-numel(indx2excllude)
    % Condition
    if ~isempty(strfind(VideoNames{n},'CA_C'))
        CTRLindex=[CTRLindex;n]; % ctrl
    else
        LXindex=[LXindex;n];    % 6-ohda
    end
    % Rubidopa
    if ~isempty(strfind(VideoNames{n},'pre_'))
        PREindex=[PREindex;n];  % pre rubidopa
    else
        PSTindex=[PSTindex;n];  % post rubidopa
    end
    % Day
    if ~isempty(strfind(VideoNames{n},'d1'))
        D1index=[D1index;n];   % day one
    else
        D4index=[D4index;n];   % day four
    end
end
Xmat=table2array( X(setdiff(1:Nmice,indx2excllude),2:end));
fprintf('%i %s and %i %s mice\n',numel(CTRLindex),Labels{3},numel(LXindex),Labels{4})
fprintf('%i %s and %i %s mice\n',numel(PREindex),Labels{1},numel(PSTindex),Labels{2})
fprintf('%i %s and %i %s mice\n',numel(D1index),Labels{5},numel(D4index),Labels{6})

%% Making Boxplots (paired data) and Statistics
% titlelab='6-OHDA PRE vs PST'; +

% Indexes *****************************
% Lesion
%     indexesA=intersect(intersect(LXindex,PREindex),D1index); % pre Rubidopa
%     indexesB=intersect(intersect(LXindex,PSTindex),D1index); % post Rubidopa
%     ConditionZ={'PRE';'PST'};
%     pairedtest=true;
% CTRL
%     indexesA=intersect(CTRLindex,D1index);
%     indexesB=intersect(CTRLindex,D4index);
%     ConditionZ={'D1';'D4'};
%     pairedtest=true;


% CTRL vs 6-OHDA
    indexesA=intersect(CTRLindex,D4index); % CTRL
    indexesB=intersect(intersect(LXindex,PSTindex),D4index); % 6-OHDA
    ConditionZ={'CTRL_D4';'6-OHDA-PST_D4'};
    pairedtest=false;

for n=1:size(Xmat,2)
    % Parity Check
    A=Xmat(indexesA,n);
    B=Xmat(indexesB,n);
    Bbuffer=NaN*ones(numel(indexesB),1);
    if pairedtest
        fprintf('\n>Mice found: ')
        for i=1:numel(indexesA)
            guiones=strfind(VideoNames{indexesA(i)},'_');
            VideoID=VideoNames{indexesA(i)};
            MouseID_A=VideoID(guiones(1)+2);
            fprintf('%s',MouseID_A)
            % search in B
            for j=1:numel(indexesB)
                guiones=strfind(VideoNames{indexesB(j)},'_');
                VideoID=VideoNames{indexesB(j)};
                MouseID_B=VideoID(guiones(1)+2);
                if strcmp(MouseID_A,MouseID_B)
                    Bbuffer(i)=B(j);
                    fprintf('*')
                end
            end
            if i<numel(indexesA)
                fprintf(',')
            end
        end
        fprintf('\n>')
        A=A(~isnan(Bbuffer));
        B=Bbuffer(~isnan(Bbuffer));
    end
    
    columns2boxplot(A,B,ConditionZ)
    
    hold on
    for i=1:max([numel(A),numel(B)])
        if i<=numel(A)
            plot(1,A(i),'ro')
        end
        if i<=numel(B)
            plot(2,B(i),'mo')
        end
        if pairedtest
            plot([1,2],[A(i),B(i)],'-.k')
        end
    end

    if pairedtest
        [p,h,stats]=signtest(A,B);
    else
        [p,h,stats]=ranksum(A,B);
    end
    
    fprintf('>Pval=%3.2f in %s\n',p,NamesParameters{n});
    title(sprintf('%s P=%2.2f',NamesParameters{n},p),...
    'Interpreter','none');
    Pval(n)=p;
%     Zsta(n)=stats.zval;
    pause;
end