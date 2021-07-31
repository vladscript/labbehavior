% Function to plot trajectory and record it in video
% Input
%   StartTime: Initial SECONDS
%   EndTime: Findal SECONDS
%   XY: pair of coordinates
%   fs: frampes per second
%   TapeIt=false or true
% Ouput
%   Figure Plot
%   If TapeIt
%         Save AVI File in Directori
function plot_Trajecotry(StartTime,EndTime,XY,fs,H,W,TapeIt,FName)
    % StartTime=5;    %min
    % EndTime=5.25;   %min
    windowtime=1; % SECONDS
    ws=round(windowtime*fs); % samples
    fprintf('>>Plotting Open Field Trajectory\n>>Accumulated Distance &\n>>Distance/s\n')
    % A=round(StartTime*60*fs);
    A=round(StartTime*fs); % SAMPLES
    if A==0
        A=1;
    end
    % B=round(EndTime*60*fs);
    B=round(EndTime*fs); % SAMPLES
    if B>size(XY,1)
        B=size(XY,1);
    end
    Nsec=round((B-A)/ws);
    distancia=get_distance(XY(A:B,:));
    acumdist=cumsum(distancia);
    wintimes=round(1:ws:numel(distancia));
    % OPEN FIELD
    OFfig=figure;
    H1=subplot(1,1,1);
    H1.Title.String='Path';
    H1.XLim=[0,H];
    H1.YLim=[0,W];
    H1.YDir='reverse';
    hold(H1,'on');
    grid(H1,'on');
    % FGIURE FOR ACUMULATED & DISTANCE /s
    Distfig=figure;
    G1=subplot(2,1,1);
    hold(G1,'on');
    G2=subplot(2,1,2);
    hold(G2,'on');
    G1.YLim=[0,acumdist(end)];
    G1.XLim=[0,numel(acumdist)];
    G1.XTick=[];
    G1.YLabel.String='Total Distance';
    G2.YLabel.String=['Distance/',num2str(windowtime),'s'];
    G2.XLim=[0.5,Nsec+0.5];
    G2.XLabel.String='Seconds';
    G2.XTick=1:Nsec;
    % Use this loop to get Displacement
    DistTime=zeros(numel(G2.XTickLabel),1);
    for n=1:numel(G2.XTickLabel)
        G2.XTickLabel{n}=num2str(windowtime*n);
        if wintimes(n+1)-1<=numel(distancia)
            DistTime(n)=sum(distancia(wintimes(n):wintimes(n+1)-1));
        else
            DistTime(n)=sum(distancia(wintimes(n):end));
        end
    end
    G2.YLim=[0,max(DistTime)];
    % Recording Settings
    if TapeIt
        Today=datestr(now);
        Today(Today==' ')='_';
        Today(Today==':')='_';
        NameOutOF=[FName,'_OFT_SEC_',num2str(StartTime),'_to_',...
            num2str(EndTime),'_',Today];
        NameOutDD=[FName,'_DISTANCE_SEC_',num2str(StartTime),'_to_',...
            num2str(EndTime),'_',Today];
        v = VideoWriter([NameOutOF,'.avi']);
        vd = VideoWriter([NameOutDD,'.avi']);
        open(v); open(vd);
    end
    % MAIN LOOP
    auxn=1;
    nwin=2;
    for n=A:B
        % Trajectory ***********
        plot(G1,auxn,acumdist(auxn),'.','color','k');
        if nwin<=numel(wintimes)
            if auxn==wintimes(nwin) 
                bar(G2,nwin-1,DistTime(nwin-1),'FaceColor',[0,0.5,0]);
                nwin=nwin+1;
            end
        end
        % Total Distance and Distance/Time
        plot(H1,XY(n,1),XY(n,2),'o','color',[0.85,0.33,0.10],...
            'MarkerFaceColor',[0.85,0.33,0.10]);
        if TapeIt
            drawnow
            Fmovie=getframe(OFfig);
            writeVideo(v,Fmovie);
            Fmovie=getframe(Distfig);
            writeVideo(vd,Fmovie);
        end
        fprintf('Video  %3.2f %%\n',100*((n-A)/(B-A)))
        auxn=auxn+1;
    end
    if TapeIt
        close(v); %close(g);
        close(vd); %    close(gcf);
    end
    fprintf('>>Open Field Trajectory\n>>Distances\n')
end