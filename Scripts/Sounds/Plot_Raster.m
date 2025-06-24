%% Function to plot raster
% input
%   R:   Matrix  Rows x Columns
%   varargin default:
%           fs=1            Bin Window
%           stepy=2;        Step between rows Yticks
%           indexes=1:C;    Sort
% Output
% figure of the raster in MINUTES
% Always creates a new figure
function Plot_Raster(R,varargin)
%% Setup
% Check Raster Range of Values
vals=sort(unique(R(:)));
if numel(vals)==2 && (and(vals(1)==0,vals(2)==1))
    fprintf('\n>Binary mode\n')
    CM=gray(2);
    bincol=true;
else
    fprintf('\n>Colored mode\n');
    bincol=false;
    if sum(vals-round(vals))==0 % INTEGERS
        notmultiply=true;
        strcblabel='N';
        bines=vals;
        CM=gray(numel(bines)*2);
        CM=CM(end:-2:1,:);
    else
        notmultiply=false;
        [Nc,bines]=histcounts(R(R(:)>0));
        CM=gray(numel(Nc)*2+1);
        CM=CM(end-1:-2:1,:);
        strcblabel='[ms]';
    end
end
% Colormap

TransientHight=0.75;
%ColColor=[1,0.6,0.78]; % PINK
N=numel(varargin);
[C,~]=size(R);
indexes=1:C;

switch N
    case 0
        bins=1; % Discrete Time (frames)
        stepy=1;
        xstring='bins';
    case 1
        bins=varargin{1};
        stepy=1;        
        xstring='t [s]';
    case 2
        bins=varargin{1};
        xstring='t [s]';
        stepy=1;
        CM=varargin{2};
        strcblabel='Type';
        bines=bines(bines>0);
        ColorTypeVocals; % Get Types List
    otherwise
        fprintf('\n Unrecognized #input parameters\n')
end
% ts=1/bins;
%% Create Figure   ********************************************************
figure
ax1=subplot(1,1,1);
hold on;
%% MAIN LOOP ##########################################################
for i=1:C
    fprintf('%i: ',i)
    ypositon=[i-TransientHight/2,TransientHight];
    activeframes=find(R(i,:));
    activeframes=[activeframes,0];
    % never and active frame is going to be Zero
    if ~isempty(activeframes(activeframes>0))
        nf=1;
        xposition(1)=activeframes(1);
        % xposition(2)=1;
        xposition(2)=bins;
        val=R(i,activeframes(1));
        
        while nf<numel(activeframes)
            nx=nf; 
%             while activeframes(nx+1)==activeframes(nx)+1 % consecutive
%                 xposition(2)=xposition(2)+1;
%                 if nx+1==numel(activeframes)
%                     % activeframes=[activeframes,0];
%                     % never and active frame is going to be Zero
%                     % Stop sloop;
%                 else
%                     nx=nx+1;
%                     % SUM OF N AND LENGHTS
%                 end
%             end
            % Create Rectangle *************************
            xposs=xposition;
            if bincol
                colorspike=CM(1,:);
            else
                ncolors=find(val>=bines);
                if ~isempty(ncolors)
                    ncolor=ncolors(end);
                else
                    ncolor=numel(bines)-1;
                end
                colorspike=CM(ncolor,:);
            end
            rectangle('Position',[bins*xposs(1)-bins,ypositon(1),...
                    xposs(2),ypositon(2)],'Curvature',[0,0],...
                    'EdgeColor',colorspike,...
                    'FaceColor',colorspike);
            fprintf('|')
            % Restart xposition values
            % xposition(1)=activeframes(nx+1)-0.5;
            xposition(1)=activeframes(nx+1);
            xposition(2)=bins;
            if nx<numel(activeframes)-1
                val=R(i,activeframes(nx+1));
            end
            nf=nx+1;    
        end
        fprintf('\n')
    else
        fprintf('\n')
    end
end

if C>0
    axis([0,size(R,2)+1,1-TransientHight/2,C+TransientHight/2])
end
    
ylabel('Files/Segments')
xlabel(xstring)
set(ax1,'Box','off')
yticks=indexes';
set(ax1,'YTick',1:stepy:C)
set(ax1,'YTickLabel',yticks(1:stepy:C))
set(ax1,'TickLength',[0,0])
ax1.YDir='reverse';

if N>0
%     for j=1:numel(ax1.XTick)
%         ax1.XTickLabel{j}=num2str((ax1.XTick(j)-1)*bins);
%     end
end

axis([0,size(R,2)*bins,TransientHight/2,size(R,1)+3*TransientHight/4])

% ax1.XTickMode='manual';

if ~bincol                
    colormap(CM);
    colorbar;
    cb=colorbar;
    cbTicks=linspace(cb.Limits(1),cb.Limits(end),numel(bines));
    cb.Ticks=cbTicks;
    for i=1:numel(bines)
        if ~notmultiply
            cb.TickLabels{i}=num2str(bines(i)*1000);
        else
            cb.TickLabels{i}=num2str(bines(i));
        end
    end
    % fprintf('-'); 
    titlecb=get(cb,'Title');
    set(titlecb,'String',strcblabel)
end

end