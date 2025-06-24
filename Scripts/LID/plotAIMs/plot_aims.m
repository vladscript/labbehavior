% Function to plot Boxplots of AIMs
% Input 
%   A:  Matrix of Time Course Sccores: Rows:2*Nsmice x Columns:36 
%   Nmice x 9 matrices like:
%                  Lo      Li      Ax      Ol
%       bas       bLo     bLi     bAx     bOl
%       amp       aLo     aLi     aAx     aOl
% 
%   Type of Scores:
% 
%   'global': sum of prodcucts: 
%           bLo*aLo + bLi*aLi + bAx*aAx + bOl*aOl
%   'global-sum'
%           bLo+aLo + bLi+aLi + bAx+aAx + bOl+aOl
%   'basic'
%           bLo + bLi + bAx + bOl
%   'amplitude'             *aLo=0*
%           aLo + aLi + aAx +  aOl
%   'ALO-sum': Axial Limb Orolingual only
%           bLi+aLi + bAx+aAx + bOl+aOl
%   'ALO-basic'
%           bLi + bAx + bOl
% TimeIntervals: indexes for Minute Intervals:
% [20,40,60,80,100,120,140,160,180]
% [ 1, 2, 3, 4,  5,  6,  7,  8,  9]
% Ouput
%   Plots: 
%   Session Score
%   > Global Session Score
%   Time course 
%   > global/basic/amplitude AIM scores
%   AIM subtype:
%   > Time course of global/basic/amplitude Lo
%   > Time course of global/basic/amplitude Li
%   > Time course of global/basic/amplitude Ax
%   > Time course of global/basic/amplitude Ol
function [SessionScore,AIMs]=plot_aims(A,typeplot,varargin)
%% Setup
% Check IF specific Intervasl for Session Score
if ~isempty(varargin)
    if numel(varargin)<2
        disp('>>Selected Time Intervals [minutes]:')
        TimeIntervals=round(varargin{end});
        MinutesIntervals=20:20:180;
        for ni=1:numel(TimeIntervals)
            fprintf('%i, ',MinutesIntervals(TimeIntervals(ni)));
        end
        fprintf('\n');
        CM=lines(10);
        ColorIndex=1;
    else
        disp('>>Selected Time Intervals [minutes]:')
        TimeIntervals=round(varargin{1});
        MinutesIntervals=20:20:180;
        for ni=1:numel(TimeIntervals)
            fprintf('%i, ',MinutesIntervals(TimeIntervals(ni)));
        end
        fprintf('\n');
        CM=varargin{2};
        ColorIndex=1;
    end
else
    disp('>>Complete TIme Intervals Score Session');
    TimeIntervals=1:9;
end
% ALL SCORES calculated with 'AIMs_Score_single_mouse'
AIMS_Structure=get_aims_data(A);
Nmice=numel(AIMS_Structure);
TimeAIMs=20:20:180;
TimeLabels=cell(9,1);
for n=1:9
    TimeLabels{n}=num2str(TimeAIMs(n));
end
% Global Ouput
SessionScore=zeros(Nmice,1);
All_AIMs=zeros(Nmice,numel(TimeAIMs));
Lo_AIMs=zeros(Nmice,numel(TimeAIMs));
Li_AIMs=zeros(Nmice,numel(TimeAIMs));
Ax_AIMs=zeros(Nmice,numel(TimeAIMs));
Ol_AIMs=zeros(Nmice,numel(TimeAIMs));

%% Retieve Data: Main Loop
for n=1:Nmice
    fprintf('> Retrieveing %s AIMs of Rodent  %i  \n',typeplot,n);
    % Retrieve and concatenate intel:
    switch typeplot
        case 'global'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.globalscores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.globalscores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.globalscores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.globalscores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.globalscores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionscores;
        case 'global-sum'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.globalsumscores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.globalsumscores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.globalsumscores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.globalsumscores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.globalsumscores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionsumscores;
        case 'basic'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.basic_scores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.basicscores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.basicscores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.basicscores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.basicscores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionbasscores;
        case 'amplitude'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.amplitudescores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.amplitudescores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.amplitudescores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.amplitudescores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.amplitudescores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionampscores;
        case 'ALO-sum'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.alosumscores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.alosumscores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.alosumscores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.alosumscores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.alosumscores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionalosumscores;
        case 'ALO-basic'
            % Score
            All_AIMs(n,:)=[AIMS_Structure{n}.alobasicscores];
            % Individual
            Lo_AIMs(n,:)=[AIMS_Structure{n}.alobasicscores_Lo];
            Li_AIMs(n,:)=[AIMS_Structure{n}.alobasicscores_Li];
            Ax_AIMs(n,:)=[AIMS_Structure{n}.alobasicscores_Ax];
            Ol_AIMs(n,:)=[AIMS_Structure{n}.alobasicscores_Ol];
            % Session Score
            SessionScore(n)=AIMS_Structure{n}.sessionalosumscores;
        otherwise
            disp('>> Nothing done.')
    end
    
end
% Output:
AIMs.all=All_AIMs;
AIMs.lo=Lo_AIMs;
AIMs.li=Li_AIMs;
AIMs.Ax=Ax_AIMs;
AIMs.Ol=Ol_AIMs;
% Session Time Intervals Selection
SessionScore=sum(All_AIMs(:,TimeIntervals),2);
%% Plots
% Ask if there is Any Plot Related to AIMs
ActualFigures = findobj('Type', 'figure');
CreateFig=1;
n=1;
while and(CreateFig,n<=numel(ActualFigures))
    % Search if Any is AIMs
    if ~isempty(ActualFigures(n).Name)
        if strcmp(ActualFigures(n).Name(1:4),'AIMs')
%         if  and(strcmp(ActualFigures(n).Name(1:4),'AIMs'),....
%                 strcmp(ActualFigures(n).Name(21:24),typeplot(1:4)))
            % AIMs plotted already
            disp('>> Detected Plot already >>')
            hOl=ActualFigures(n).Children(1);
            hAx=ActualFigures(n).Children(2);
            hLi=ActualFigures(n).Children(3);
            hscore=ActualFigures(n).Children(4);
            ColorIndex=numel(ActualFigures(n).Children(1).Children)+1;
            disp('>> Activate Hold On  in Plot ...')
            CreateFig=0;
        else
            disp('    No AIMs Plot Related Found')
        end
    else
        % New AIMs Plot
        disp('     No AIMs Plot Related Found')
    end
    n=n+1;
end
ActualColor=CM(ColorIndex,:);
if CreateFig==1
    AIMs_Fig=figure('numbertitle','off',...
    'name',['AIMs Time Course of ',typeplot,' scale'],...
    'Position',[39 246 924 420]);
    hscore=subplot(1,2,1);
    hLi=subplot(3,2,2);
    hAx=subplot(3,2,4);
    hOl=subplot(3,2,6);
    
else
    disp('>> Holding Plot: ')
    hold(hscore,'on')
    hold(hLi,'on')
    hold(hAx,'on')
    hold(hOl,'on')
end
%% PLOT (finally)
boxplot(hscore,All_AIMs,'Labels',TimeLabels,'PlotStyle','compact',...
    'Color',ActualColor,'LabelOrientation','horizontal');
boxplot(hLi,Li_AIMs,'Labels',TimeLabels,'PlotStyle','compact',...
    'Color',ActualColor,'LabelOrientation','horizontal');
boxplot(hAx,Ax_AIMs,'Labels',TimeLabels,'PlotStyle','compact',...
    'Color',ActualColor,'LabelOrientation','horizontal');
boxplot(hOl,Ol_AIMs,'Labels',TimeLabels,'PlotStyle','compact',...
    'Color',ActualColor,'LabelOrientation','horizontal');
disp('>> Box Plots : done.')
% Labels:
hscore.YLabel.String='Scores';
hLi.YLabel.String='Li';
hAx.YLabel.String='Ax';
hOl.YLabel.String='Ol';