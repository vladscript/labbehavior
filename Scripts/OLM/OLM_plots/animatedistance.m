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
function animatedistance(FD,pgonA,pgonB,Xnose,Ynose,topLim,bottomLim,rightLim,leftLim,fps,tnose,savebool)
%% setup 
% Nframes=numel(tnose);
Nframes=tnose(end)+1; % starts at zero
if savebool
    nameout=FD;                 % Hz: dafult frames per second (user input)
    prompt={'Name:'};
    name='Video:';
    numlines=1;
    defaultanswer={nameout};
    answer={};
    while isempty(answer)
        answer=inputdlg(prompt,name,numlines,defaultanswer);
    end
    nameout= answer{1};
    v = VideoWriter([nameout,'.avi']);
    fprintf('>Creating: %s file',v.Filename);
    v.FrameRate=fps;
    open(v)
end

%% plot
figure
ax1=subplot(1,1,1);
plot(ax1,pgonA,'FaceColor','blue','EdgeColor','blue')
hold (ax1,'on')
plot(ax1,pgonB,'FaceColor','green','EdgeColor','green')
ax1.YDir="reverse";
line2A=plot(ax1,[0,mean(pgonA.Vertices(:,1))],[0,mean(pgonA.Vertices(:,2))],'Color','blue','LineWidth',2);
line2B=plot(ax1,[0,mean(pgonB.Vertices(:,1))],[0,mean(pgonB.Vertices(:,2))],'Color','green','LineWidth',2);
% line2A.Visible='off';
% line2B.Visible='off';
axis(ax1,[leftLim(1),rightLim(1),topLim(2),bottomLim(2)]);
% tailxy=plot(Xnose(1),Ynose(1));
drawnow;

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
        plot(ax1,x,y,'.','Color',[0.42 0.35 0.2])
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