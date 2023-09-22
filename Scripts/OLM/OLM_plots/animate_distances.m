function animate_distances(FD,dA,dB,interA,interB,disA,disB,fps,Dclose,ta,savebool)

if savebool
    v = VideoWriter([FD,'_SignalDistances_VID.avi']);
    fprintf('>Creating video file %s\n',v.Filename);
    v.FrameRate=fps;
    open(v);
end

FigDis=figure();
FigDis.Name='Distance animation';
FigDis.Position=[514  150  495  582];
FigDis.MenuBar="none";
% resize fig:
vtime=linspace(0,numel(dA)/fps,numel(dA)); % seconds

plot(vtime,dA,'Color','blue','LineWidth',1); hold on
plot(vtime,dB,'Color','green','LineWidth',1)

Ylimits= [min([dA,dB]),max([dA,dB])];
ylabel('[cm]')
xlabel('[s]')
WindowSize=3; % SECONDS

% Init
axis([-WindowSize,0,round(Ylimits(1)-1),round(Ylimits(2)+1)])
grid on

% Exploration Threshold
plot([-WindowSize,vtime(end)],[Dclose Dclose],'Color',[0.49 0.18 0.56],'Marker','.')
plot([-WindowSize,vtime(end)],[0 0],'Color',[0.49 0.18 0.56],'Marker','.')
Ax=gca;
indclos=mean([0,Dclose]);
indvoer=mean([0,Ylimits(1)-1]);
Ax.YTick=unique([Ax.YTick,Dclose,indclos,indvoer]);
Ax.YTickLabel(Ax.YTick==indvoer)={'Overlap'};
Ax.YTickLabel(Ax.YTick==indclos)={'Exploration'};

% Plot in black explorations

plot(vtime(interA),dA(interA),'Color','black','Marker','.','MarkerSize',10,'LineStyle','none'); 
plot(vtime(interB),dB(interB),'Color','black','Marker','.','MarkerSize',10,'LineStyle','none');

% Plot in red overlaps

plot(vtime(disA),dA(disA),'Color','red','Marker','.','MarkerSize',10,'LineStyle','none'); 
plot(vtime(disB),dB(disB),'Color','red','Marker','.','MarkerSize',10,'LineStyle','none')

% Line Time
Ytime=plot([-1/fps,-1/fps],Ylimits,'Color',[0.64 0.08 0.18],'LineStyle',':','LineWidth',2);

for n=1:numel(vtime)+ta
    fprintf('\n Progress: %3.2f %%',100*n/(numel(vtime)+ta))
    %size(frame.cdata)
    if n>ta
        deltatime=1/fps;        
    else
        deltatime=0;
    end
    Ax.XLim(1)=Ax.XLim(1)+deltatime;
    Ax.XLim(2)=Ax.XLim(2)+deltatime;
    Ytime.XData=Ytime.XData+deltatime;
    drawnow;
    if savebool
        frame = getframe(FigDis); % get Figure instead of Axis !!!!!!
        writeVideo(v,frame);
    end
    % pause(0.1);
end

if savebool
    close(v)
    fprintf('%s file created',v.Filename);
end