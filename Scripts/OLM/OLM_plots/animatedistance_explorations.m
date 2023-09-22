% Input
%   FD        Folder DEstination
%   pgonA     polyshape [pixels]
%   pgonB     polyshape [pixels]
%   Xnose     x-coordinate [pixels]
%   Ynose     x-coordinate [pixels]
%   topLim    top limit of area
%   bottomLim bottom limit of area
%   rightLim  right limit of area
%   leftLim   left limit of area
%   fps       frames per second
%   tnose     frames with DLC detection
%   savebool  boolean value to save file
% Output
% Figure
% File
function animatedistance_explorations(FD,ta,pgonA,pgonB,Xnose,Ynose,fps,tnose,interA,interB,savebool)
%% setup 
% Nframes=numel(tnose);

Nframes=tnose(end)+1; % starts at zero
if savebool
    v = VideoWriter([FD,'_DISTANCES_VID.avi']);
    fprintf('>Creating video file: %s\n',v.Filename);
    v.FrameRate=fps;
    open(v)
end

%% Ask for Video Size

% 'S-OLM.Rub example 
nameout={'316','306'}; % deafult
prompt={'Width','Height'};
name='Frame Size:';
numlines=1;
defaultanswer=nameout;
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
FrameSize = answer{1};
% Ratio:
W=str2double(answer{1});
H=str2double(answer{2});
[~,maxsizeinds]=max([W,H]);
switch maxsizeinds
    case 1
        fprintf('\n>Widht>Height\n')
        ratiosax=[H/W 1 1];
    case 2
        fprintf('\n>Height>Widht\n')
        ratiosax=[H/W 1 1];
    otherwise
        fprintf('\n\nError!!!\n\n')
end

%% fixing polygons
pgonAfix=pgonA;
pgonBfix=pgonB;

pgonAfix.Vertices(1,1)=mean(pgonA.Vertices([1,4],1));
pgonAfix.Vertices(4,1)=mean(pgonA.Vertices([1,4],1));

pgonAfix.Vertices(2,1)=mean(pgonA.Vertices([2,3],1));
pgonAfix.Vertices(3,1)=mean(pgonA.Vertices([2,3],1));

pgonAfix.Vertices(1,2)=mean(pgonA.Vertices([1,2],2));
pgonAfix.Vertices(2,2)=mean(pgonA.Vertices([1,2],2));

pgonAfix.Vertices(3,2)=mean(pgonA.Vertices([3,4],2));
pgonAfix.Vertices(4,2)=mean(pgonA.Vertices([3,4],2));

pgonBfix.Vertices(1,1)=mean(pgonB.Vertices([1,4],1));
pgonBfix.Vertices(4,1)=mean(pgonB.Vertices([1,4],1));

pgonBfix.Vertices(2,1)=mean(pgonB.Vertices([2,3],1));
pgonBfix.Vertices(3,1)=mean(pgonB.Vertices([2,3],1));

pgonBfix.Vertices(1,2)=mean(pgonB.Vertices([1,2],2));
pgonBfix.Vertices(2,2)=mean(pgonB.Vertices([1,2],2));

pgonBfix.Vertices(3,2)=mean(pgonB.Vertices([3,4],2));
pgonBfix.Vertices(4,2)=mean(pgonB.Vertices([3,4],2));

%% plot
figure
ax1=subplot(1,1,1);
plot(ax1,pgonAfix,'FaceColor','None','EdgeColor','blue')
hold (ax1,'on')
plot(ax1,pgonBfix,'FaceColor','None','EdgeColor','green')
ax1.YDir="reverse";
line2A=plot(ax1,[0,mean(pgonA.Vertices(:,1))],[0,mean(pgonA.Vertices(:,2))],'Color','blue','LineWidth',2);
line2B=plot(ax1,[0,mean(pgonB.Vertices(:,1))],[0,mean(pgonB.Vertices(:,2))],'Color','green','LineWidth',2);
% line2A.Visible='off';
% line2B.Visible='off';
% axis(ax1,[leftLim(1),rightLim(1),topLim(2),bottomLim(2)]);
axis(ax1,[1,W,1,H]);
% tailxy=plot(Xnose(1),Ynose(1));
ax1.Color='None'; % Transparecy
pbaspect(ratiosax);
drawnow;

Explorations=unique([interA,interB])+ta;

% ANIMATION
axu=1;
for n=1:Nframes
    if ismember(n,tnose+1)
        line2A.Visible='on';
        line2B.Visible='on';
        x=Xnose(axu); y=Ynose(axu);
        [~,x_polyA,y_polyA] = p_poly_dist(x, y, pgonA.Vertices(:,1), pgonA.Vertices(:,2));
        [~,x_polyB,y_polyB] = p_poly_dist(x, y, pgonB.Vertices(:,1), pgonB.Vertices(:,2));
        line2A.XData=[x,x_polyA];
        line2A.YData=[y,y_polyA];
        line2B.XData=[x,x_polyB];
        line2B.YData=[y,y_polyB];
        uistack(line2B,'top');
        uistack(line2A,'top');
        if ~ismember(n,Explorations)
            ap=plot(ax1,x,y,'.','Color',[0.8 0.8 0.8]);
            uistack(ap,'bottom')
        else
            plot(ax1,x,y,'.','Color',[0 0 0]);
        end
        axu=axu+1;
        drawnow
    else
        line2A.Visible='off';
        line2B.Visible='off';
        drawnow;
    end
    fprintf('\n>Seconds: %3.1f / %3.1f',n/fps,Nframes/fps);
    if savebool
        frame = getframe(ax1);
        writeVideo(v,frame);
    end
end

if savebool
    close(v)
    fprintf('%s file created',v.Filename);
end