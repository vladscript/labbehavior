% Input
%   VC1,VC2,VCN: column vectors 
%   Labels=cell(N,1) Structure of NLabels
% Output 
%   Plot of Several Boxplots (different N data)
% Example:
% S1=1:4
% S2=4:9;
% Labels={'low','high'};
% >>plot_session(S1,S2,Labels);
function plot_session(varargin)
%% Setup
setpathok;
Nc=numel(varargin);
if iscell( varargin(end) )
    Nboxes=Nc-1;
    fprintf('>> Displaying %i boxplots\n',Nboxes)
    disp('with the Following Labels:')
    Labels=varargin(end);
    disp(cellstr(Labels{1}))
else
    Nboxes=Nc;
    fprintf('>> Displaying %i boxplots',Nboxes)
    for n=1:Nc
        Labels{n,1}=num2str(n);
    end
end

% USING RainPlot:
SetColorMap;
CM=cbrewer(KindMap,ColorMapName,Nboxes);
figure
stepplot=0.10;
labelsplot=[];
for n=1:Nboxes
    hplot{n}=raincloud_plot(varargin{n},'color',CM(n,:),'box_on',1,'alphaval',1,'box_dodge', 1, 'box_dodge_amount',stepplot , 'dot_dodge_amount', stepplot, 'box_col_match',0);
    stepplot=stepplot+0.20;
    labelsplot=[labelsplot,hplot{n}{1}];
%     ALL_DATA=[ALL_DATA;varargin{n}];
%     Label_Ddata=[Label_Ddata;n*ones(numel(varargin{n}),1)];
end
axis tight; grid on;
legend(labelsplot,Labels{1});

disp('>> Done.')