%% Setup
clear; clc
fs=30; % aprox same sampling frequency of ALL videos 
%% Load CSV
fprintf('\nWhy did the mouse cross the bridge?'); pause(2); clc;
[FileName,FileUbication]=uigetfile('*.csv','Select DLC Pose CSV ');
fprintf('Reading poses:')
GaitTable = ReadDLCtable([FileUbication,FileName]);
LikelihoodThreshold=0.75;
ContinueStep=true;
fprintf('done.\n')
% LikelihoodThreshold=0.95; Try this w/IMG_0063 to stimate 3 corners

%% Read TailBase - Nose Axis
% Samples with acceptable likelihood of detectino
OkDet=intersect(find(GaitTable.TailBaseL>=LikelihoodThreshold),...
        find(GaitTable.NoseL>=LikelihoodThreshold));
TailXY=[GaitTable.TailBaseX(OkDet),GaitTable.TailBaseY(OkDet)];
NoseXY=[GaitTable.NoseX(OkDet),GaitTable.NoseY(OkDet)];
NoseTailLenght=sqrt((TailXY(:,1)-NoseXY(:,1)).^2+(TailXY(:,2)-NoseXY(:,2)).^2);    
TimeAxis=GaitTable.TimeIndex(OkDet)+1; % From DLC it starts @ 0
NTLs=smooth(NoseTailLenght,20);
figure
ax1=subplot(1,3,[1,2]);
plot(TimeAxis,NoseTailLenght,TimeAxis,NTLs);
ylabel('Pixels')
xlabel('Video Frames')
title('Nose-Tail Axis Length')
ax2=subplot(1,3 ,3);
[pxtn,xbintn]=ksdensity(NTLs,linspace(min(NTLs),max(NTLs),100));
plot(pxtn,xbintn,'LineWidth',2,'Color',[0.5,0.25,0.75])
xlabel('probability')
title('pdf')
linkaxes([ax1,ax2],'y');
ax1.XLim=[0,max(TimeAxis)];
grid(ax1,'on')
grid(ax2,'on')
% Nose-Tail Axis
[probsModes,peakPos,WidthPeak]=findpeaks(pxtn,xbintn,'SortStr','descend');
if numel(probsModes)>0
%     if numel(probsModes)==1
    ModeIndx=1;
%     else 
%         [~,ModeIndx]=max(peakPos(1:2));
%     end
    hold(ax2,'on')
    plot(ax2,probsModes(ModeIndx),peakPos(ModeIndx),'rd','MarkerSize',12)
    hold(ax1,'on')
    plot(ax1,[TimeAxis(1),TimeAxis(end)],...
        [peakPos(ModeIndx)+WidthPeak(ModeIndx),...
        peakPos(ModeIndx)+WidthPeak(ModeIndx)],'--k')
    plot(ax1,[TimeAxis(1),TimeAxis(end)],...
        [peakPos(ModeIndx)-WidthPeak(ModeIndx),...
        peakPos(ModeIndx)-WidthPeak(ModeIndx)],'--k')
    % Time Intervals where Axis-Tail Length was Maximum
    MinLengt=peakPos(ModeIndx)-WidthPeak(ModeIndx);
    IndexesOK=find(NTLs>MinLengt);  % Indexes above threshold
    % Discontinuos samples

    DataOK=true;
else
    disp('>>ATTENTION: Nose-Tail-Axis missdetected!!')
    DataOK=false;
end
%% Detecting Crosses
CrossingTimes={};
TimesOK=TimeAxis(IndexesOK);
auxC=1;
CrossingTimes{auxC}=[];
for n=1:numel(TimesOK)-1
    % If cut sampline is less than 1 second:
    if TimesOK(n+1)-TimesOK(n)<fs
        CrossingTimes{auxC}=[CrossingTimes{auxC},TimesOK(n)];
    else
        CrossingTimes{auxC}=[CrossingTimes{auxC},TimesOK(n)];
        auxC=auxC+1;
        CrossingTimes{auxC}=[];
    end
end
for n=1:numel(CrossingTimes)
    [~,Bindx,~]=intersect(TimeAxis,CrossingTimes{n});
    Nframes(n)=numel(CrossingTimes{n});
    plot(ax1,CrossingTimes{n},NTLs(Bindx),'*k')
end
%% Analyze Longest Crossing
% Not necessary true, maight expend time hesitating
[~,Crossin]=max(Nframes);
InterValInit=min(CrossingTimes{Crossin});
InterValEnd=max(CrossingTimes{Crossin});
%% Check Limbs
Xmin=min([GaitTable.TailTipX(GaitTable.TailTipL>LikelihoodThreshold);...
    GaitTable.NoseX(GaitTable.NoseL>LikelihoodThreshold)]);
Xmax=max([GaitTable.TailTipX(GaitTable.TailTipL>LikelihoodThreshold);...
    GaitTable.NoseX(GaitTable.NoseL>LikelihoodThreshold)]);
Ymax=max([GaitTable.TailTipY(GaitTable.TailTipL>LikelihoodThreshold);...
    GaitTable.NoseY(GaitTable.NoseL>LikelihoodThreshold)]);
Ymin=min([GaitTable.TailTipY(GaitTable.TailTipL>LikelihoodThreshold);...
    GaitTable.NoseY(GaitTable.NoseL>LikelihoodThreshold)]);
for n=1:numel(CrossingTimes)
    figure('Name',['Mouse Crossing n=',num2str(n)],'NumberTitle','off')
    Ax{n}=subplot(1,1,1);
    Ax{n}.XLim=[Xmin,Xmax];
    Ax{n}.YLim=[Ymin,Ymax];
    % Ax.XLimMode:
    hold(Ax{n}, 'on')
    Ax{n}.YDir='reverse';
    % Upper Limb Left
    ULPplot=plot(Ax{n},0.5,0.5,'xk','MarkerSize',5,'LineWidth',2); % Palm
    ULFplot=plot(Ax{n},0.4,0.4,'^k','MarkerSize',5,'LineWidth',2); % Finger
    ULHplot=plot(Ax{n},0.3,0.3,'ok','MarkerSize',5,'LineWidth',2); % Heel
    % Upper Limb Right
    URPplot=plot(Ax{n},0.8,0.8,'xk','MarkerSize',5,'LineWidth',2); % Palm
    URFplot=plot(Ax{n},0.7,0.7,'^k','MarkerSize',5,'LineWidth',2); % Finger
    URHplot=plot(Ax{n},0.6,0.6,'ok','MarkerSize',5,'LineWidth',2); % Heel
    % Lower Limb Left
    LLPplot=plot(Ax{n},0.3,0.5,'xr','MarkerSize',5,'LineWidth',2); % Palm
    LLFplot=plot(Ax{n},0.2,0.4,'^r','MarkerSize',5,'LineWidth',2); % Finger
    LLHplot=plot(Ax{n},0.1,0.3,'or','MarkerSize',5,'LineWidth',2); % Heel
    % Lower Limb Right
    LRPplot=plot(Ax{n},0.6,0.8,'xr','MarkerSize',5,'LineWidth',2); % Palm
    LRFplot=plot(Ax{n},0.5,0.7,'^r','MarkerSize',5,'LineWidth',2); % Finger
    LRHplot=plot(Ax{n},0.4,0.6,'or','MarkerSize',5,'LineWidth',2); % Heel
    set([ULPplot,ULFplot,ULHplot,URPplot,URFplot,URHplot,...
        LLPplot,LLFplot,LLHplot,LRPplot,LRFplot,LRHplot],'Visible','off');
    
    TimesNH=CrossingTimes{n};
    fprintf('>Cross %i Frame:',n);
    for i=1:numel(TimesNH) 
        fprintf('%i,',TimesNH(i))
        % Upper Limb Left ###############################################
        XYul=[];
        % Palm
        if GaitTable.LimbLeftUpL(TimesNH(i))>LikelihoodThreshold
            ULPplot.XData = GaitTable.LimbLeftUpX(TimesNH(i));
            ULPplot.YData = GaitTable.LimbLeftUpY(TimesNH(i));
            ULPplot.Visible='on';
            XYul=[XYul; ULPplot.XData,ULPplot.YData];
        else
            ULPplot.Visible='off';
        end
        % Finger
        if GaitTable.FingersLeftUpL(TimesNH(i))>LikelihoodThreshold
            ULFplot.XData = GaitTable.FingersLeftUpX(TimesNH(i));
            ULFplot.YData = GaitTable.FingersLeftUpY(TimesNH(i));
            ULFplot.Visible='on';
            XYul=[XYul; ULFplot.XData,ULFplot.YData];
        else
            ULFplot.Visible='off';
        end
        % Heel
        if GaitTable.HeelLeftUpL(TimesNH(i))>LikelihoodThreshold
            ULHplot.XData = GaitTable.HeelLeftUpX(TimesNH(i));
            ULHplot.YData = GaitTable.HeelLeftUpY(TimesNH(i));
            ULHplot.Visible='on';
            XYul=[XYul; ULHplot.XData,ULHplot.YData];
        else
            ULHplot.Visible='off';
        end
%         if ~isempty(XYul)
%             XYul=mean(XYul,1);
%         else
%             fprintf('No UpLeftLimb')
%         end
        % Upper Limb Right ###############################################
        XYur=[];
        % Palm
        if GaitTable.LimbRightUpL(TimesNH(i))>LikelihoodThreshold
            URPplot.XData = GaitTable.LimbRightUpX(TimesNH(i));
            URPplot.YData = GaitTable.LimbRightUpY(TimesNH(i));
            URPplot.Visible='on';
            XYur=[XYur;URPplot.XData,URPplot.YData];
        else
            URPplot.Visible='off';
        end
        % Finger
        if GaitTable.FingersRightUpL(TimesNH(i))>LikelihoodThreshold
            URFplot.XData = GaitTable.FingersRightUpX(TimesNH(i));
            URFplot.YData = GaitTable.FingersRightUpY(TimesNH(i));
            URFplot.Visible='on';
            XYur=[XYur;URFplot.XData,URFplot.YData];
        else
            URFplot.Visible='off';
        end
        % Heel
        if GaitTable.HeelLeftUpL(TimesNH(i))>LikelihoodThreshold
            URHplot.XData = GaitTable.HeelLeftUpX(TimesNH(i));
            URHplot.YData = GaitTable.HeelLeftUpY(TimesNH(i));
            URHplot.Visible='on';
            XYur=[XYur;URHplot.XData,URHplot.YData];
        else
            URHplot.Visible='off';
        end
%         if ~isempty(XYur)
%             XYur=mean(XYur,1);
%         else
%             fprintf('No UpRightLimb')
%         end
        % Lower Limb Left  ###############################################
        XYll=[];
        % Left Palm
        if GaitTable.LimbLeftLoL(TimesNH(i))>LikelihoodThreshold
            LLPplot.XData = GaitTable.LimbLeftLoX(TimesNH(i));
            LLPplot.YData = GaitTable.LimbLeftLoY(TimesNH(i));
            LLPplot.Visible='on';
            XYll=[XYll;LLPplot.XData,LLPplot.YData];
        else
            LLPplot.Visible='off';
        end
        % Left Finger
        if GaitTable.FingersLeftLoL(TimesNH(i))>LikelihoodThreshold
            LLFplot.XData = GaitTable.FingersLeftLoX(TimesNH(i));
            LLFplot.YData = GaitTable.FingersLeftLoY(TimesNH(i));
            LLFplot.Visible='on';
            XYll=[XYll;LLFplot.XData,LLFplot.YData];
        else
            LLFplot.Visible='off';
        end
        % Left Heel
        if GaitTable.HeelLeftLoL(TimesNH(i))>LikelihoodThreshold
            LLHplot.XData = GaitTable.HeelLeftLoX(TimesNH(i));
            LLHplot.YData = GaitTable.HeelLeftLoY(TimesNH(i));
            LLHplot.Visible='on';
            XYll=[XYll;LLHplot.XData,LLHplot.YData];
        else
            LLHplot.Visible='off';
        end
%         if ~isempty(XYll)
%             XYll=mean(XYll,1);
%         else
%             fprintf('No LoLeftLimb')
%         end
        % Lower Limb Right  ###############################################
        XYlr=[];
        % Palm
        if GaitTable.LimbRightLoL(TimesNH(i))>LikelihoodThreshold
            LRPplot.XData = GaitTable.LimbRightLoX(TimesNH(i));
            LRPplot.YData = GaitTable.LimbRightLoY(TimesNH(i));
            LRPplot.Visible='on';
            XYlr=[XYlr;LRPplot.XData,LRPplot.YData];
        else
            LRPplot.Visible='off';
        end
        %  Finger
        if GaitTable.FingersLeftLoL(TimesNH(i))>LikelihoodThreshold
            LRFplot.XData = GaitTable.FingersLeftLoX(TimesNH(i));
            LRFplot.YData = GaitTable.FingersLeftLoY(TimesNH(i));
            LRFplot.Visible='on';
            XYlr=[XYlr;LRFplot.XData,LRFplot.YData];
        else
            LRFplot.Visible='off';
        end
        %  Heel
        if GaitTable.HeelLeftLoL(TimesNH(i))>LikelihoodThreshold
            LRHplot.XData = GaitTable.HeelLeftLoX(TimesNH(i));
            LRHplot.YData = GaitTable.HeelLeftLoY(TimesNH(i));
            LRHplot.Visible='on';
            XYlr=[XYlr;LRHplot.XData,LRHplot.YData];
        else
            LRHplot.Visible='off';
        end
%         if ~isempty(XYlr)
%             XYlr=mean(XYlr,1);
%         else
%             fprintf('No LoleftLimb')
%         end
        % Stride Lines $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if size(XYll,1)==3 && size(XYur,1)==3
            disp('YES')
            plot(Ax{n},[mean(XYll(:,1)),mean(XYur(:,1))],[mean(XYll(:,2)),mean(XYur(:,2))],'--r')
        end
        if size(XYlr,1)==3 && size(XYul,1)==3
            disp('YES')
            plot(Ax{n},[mean(XYlr(:,1)),mean(XYul(:,1))],[mean(XYlr(:,2)),mean(XYul(:,2))],'--r')
        end
%         P(1)=~isempty(XYll);
%         P(2)=~isempty(XYlr);
%         P(3)=~isempty(XYul);
%         P(4)=~isempty(XYur);
%         AllP={XYll,XYlr,XYul,XYur};
%         Equis=[];
%         Yes=[];
%         for p=1:4
%             if P(p)
%                Equis=[Equis,AllP{p}(1)];
%                Yes=[Yes,AllP{p}(2)];
%             end
%         end
%         if numel(Yes)>1
%             for j=1:numel(Yes)-1
%                 for k=j+1:numel(Yes)
%                     plot(Ax{n},[Equis(j),Equis(k)],[Yes(j),Yes(k)],'--m')
%                     if numel(Yes)==4
%                         plot(Ax{n},[Equis(j),Equis(k)],[Yes(j),Yes(k)],...
%                             '-k','LineWidth',2)
%                     end
%                 end
%             end
%         end
        drawnow;
        pause(0.1);
    end
    fprintf('\n')
end


%% Check Corners #########################################################

% Only if ALL of them were detected

% Estimation as perfect rectangle NO WAY, more like a TRAPEZE

% Load Snapshot of Experiment
%  Draw two lines
%  Get Corners *********************

%% Scale to Centimeters
%% Save & Export Results
% Necessary for actual dimension

% Accept good LIkelihoods
% WALL: A-B
% isOKcornerA=mean(GaitTable.CornerAL)>LikelihoodThreshold;
% isOKcornerB=mean(GaitTable.CornerBL)>LikelihoodThreshold;
% % WALL: C-D
% isOKcornerC=mean(GaitTable.CornerCL)>LikelihoodThreshold;
% isOKcornerD=mean(GaitTable.CornerDL)>LikelihoodThreshold;
% MaximumX=max(GaitTable.NoseX(GaitTable.NoseX>=LikelihoodThreshold));
% 
% % Retrieve Coordinates
% % A corner
% CornerA = [GaitTable.CornerAX(GaitTable.CornerAL>=LikelihoodThreshold),...
%     GaitTable.CornerAY(GaitTable.CornerAL>=LikelihoodThreshold)];
% % B corner
% CornerB = [GaitTable.CornerBX(GaitTable.CornerBL>=LikelihoodThreshold),...
%     GaitTable.CornerBY(GaitTable.CornerBL>=LikelihoodThreshold)];
% % C corner
% CornerC = [GaitTable.CornerCX(GaitTable.CornerCL>=LikelihoodThreshold),...
%     GaitTable.CornerCY(GaitTable.CornerCL>=LikelihoodThreshold)];
% % D corner
% CornerD = [GaitTable.CornerDX(GaitTable.CornerDL>=LikelihoodThreshold),...
%     GaitTable.CornerDY(GaitTable.CornerDL>=LikelihoodThreshold)];
% % Axy=[0,0]; Bxy=[0,0]; Cxy=[0,0]; Dxy=[0,0];
% if sum([isOKcornerA,isOKcornerB,isOKcornerC,isOKcornerD])<3
%     fprintf('>>Check Corners: missing at least 2 corner positions: ');
%     if ~isempty(CornerA)
%         XYcornerA=[mean(CornerA(:,1)),mean(CornerA(:,2))];
%         isOKcornerA=true;
%     else
%         fprintf('A,');
%     end
%     if ~isempty(CornerB)
%         XYcornerB=[mean(CornerB(:,1)),mean(CornerB(:,2))];
%         isOKcornerB=true;
%     else
%         fprintf('B,');
%     end
%     if ~isempty(CornerC)
%         XYcornerC=[mean(CornerC(:,1)),mean(CornerC(:,2))];
%         isOKcornerC=true;
%     else
%         fprintf('C,');
%     end
%     if ~isempty(CornerD)
%         XYcornerD=[mean(CornerD(:,1)),mean(CornerD(:,2))];
%         isOKcornerD=true;
%     else
%         fprintf('D,');
%     end
%     fprintf('\n');
%     % Get Lines Positions
%     if sum([isempty(CornerA),isempty(CornerB),isempty(CornerC),isempty(CornerD)])==2
%         if ~isOKcornerA && ~isOKcornerB
%             
%         end
%         if ~isOKcornerA && ~isOKcornerC
%             
%         end    
%         if ~isOKcornerA && ~isOKcornerD
%             
%         end
%         if ~isOKcornerB && ~isOKcornerC
%             
%         end 
%         if ~isOKcornerB && ~isOKcornerD
%             [mAC,bAC]=getlineWall(XYcornerA,XYcornerC);
%             xlineAC=linspace(0,round(max(CornerC(:,1))));
%             LineAC=mAC*xlineAC+bAC;
%             
%             % Perpendicular
% %             LineAB=(-1/mAC)*xlineAC+-1/mAC)*bAC+-XYcornerA(2);
%             
%             if XYcornerC(2)>XYcornerA(2)
%                 XYcornerB=[MaximumX,(-1/mAC)*MaximumX+bAC]
%             end
%         end    
%         if ~isOKcornerC && ~isOKcornerD
%             
%         end            
%     else
%         fprintf('>>No identified Walls\n')
%         ContinueStep=false;
%     end
% else
%     fprintf('>>Building walls:\n');
%     % All corners detected
%     if and(isOKcornerA,isOKcornerB)
%         fprintf('A-B\n');
%         XYcornerA=[mean(CornerA(:,1)),mean(CornerA(:,2))];
%         XYcornerB=[mean(CornerB(:,1)),mean(CornerB(:,2))];
%         [mAB,bAB]=getlineWall(XYcornerA,XYcornerB);
%         xlineAB=linspace(0,round(max(CornerB(:,1))));
%         LineAB=mAB*xlineAB+bAB;
%     end
%     if and(isOKcornerC,isOKcornerD)
%         fprintf('C-D\n');
%         XYcornerC=[mean(CornerC(:,1)),mean(CornerC(:,2))];
%         XYcornerD=[mean(CornerD(:,1)),mean(CornerD(:,2))];
%         [mCD,bCD]=getlineWall(XYcornerC,XYcornerD);
%         xlineCD=linspace(0,round(max(CornerD(:,1))));
%         LineCD=mCD*xlineCD+bCD;
%     end
%     % Three corners detected
%     if xor(isOKcornerA,isOKcornerB) % Missing Line A-B
%         fprintf('A-B estimating:');
%         % Line CD exists
%         if isOKcornerA
%             XYcornerA=[mean(CornerA(:,1)),mean(CornerA(:,2))];
%             OffsetAC=sqrt((XYcornerC(1)-XYcornerA(1)).^2+(XYcornerC(2)-XYcornerA(2)).^2);
%             XYcornerB=[XYcornerD(1),XYcornerD(2)-OffsetAC];
%             bOffset=bCD-OffsetAC;
%             LimitX=CornerA(1);
%             fprintf('B\n')
%         else 
%             XYcornerB=[mean(CornerB(:,1)),mean(CornerB(:,2))];
%             OffsetBD=sqrt((XYcornerD(1)-XYcornerB(1)).^2+(XYcornerD(2)-XYcornerB(2)).^2);
%             XYcornerA=[XYcornerC(1),XYcornerC(2)-OffsetBD];
%             bOffset=bCD-OffsetBD;
%             LimitX=CornerB(1);
%             fprintf('A\n')
%         end
%         xlineAB=linspace(0,round(max(CornerD(:,1))));
%         LineAB=mCD*xlineAB+bOffset;
%     elseif xor(isOKcornerC,isOKcornerD) % Missing Line C-D
%         fprintf('A-B estimating:');
%         % Line AB exists
%         if isOKcornerC
%             XYcornerC=[mean(CornerC(:,1)),mean(CornerC(:,2))];
%             OffsetAC=sqrt((XYcornerC(1)-XYcornerA(1)).^2+(XYcornerC(2)-XYcornerA(2)).^2);
%             XYcornerD=[XYcornerB(1),XYcornerB(2)+OffsetAC];
%             bOffset=bAB+OffsetAC;
%             LimitX=CornerB(1);
%             fprintf('D\n')
%         else 
%             XYcornerD=[mean(CornerD(:,1)),mean(CornerD(:,2))];
%             OffsetBD=sqrt((XYcornerD(1)-XYcornerB(1)).^2+(XYcornerD(2)-XYcornerB(2)).^2);
%             XYcornerC=[XYcornerA(1),XYcornerA(2)+OffsetBD];
%             bOffset=bAB+OffsetBD;
%             LimitX=CornerB(1);
%             fprintf('C\n')
%         end
%         xlineCD=linspace(0,round(max(CornerB(:,1))));
%         LineCD=mAB*xlineCD+bOffset;
%     end
%     fprintf('\n');
% end
% % Build Total Space Area: A-B-C-D
% % Width Bridge (varaince of CornerX)
% 
% %% Tail and Nose Axis
% if ContinueStep
%     % Physical Limits: mice are shorter than AC & BD distances
%     LenghtThreshold=3*sqrt((XYcornerA(:,1)-XYcornerC(:,1)).^2+(XYcornerA(:,2)-XYcornerC(:,2)).^2);
%     OkDet=OkDet(NoseTailLenght<LenghtThreshold);
%     TailXY=[GaitTable.TailBaseX(OkDet),GaitTable.TailBaseY(OkDet)];
%     NoseXY=[GaitTable.NoseX(OkDet),GaitTable.NoseY(OkDet)];
%     NoseTailLenght=sqrt((TailXY(:,1)-NoseXY(:,1)).^2+(TailXY(:,2)-NoseXY(:,2)).^2);
% 
%     %% Exploration
%     % WORK SPACE: BRIDGE
%     figure
%     AreaWork=subplot(1,1,1);
%     plot(AreaWork,xlineAB,LineAB,'--k','LineWidth',2); hold on;
%     plot(AreaWork,xlineCD,LineCD,'--k','LineWidth',2);
%     plot(AreaWork,XYcornerA(1),XYcornerA(2),'+','MarkerEdgeColor','r'); 
%     plot(AreaWork,XYcornerB(1),XYcornerB(2),'+','MarkerEdgeColor','r'); 
%     plot(AreaWork,XYcornerC(1),XYcornerC(2),'+','MarkerEdgeColor','r'); 
%     plot(AreaWork,XYcornerD(1),XYcornerD(2),'+','MarkerEdgeColor','r'); 
%     plot(AreaWork,XYcornerA(1),XYcornerA(2),'s','MarkerSize',10,'MarkerEdgeColor','k'); 
%     plot(AreaWork,XYcornerB(1),XYcornerB(2),'s','MarkerSize',10,'MarkerEdgeColor','k'); 
%     plot(AreaWork,XYcornerC(1),XYcornerC(2),'s','MarkerSize',10,'MarkerEdgeColor','k'); 
%     plot(AreaWork,XYcornerD(1),XYcornerD(2),'s','MarkerSize',10,'MarkerEdgeColor','k'); 
% 
%     hold(AreaWork,'on')
%     AreaWork.ALimMode='manual';
%     AreaWork.XLim=[0,max([XYcornerD(1),XYcornerB(1)])];
%     AreaWork.YLim=[0,max([XYcornerC(2),XYcornerD(2)])];
%     grid on;
%     AreaWork.YDir='reverse';
%     % %% ANIMATION
%     if DataOK
%     aux=0;
%     TimeLine=plot(ax1,[0,0],[min(NoseTailLenght),max(NoseTailLenght)],...
%         'LineWidth',2,'Color','red','LineStyle','--');
%     for n=1:numel(OkDet)
%         % Modify Objects
%         TimeLine.XData=[TimeAxis(n),TimeAxis(n)];
%         if ismember(TimeAxis(n),AllTimesWalk)
%             if aux>0
%                 TailBase.Visible='on';
%                 Nose.Visible='on';
%                 AxisNT.Visible='on';
%                 TailBase.XData=TailXY(n,1);
%                 TailBase.YData=TailXY(n,2);
%                 Nose.XData=NoseXY(n,1);
%                 Nose.YData=NoseXY(n,2);
%                 AxisNT.XData=[TailXY(n,1),NoseXY(n,1)];
%                 AxisNT.YData=[TailXY(n,2),NoseXY(n,2)];
%             else % Create Objects
%                 TailBase=plot(AreaWork,TailXY(n,1),TailXY(n,2),...
%                     'Marker','*','MarkerEdgeColor',[1,0,0],'MarkerFaceColor',[1 .6 .6],'MarkerSize',5);
%                 Nose=plot(AreaWork,NoseXY(n,1),NoseXY(n,2),...
%                     'Marker','d','MarkerEdgeColor',[0,0,1],'MarkerFaceColor',[.6 .6 1],'MarkerSize',5);
%                 AxisNT=plot([TailXY(n,1),NoseXY(n,1)],[TailXY(n,2),NoseXY(n,2)],...
%                     'Color','k','LineWidth',2);
%                 aux=aux+1;
%             end
%         else
%             if aux>0
%                 TailBase.Visible='off';
%                 Nose.Visible='off';
%                 AxisNT.Visible='off';
%             end
%         end
% 
%         drawnow
%         pause(0.1)
%         fprintf('Progress: %3.2f\n',100*n/numel(OkDet));
%     end
%     end
% end