%% Setup
clear; close all;
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
fprintf('>Reading data:')
% Samples with acceptable likelihood of detectino
OkDet=intersect(find(GaitTable.TailBaseL>=LikelihoodThreshold),...
        find(GaitTable.NoseL>=LikelihoodThreshold));
TailXY=[GaitTable.TailBaseX(OkDet),GaitTable.TailBaseY(OkDet)];
NoseXY=[GaitTable.NoseX(OkDet),GaitTable.NoseY(OkDet)];
NoseTailLenght=sqrt((TailXY(:,1)-NoseXY(:,1)).^2+(TailXY(:,2)-NoseXY(:,2)).^2);    
TimeAxis=GaitTable.TimeIndex(OkDet)+1; % From DLC it starts @ 0
NTLs=smooth(NoseTailLenght,20);
fprintf('done\n')
fprintf('Plotting Nose-Tail Axis length distribution:')
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
    MinLenTh = inputdlg('Length Threshold : ','pixels', [1 75], {num2str(MinLengt)});
    MinLengt=str2double( MinLenTh{1});
    IndexesOK=find(NTLs>MinLengt);  % Indexes above threshold
    % Discontinuos samples
    DataOK=true;
else
    disp('>>ATTENTION: Nose-Tail-Axis missdetected!!')
    DataOK=false;
end
fprintf('done.\n')
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
%% Corners Bridge A-B-C-D

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
    
    [FNsnap,PNsnap] = uigetfile({'*.png';'*.jpg'},sprintf('Snapshot from %s video',FileName),...
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

%% Pixel to CM
BRIDGEMEASURE; % loads cm @ BridgeWidth var
%       y = mx + b  ->  y-mx-b=0    ->  Ax+By+C=0
%                                   A =-m; B=1 C=-b
A1=-mean([mAB,mCD]); B1=1; C1=-bAB; % AB line equation
A2=-mean([mAB,mCD]); B2=1; C2=-bCD; % CD line equation
DAB=abs(C2-C1)/sqrt(A1^2+B1^2);
cmSlahpisx=BridgeWidth/DAB;
% Example:
% % Arbitrary  points
% x_1=STPs{1,1}(1,1);y_1=STPs{1,1}(1,2);
% x_2=STPs{1,2}(1,1);y_2=STPs{1,2}(1,2);
% dpix=get_distance([x_1,y_1;x_2,y_2]);
% dpix=dpix(end);
% dcm=dpix*cmSlahpisx;

%% Check Limbs
TableData=table;
dTailNose=[];
STPS={};
dAB=get_distance([CornerA;CornerB]);
dCD=get_distance([CornerC;CornerD]);
dAC=get_distance([CornerA;CornerC]);
dBD=get_distance([CornerB;CornerD]);
xLen=max([dAB(end),dCD(end)]);
yLen=max([dAC(end),dBD(end)]);
ncro=1;
for n=1:numel(CrossingTimes) % Loop for crossing times
    SignDir=[]; % Change of Direction Detector
    naux=1; % auxiliar counter: increase each Crossing and Direction change
    % Make Figure
    figure('Name',['Mouse Crossing n=',num2str(n)],'NumberTitle','off')
    Ax{n}=subplot(1,1,1);
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
    Mr2lindex=[];
    Ml2rindex=[];
    CenterXY=[];
    iok=[];
    for i=1:numel(TimesNH) 
        CenterXYactual=[mean([GaitTable.NoseX(TimesNH(i)),GaitTable.TailBaseX(TimesNH(i))]),mean([GaitTable.NoseY(TimesNH(i)),GaitTable.TailBaseY(TimesNH(i))])];
        % IF Mouese CENTER is in between WALLS
        if and(and(CenterXYactual(1)>CornerA(1),CenterXYactual(1)<CornerB(1)) && and(CenterXYactual(2)>CornerB(2),CenterXYactual(2)<CornerC(2)),...
                GaitTable.NoseL(TimesNH(i))>LikelihoodThreshold && GaitTable.TailBaseL(TimesNH(i))>LikelihoodThreshold )
            
            CenterXY=[CenterXY;mean([GaitTable.NoseX(TimesNH(i)),GaitTable.TailBaseX(TimesNH(i))]),mean([GaitTable.NoseY(TimesNH(i)),GaitTable.TailBaseY(TimesNH(i))])];
            plot(mean([GaitTable.NoseX(TimesNH(i)),GaitTable.TailBaseX(TimesNH(i))]),mean([GaitTable.NoseY(TimesNH(i)),GaitTable.TailBaseY(TimesNH(i))]),'y+');
            % plot(GaitTable.NoseX(TimesNH(i)),GaitTable.NoseY(TimesNH(i)),'yd');
            p1 = [GaitTable.TailBaseX(TimesNH(i)),GaitTable.TailBaseY(TimesNH(i))]; % First Point
            p2 = [GaitTable.NoseX(TimesNH(i)),GaitTable.NoseY(TimesNH(i))];         % Second Point
            dp = p2-p1;                         % Difference
            if dp(1)<0
                fprintf('\n<-Going left\n')
                direction=0;
            elseif dp(1)>0
                fprintf('\nGoing right->\n')
                direction=1;
            else
                fprintf('no movimiento')
            end
            SignDir=[SignDir;sign(dp(1))];
            quiver(p1(1),p1(2),dp(1),dp(2),'LineStyle','-','Color','w')
            iok=[iok;i];
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
            if ~isempty(XYul)
                UpLeftLimb=true;
            else
                UpLeftLimb=false;
            end
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
            if ~isempty(XYur)
                UpRightLimb=true;
            else
                UpRightLimb=false;
            end
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
            if ~isempty(XYll)
                LowLeftLimb=true;
            else
                LowLeftLimb=false;
            end
            % Lower Limb Right  ###########################################
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
            if ~isempty(XYlr)
                LowRightLimb=true;
            else
                LowRightLimb=false;
            end
            % Stride Lines $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            % init as NaNs
            mXYul=NaN;
            mXYll=NaN;
            mXYur=NaN;
            mXYlr=NaN;
            % Checking Points: 0:left, 1:right
            if direction
                % left limb Y are above(visually) below(numerically) of Center
                if UpLeftLimb
                    mXYul=mean(XYul(XYul(:,2)>CenterXYactual(:,2),:),1);
                end
                if LowLeftLimb
                    mXYll=mean(XYll(XYll(:,2)>CenterXYactual(:,2),:),1);
                end
                % right limbs Y are below(visually) below(numerically) of Center
                if UpRightLimb
                    mXYur=mean(XYur(XYur(:,2)<CenterXYactual(:,2),:),1);
                end
                if LowRightLimb
                    mXYlr=mean(XYlr(XYlr(:,2)<CenterXYactual(:,2),:),1);
                end
            else
                % left limb Y are above(visually) below(numerically) of Center
                if UpLeftLimb
                    mXYul=mean(XYul(XYul(:,2)<CenterXYactual(:,2),:),1);
                end
                if LowLeftLimb
                    mXYll=mean(XYll(XYll(:,2)<CenterXYactual(:,2),:),1);
                end
                % right limbs Y are below(visually) below(numerically) of Center
                if UpRightLimb
                    mXYur=mean(XYur(XYur(:,2)>CenterXYactual(:,2),:),1);
                end
                if LowRightLimb
                    mXYlr=mean(XYlr(XYlr(:,2)>CenterXYactual(:,2),:),1);
                end
            end
            % IF missdetected
            if isnan(mXYul(1))
                UpLeftLimb=false;
            end
            if isnan(mXYll(1))
                LowLeftLimb=false;
            end
            if isnan(mXYur(1))
                UpRightLimb=false;
            end
            if isnan(mXYlr(1))
                LowRightLimb=false;
            end
            % Plotting
            % DIAGONALS ---------------------------------------------
            if LowLeftLimb && UpRightLimb % right2left stride
                plot(Ax{n},[mXYll(:,1),mXYur(:,1)],[mXYll(:,2),mXYur(:,2)],'-*m')
                disp('right2left stride')
                R2Lstride=[R2Lstride;mXYur;mXYll];
                [mRL,bRL]=getlineWall(mXYur,mXYll);
                Mr2l=[Mr2l;mRL];
                Mr2lindex=[Mr2lindex,1];
            else
                Mr2lindex=[Mr2lindex,0];
            end
            if LowRightLimb && UpLeftLimb % left2right stride
                plot(Ax{n},[mXYlr(:,1),mXYul(:,1)],[mXYlr(:,2),mXYul(:,2)],'-*r')
                disp('left2right stride')
                L2Rstride=[L2Rstride;mXYul;mXYlr];
                [mLR,bLR]=getlineWall(mXYul,mXYlr);
                Ml2r=[Ml2r;mLR];
                Ml2rindex=[Ml2rindex,1];
            else
                Ml2rindex=[Ml2rindex,0];
            end
            drawnow;
            pause(0.01);
        end
    end
    DirChanages=find(diff(SignDir)~=0);
    Inters=[1;DirChanages;numel(SignDir)];
    A=1;
    for j=2:numel(Inters)
        B=Inters(j);
        % Path
        Path{naux}=CenterXY(iok(A:B));
        % Steps
        A=B+1;
        naux=naux+1;
    end
    % STEPS ANLAYSIS ##################################
    if and(sum(Ml2rindex)>0,sum(Mr2lindex)>0)
        % [STPS,KS]=getsetpmagic(Ml2rindex,Mr2lindex,L2Rstride,R2Lstride);
        %     KS=0 when LR and KS=1 when RL
        STePS_LR=getsetpmagicOK(Ml2rindex,L2Rstride);
        STePS_RL=getsetpmagicOK(Mr2lindex,R2Lstride);
%         % Steps per Limb:
%         STPS{1,1}=UpLeftLimb;
%         STPS{1,2}=UpRightLimb;
%         STPS{1,3}=LowLeftLimb;
%         STPS{1,4}=LowRightLimb;
        STPS=getSTEPSok(STePS_LR,STePS_RL);
        % Make Table:
        T=makesteptable(STPS,ncro,cmSlahpisx);
        TableData=[TableData;T];
        ncro=ncro+1;
%         if 1==1
            pause;
%         end
    else
        fprintf('\nNo STEPs detected\n')
    end
end

%% Save
% Saving Directory:
fprintf('\n>Saving ...\n')
disp(TableData)
CurDir=pwd;
eslaches=strfind(CurDir,filesep);

NameFolder='GaitStrides';
FileDirSave=[CurDir(1:eslaches(end)),NameFolder,filesep];

if exist('FNsnap','var')
    NameOut=FNsnap;
else
    NameOut=FileName;
end
DotIndex=strfind(NameOut,'.');
if isempty(DotIndex)
    DotIndex=numel(NameOut);
end
NameOK = inputdlg('Save table as: ','Press OK to save; CANCEL to discard', [1 75], {NameOut(1:DotIndex-1)});

if isempty(NameOK )
    disp('> DISCARDED MEASUREMENT')
else
    fprintf('> SAVE at ')
    if ~isdir([FileDirSave])
        fprintf('created ');
        mkdir(FileDirSave);
    end
    fprintf('\n%s\n',FileDirSave);
    fprintf('\n%s\n',NameOK{1});
    writetable(TableData,[FileDirSave,NameOK{1},'.csv']);
    disp('SAVED')
end

%% Pixel to CM
% BRIDGEMEASURE; % loads cm @ BridgeWidth var
% %       y = mx + b  ->  y-mx-b=0    ->  Ax+By+C=0
% %                                   A =-m; B=1 C=-b
% % Distanci line to point (x_1,y_1)
% % D=abs(Ax_1+By_1+C)/sqrt(A.^2+B.^2)
% PerpSlope=1/mean([mAB,mCD]); % perpendicular average line to bridge
% % angle between vertical [pi=180°] and perpendicular line to bridge: pi - ...
% % angle between horizontal line and perpendicular line to bridge: atan
% Theta=pi-atan(PerpSlope); % [RADIANS] 
% 
% % Distance between AB and CD = BridgeWidth [cm]
% yCM=abs(BridgeWidth*sin(Theta)); % Y-projection in CM
% xCM=abs(BridgeWidth*cos(Theta)); % X-projection in CM
% 
% A1=-mean([mAB,mCD]); B1=1; C1=-bAB;
% A2=-mean([mAB,mCD]); B2=1; C2=-bCD;
% 
% DAB=abs(C2-C1)/sqrt(A1^2+B1^2);
% cmSlahpisx=BridgeWidth/DAB;
% yPIX=abs(DAB*sin(Theta));
% xPIX=abs(DAB*cos(Theta));
% yRate=yCM/yPIX;
% xRate=xCM/xPIX;
% 
% % Arbitrary  points
% x_1=STPs{1,1}(1,1);y_1=STPs{1,1}(1,2);
% x_2=STPs{1,2}(1,1);y_2=STPs{1,2}(1,2);
% 
% % DAB
% dpix=get_distance([x_1,y_1;x_2,y_2]);
% dpix=dpix(end);
% dcm=dpix*cmSlahpisx;
% 
% % Differences
% dX=abs(x_1-x_2).*xRate;
% dY=abs(y_1-y_2).*yRate;
% sqrt(dX^2+dY^2);