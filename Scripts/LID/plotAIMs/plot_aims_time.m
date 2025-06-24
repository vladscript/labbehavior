% Plot Histograms for One Sort of AIMs
% Input
%   AIMs.xxx: Matrix 
%   A=AIMs.xxx:
%           AIMs.all
%           AIMs.lo
%           AIMs.li
%           AIMs.Ax
%           AIMs.Ol
% OUTPUT:
%   AIMsess:    values of the specfic AIM
%   DeltaVal:   percentager of deltascore values of the AIMs
% Example:
% [~,AIMs_1]=plot_aims(D1,'global');...; [~,AIMs_4]=plot_aims(D4,'global');
% plot_aims_time(AIMs_1.all,AIMs_2.all,AIMs_3.all,AIMs_4.all,Labels);
function [AIMsess,DeltaVal,ColorsMap]=plot_aims_time(varargin)
% setpathok;
% Setup
AIMsess=[];
DeltaVal=[];
Nc=numel(varargin);
if ismatrix(varargin(end))
    Ncond=Nc-2;
    fprintf('>> Displaying %i conditons: \n',Ncond)
    disp('with the Following Labels:')
    Labels=varargin(end-1);
    disp(cellstr(Labels{1}))
    disp('>>Selected Time Intervals [minutes]:')
    TimeIntervals=round(varargin{end});
    MinutesIntervals=20:20:180;
    for ni=1:numel(TimeIntervals)
        fprintf('%i, ',MinutesIntervals(TimeIntervals(ni)));
    end
    fprintf('\n');
elseif iscell( varargin(end) )
    Ncond=Nc-1;
    fprintf('>> Displaying %i conditons: \n',Ncond)
    disp('with the Following Labels:')
    Labels=varargin(end);
    disp(cellstr(Labels{1}));
    TimeIntervals=1:9;
else
    Ncond=Nc;
    fprintf('>> Displaying %i boxplots',Ncond)
    for n=1:Nc
        Labels{n,1}=num2str(n);
    end
    TimeIntervals=1:9;
end

% Colors: #################################################################
SetColorMap;
CM=cbrewer(KindMap,ColorMapName,Ncolors);
% figure
figureCM=figure;
figureCM.Name=[ColorMapName,' qualitative colormap from  CBREWER'];
figureCM.Position=[612 515 560 118];
imagesc([1:Ncolors]);
figureCM.Colormap=CM;
figureCM.Children.XTick=1:Ncolors;
figureCM.Children.YTick=[];

% Choose Colors
for n=1:Ncond
    disp('>> Choose Color:') ;
    ColorIndx{n}= inputdlg(['Set Color for: ',Labels{1}{n}],...
         'Select color for + Distributions', [1 70]);
    waitfor(ColorIndx{n});
    IndxColor(n)= str2num( cell2mat(  ColorIndx{n} ));
    if ~ismember(IndxColor(n),1:Ncolors)
        IndxColor(n)=n;
        disp('>>ERROR in the index. Assigned Color :')
        disp(n)
    end
end
delete(figureCM);
A=varargin{1};
Ntimes=size(A,2);
DATAAIMS=cell(Ntimes,Ncond);
% Main Loop ****************************************************
FigTOTALAIms=figure;
FigTOTALAIms.Name='TOTAL AIMs';
stepplot=0.10;
labelsplot=[];
Nmice=zeros(1,Ncond);
for c=1:Ncond
    % Collect Data:
    % Tamporal AIMs - - - - - - - - - - - 
    for n=1:Ntimes
        DATAAIMS{n,c}=varargin{c}(:,n);
    end
    % Session Total - - - - - - - - - - - -
    AIMs_matriz=varargin{c};
    Nmice(c)=size(AIMs_matriz,1);
    % Look for Zeros
    if sum(AIMs_matriz(:))==0
        disp('>>Matrix of Zeros: [NO DATA DISPLAY]')
    else
        % *SESSION SUM SCORE*
        hplot{c}=raincloud_plot(sum(AIMs_matriz(:,TimeIntervals),2),'color',CM(IndxColor(c),:),'box_on',1,'alphaval',1,'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', stepplot, 'box_col_match',0);
        stepplot=stepplot+0.20;
        labelsplot=[labelsplot,hplot{c}{1}];
    end
end
% OUPUT *************************************************************
if Ncond>1 && numel(unique(Nmice))==1
    disp('>>Paired Study: same number of mice')
    for c=1:Ncond
        AIMsess=[AIMsess,sum(varargin{c}(:,TimeIntervals),2)];
        if c>1
            DeltaVal(c-1,:)=100*AIMsess(:,c)./AIMsess(:,c-1);
        end
    end
    
else
    disp('>>Only One Condition: session data in AIMs structure, no delta values.')
end

axis tight; grid on;
legend(labelsplot,Labels{1});
% Plot Time AIMs TEMPORAL *************************************************
FigTimeAIms=figure;
FigTimeAIms.Name='TEMPORAL AIMs';
hax=rm_raincloud(DATAAIMS,CM(IndxColor,:));
legend(hax.l(1,:),Labels{1},'Location','northeast');
axis tight; grid on;
ColorsMap=CM(IndxColor,:);