%% Setup
clear;
global distance;
global point1;
global point2;
clc

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
%% Scale to Centimeters

% Accept just ALL good LIkelihoods in average
% WALL: A-B
isOKcornerA=mean(GaitTable.CornerAL)>LikelihoodThreshold;
isOKcornerB=mean(GaitTable.CornerBL)>LikelihoodThreshold;
% WALL: C-D
isOKcornerC=mean(GaitTable.CornerCL)>LikelihoodThreshold;
isOKcornerD=mean(GaitTable.CornerDL)>LikelihoodThreshold;
MaximumX=max(GaitTable.NoseX(GaitTable.NoseX>=LikelihoodThreshold));
 
% Retrieve Coordinates
if sum([isOKcornerA,isOKcornerB,isOKcornerC,isOKcornerD])<4
    
    [FNsnap,PNsnap] = uigetfile('*.png',sprintf('Snapshot from %s video',FileName),...
        'MultiSelect', 'off',FileUbication);
    [Diameters,Corners]=borders_api(FileName,PNsnap,FNsnap); % corners
    CornerA=Corners(1,:);
    CornerB=Corners(2,:);
    CornerC=Corners(3,:);
    CornerD=Corners(4,:);
else
    % A corner
    CornerA = mean([GaitTable.CornerAX(GaitTable.CornerAL>=LikelihoodThreshold),...
        GaitTable.CornerAY(GaitTable.CornerAL>=LikelihoodThreshold)]);
    % B corner
    CornerB = mean([GaitTable.CornerBX(GaitTable.CornerBL>=LikelihoodThreshold),...
        GaitTable.CornerBY(GaitTable.CornerBL>=LikelihoodThreshold)]);
    % C corner
    CornerC = mean([GaitTable.CornerCX(GaitTable.CornerCL>=LikelihoodThreshold),...
        GaitTable.CornerCY(GaitTable.CornerCL>=LikelihoodThreshold)]);
    % D corner
    CornerD = mean([GaitTable.CornerDX(GaitTable.CornerDL>=LikelihoodThreshold),...
        GaitTable.CornerDY(GaitTable.CornerDL>=LikelihoodThreshold)]);
end

% % Build Total Space Area: A-B-C-D
[mAB,bAB]=getlineWall(CornerA,CornerB);
[mCD,bCD]=getlineWall(CornerC,CornerD);
fprintf('>Border lines slope difference: %3.2f\n',abs(mAB-mCD));
fprintf('>Y-offset difference: %3.2f pixels\n',abs(bAB-bCD));

%% Analyze Longest Crossing
% Not necessary true, maight expend time hesitating
[~,Crossin]=max(Nframes);
InterValInit=min(CrossingTimes{Crossin});
InterValEnd=max(CrossingTimes{Crossin});

%% Check Limbs

dTailNose=[];
STPS={};
for n=1:numel(CrossingTimes)
% for n=4:4
    figure('Name',['Mouse Crossing n=',num2str(n)],'NumberTitle','off')
    Ax{n}=subplot(1,1,1);
    dAB=get_distance([CornerA;CornerB]);
    dCD=get_distance([CornerC;CornerD]);
    dAC=get_distance([CornerA;CornerC]);
    dBD=get_distance([CornerB;CornerD]);
    xLen=max([dAB(end),dCD(end)]);
    yLen=max([dAC(end),dBD(end)]);
    Ax{n}.XLim=[round(min([CornerA(1),CornerB(1),CornerC(1),CornerD(1)])-0.1*xLen),...
        round(max([CornerA(1),CornerB(1),CornerC(1),CornerD(1)])+0.1*xLen)];
    Ax{n}.YLim=[round(min([CornerA(2),CornerB(2),CornerC(2),CornerD(2)])-0.1*yLen),...
        round(max([CornerA(2),CornerB(2),CornerC(2),CornerD(2)])+0.1*yLen)];
    set(Ax{n},'Color',[0.25,0.25,0.25]);
    % Ax.XLimMode:
    hold(Ax{n}, 'on')
    plot(Ax{n},[CornerA(1),CornerB(1)],[CornerA(2),CornerB(2)],'g--','LineWidth',2); 
    plot(Ax{n},[CornerC(1),CornerD(1)],[CornerC(2),CornerD(2)],'g--','LineWidth',2);
    Ax{n}.YDir='reverse';
    % Upper Limb Left
    ULPplot=plot(Ax{n},0.5,0.5,'xb','MarkerSize',5,'LineWidth',2); % Palm
    ULFplot=plot(Ax{n},0.4,0.4,'^b','MarkerSize',5,'LineWidth',2); % Finger
    ULHplot=plot(Ax{n},0.3,0.3,'ob','MarkerSize',5,'LineWidth',2); % Heel
    % Upper Limb Right
    URPplot=plot(Ax{n},0.8,0.8,'xb','MarkerSize',5,'LineWidth',2); % Palm
    URFplot=plot(Ax{n},0.7,0.7,'^b','MarkerSize',5,'LineWidth',2); % Finger
    URHplot=plot(Ax{n},0.6,0.6,'ob','MarkerSize',5,'LineWidth',2); % Heel
    % Lower Limb Left
    LLPplot=plot(Ax{n},0.3,0.5,'xb','MarkerSize',5,'LineWidth',2); % Palm
    LLFplot=plot(Ax{n},0.2,0.4,'^b','MarkerSize',5,'LineWidth',2); % Finger
    LLHplot=plot(Ax{n},0.1,0.3,'ob','MarkerSize',5,'LineWidth',2); % Heel
    % Lower Limb Right
    LRPplot=plot(Ax{n},0.6,0.8,'xb','MarkerSize',5,'LineWidth',2); % Palm
    LRFplot=plot(Ax{n},0.5,0.7,'^b','MarkerSize',5,'LineWidth',2); % Finger
    LRHplot=plot(Ax{n},0.4,0.6,'ob','MarkerSize',5,'LineWidth',2); % Heel
    % Axis Nose Tail
    AxisNT=plot([0,10],[20,30],'Color','k','LineWidth',2);
    % Set off visibility
    set([ULPplot,ULFplot,ULHplot,URPplot,URFplot,URHplot,...
        LLPplot,LLFplot,LLHplot,LRPplot,LRFplot,LRHplot,AxisNT],...
        'Visible','off');
    
    TimesNH=CrossingTimes{n};
    fprintf('>Cross %i Frame:',n);
    
    R2Lstride=[];
    L2Rstride=[];
    Mr2l=[];
    Ml2r=[];
    for i=1:numel(TimesNH) 
        fprintf('%i,',TimesNH(i))
        AxisNT.XData = [GaitTable.NoseX(TimesNH(i)),GaitTable.TailBaseX(TimesNH(i))];
        AxisNT.YData = [GaitTable.NoseY(TimesNH(i)),GaitTable.TailBaseY(TimesNH(i))];
        d=get_distance([AxisNT.XData;AxisNT.YData]);
        dTailNose=[dTailNose;d(end)];
        AxisNT.Visible='on';
        
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
        
        if size(XYll,1)==3 && size(XYur,1)==3 % right2left stride
            plot(Ax{n},[XYll(1,1),XYur(1,1)],[XYll(1,2),XYur(1,2)],'--r')
            disp('right2left stride')
            R2Lstride=[R2Lstride;XYur(1,:);XYll(1,:)];
            [mRL,bRL]=getlineWall(XYur(1,:),XYll(1,:));
            % xlin=CornerA(1):CornerB;
            % ylin=mRL.*xlin+bRL;
            % plot(xlin,ylin,'y');
            Mr2l=[Mr2l;mRL];
        end
        if size(XYlr,1)==3 && size(XYul,1)==3 % left2right stride
            plot(Ax{n},[XYlr(1,1),XYul(1,1)],[XYlr(1,2),XYul(1,2)],'--r')
            disp('left2right stride')
            L2Rstride=[L2Rstride;XYul(1,:);XYlr(1,:)];
            [mLR,bLR]=getlineWall(XYul(1,:),XYlr(1,:));
            % xlin=CornerC(1):CornerD;
            % ylin=mLR.*xlin+bLR;
            % plot(xlin,ylin,'m');
            Ml2r=[Ml2r;mLR];
        end
        
        drawnow;
        pause(0.1);
    end
    % Stride diagonal among paws
    [indxRL,indxLR]=closeperpslopes(Mr2l,Ml2r,R2Lstride,L2Rstride);
    
    STPS{n,1}=R2Lstride([indxRL*2-1,indxRL*2],:);
    STPS{n,2}=L2Rstride([indxLR*2-1,indxLR*2],:);
    % Steps
    plotsteps(indxRL,R2Lstride);
    plotsteps(indxLR,L2Rstride);
    fprintf('\n')
    if or(~isempty( STPS{n,1}),~isempty( STPS{n,2}))
        % Front Right to Back Left
        XYrl=STPS{n,1};
        % Front Left to Back Right
        XYlr=STPS{n,2};
        % Gettting Distance
        XYlrclean=mergecloseones(XYlr,MinLengt);
        XYrlclean=mergecloseones(XYrl,MinLengt);
        fprintf('>Front Right to Back Left steps: %i\n',size(XYrlclean,1));
        fprintf('>Front Left to Back Right steps: %i\n',size(XYlrclean,1));
        plotsteps([],XYlrclean,'ko',3);
        plotsteps([],XYrlclean,'k*',3);
        STPs{n,1}=XYlrclean; % left to rigth
        STPs{n,2}=XYrlclean; % rigth to left
    else
        fprintf('>No Steps detected\n')
    end
end
%% Analyze Steps
% hallfigs = findall(groot,'Type','figure');
for n=1:size(STPs,1)
    if or(~isempty( STPs{n,1}),~isempty( STPs{n,2}))
        dStrideLR=get_distance(STPs{n,1}(1:2:end,:))
        STPs{n,2}
        
    else
        fprintf('>Nothing')
    end
end
%% Pixel to CM
BRIDGEMEASURE; % loads cm @ BridgeWidth var
%       y = mx + b  ->  y-mx-b=0    ->  Ax+By+C=0
%                                   A =-m; B=1 C=-b
% Distanci line to point (x_1,y_1)
% D=abs(Ax_1+By_1+C)/sqrt(A.^2+B.^2)
PerpSlope=1/mean([mAB,mCD]); % m
% CD line to point
x_1=STPs{n,1}(1);y_1=STPs{n,1}(2);

A=-mean([mAB,mCD]); B=1; C=-bAB;
alph1=abs(A*x_1+B*y_1+C)/sqrt(A.^2+B.^2);

A=-mean([mAB,mCD]); B=1; C=-bCD;
alph2=abs(A*x_1+B*y_1+C)/sqrt(A.^2+B.^2);

dAB=alph1+alph2;
Theta=pi-atan(PerpSlope)
yCM=abs(BridgeWidth*sin(Theta));
xCM=abs(BridgeWidth*cos(Theta));
yPIX=abs(dAB*sin(Theta));
xPIX=abs(dAB*cos(Theta));
yRate=yCM/yPIX;
xRate=xCM/xPIX;
%  For the Point
% deg2rad(180)
% rad2deg( atan(Perpednicular) )
% alp=abs()

