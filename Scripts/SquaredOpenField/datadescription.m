% Feature descriptives
%% READ DATA
clear;
% close all;
Field_Heigth = 41;        % cm
Field_Width = 41;         % cm
doplot=true;
[FileNameANS,PathName] = uigetfile('*.csv','Select CSV files',...
'MultiSelect', 'on',pwd);
if isstr(FileNameANS)
    FNbuff=FileNameANS;
    FileNameANS={};
    FileNameANS{1}=FNbuff;
    fprintf('single file')
else
    fprintf('list of files')
end
%% SETUP
clc;
R=table(); % Final Table
fs=30; % fps (normally)
ws=1; % windows in seconds
%% LOOP FILES
for ifiles=1:numel(FileNameANS)
    %% Load Data
    FileName=FileNameANS{ifiles};
    FN=FileName(1:strfind(FileName,'DLC'));
    X=importfile([PathName,FileName]);
    %% Description of the Data    
    t=X.bodyparts; % just for a table thing
    [Nobs,Ncols]=size(X);
    Nparts=round((Ncols-1)/3); % ignoring times and dividded by 3:X,Y,Likelihood
    fprintf('>Frames: %i: %3.2f [s], with %i bodyparts:\n',Nobs,Nobs/fs,Nparts);
    BodyPartsNames=X.Properties.VariableNames(2:3:end);
    Xmat=table2array(X);
    % Column index:
    Xcols=[];
    Ycols=[];
    Lcols=[];
    for n=0:Nparts-1
        indxX=n*3+2; % X coordinate
        indxY=n*3+3; % Y coordinate
        indxL=n*3+4; % Likelihood of de DLC detection
        fprintf(' %s avg likelihood:%3.2f\n',BodyPartsNames{n+1},mean(Xmat(:,indxL)));
        Xcols=[Xcols;indxX];
        Ycols=[Ycols;indxY];
        Lcols=[Lcols;indxL];    
    end
    
%     [~,maxindex]=max(prod(Xmat(:,Lcols),2));
%     %% depict example
%     if doplot
%         figure; hold on;
%         for n=1:Nparts
%             plot(Xmat(maxindex,Xcols(n)),Xmat(maxindex,Ycols(n)),'*')
%         end
%         axis tight; grid on;
%         legend(BodyPartsNames)
%     end
    %% Panza trajectory
    IndexPanza=find(ismember(BodyPartsNames,'panza'));
    Lthres=min(X.panza2); % Minimum Likelihood of the best part
    %% CORNER - pixel to CM 
    PSDindex=find(ismember(BodyPartsNames,'PSD'));
    PSIindex=find(ismember(BodyPartsNames,'PSI'));
    PIDindex=find(ismember(BodyPartsNames,'PID'));
    PIIindex=find(ismember(BodyPartsNames,'PII'));
    % Corner
    Corner1=[mean(Xmat(:,Xcols(PSDindex))),mean(Xmat(:,Ycols(PSDindex)))];
    Corner2=[mean(Xmat(:,Xcols(PSIindex))),mean(Xmat(:,Ycols(PSIindex)))];
    Corner3=[mean(Xmat(:,Xcols(PIDindex))),mean(Xmat(:,Ycols(PIDindex)))];
    Corner4=[mean(Xmat(:,Xcols(PIIindex))),mean(Xmat(:,Ycols(PIIindex)))];
    
    RightWallsSize=get_distance([Corner1;Corner3]);
    LeftWallsSize=get_distance([Corner2;Corner4]);
    VerticalWall=mean([RightWallsSize(end),LeftWallsSize(end)]);
    UpperWallsSize=get_distance([Corner1;Corner2]);
    LowerWallsSize=get_distance([Corner3;Corner4]);
    HorizontalWall=mean([UpperWallsSize(end),LowerWallsSize(end)]);
    
    Xrate=Field_Width/HorizontalWall;
    Yrate=Field_Heigth/VerticalWall;
    %% ANIMAL CENTER
%     BaseXY=getlikelycoords(X.base_cola,X.base_cola1,X.base_cola2,Lthres);
%     BaseXY=[BaseXY(:,1)*Xrate,BaseXY(:,2)*Yrate];
%     CuelloXY=getlikelycoords(X.cuello,X.cuello1,X.cuello2,Lthres);
%     CuelloXY=[CuelloXY(:,1)*Xrate,CuelloXY(:,2)*Yrate];
    
    CenterX = mean(Xmat(:,Xcols(5:end)),2,'omitnan');
    CenterY = mean(Xmat(:,Ycols(5:end)),2,'omitnan');
    
    % PANZA
    [Xsmoothpanza,Ysmoothpanza]=smoothpath(t,Xmat(:,Xcols(IndexPanza)),Xmat(:,Ycols(IndexPanza)));
    % CENTROID
%     [Xsmoothpanza,Ysmoothpanza]=smoothpath(t,CenterX,CenterY); % PIXELS
%     00000000000000000000000000000000
%     CenterY = mean(Xmat(:,Ycols(5:end)),2,'omitnan');
%     % Smoothing options:
%     % 'moving' Moving average 
%     % 'lowess' Local regression using weighted linear least squares and a 1st degree polynomial model
%     % 'loess' Local regression using weighted linear least squares and a 2nd degree polynomial model
%     % 'sgolay' Savitzky-Golay filter. 
%     % 'rlowess' A robust version of 'lowess' that assigns lower weight to outliers in the regression
%     % 'rloess' A robust version of 'loess' that assigns lower weight to outliers in the regression.
%     
%     %     sspan=[0.0025]; % *100 size of the window
%     sspan=0.0005:0.0005:0.0250;
%     smethod='loess';
%     Xerrstd=0; Yerrstd=0; i=0;
%     while Xerrstd<1 && Yerrstd<1
%         i=i+1;
%         Xsmoothpanza=smooth(t,Xmat(:,Xcols(IndexPanza)),sspan(i),smethod);
%         Ysmoothpanza=smooth(t,Xmat(:,Ycols(IndexPanza)),sspan(i),smethod);
%         resX=Xmat(:,Xcols(IndexPanza))-Xsmoothpanza;
%         resY=Xmat(:,Ycols(IndexPanza))-Ysmoothpanza;
%         Xerrstd=std(resX);
%         Yerrstd=std(resY);
%         RESIDUALS(i,:)=[Xerrstd,Yerrstd];
%         fprintf('>Span: %3.2f %% StdErrX:%3.2f px, StdErrY:%3.2f px\n',sspan(i)*100,std(resX),std(resY))
%     end
%     if i>1
%         i=i-1;
%     end
%     Xsmoothpanza=smooth(t,Xmat(:,Xcols(IndexPanza)),sspan(i),smethod);
%     Ysmoothpanza=smooth(t,Xmat(:,Ycols(IndexPanza)),sspan(i),smethod);
    % smoothed PDF, dinstante between Spatial Modes
    [pxsm,xsbin]=ksdensity(Xsmoothpanza,linspace(min(Xsmoothpanza),max(Xsmoothpanza),50));
    [pysm,ysbin]=ksdensity(Ysmoothpanza,linspace(min(Ysmoothpanza),max(Ysmoothpanza),50));
    [~,ModesXPosition]=findpeaks(pxsm,xsbin,'NPeaks',2,'SortStr','descend');
    [~,ModesYPosition]=findpeaks(pysm,ysbin,'NPeaks',2,'SortStr','descend');
    
%     [~,positinx]=max(pxsm);
%     [~,positiny]=max(pysm);
    
    
    ModeX_Distance_cm=abs(diff(ModesXPosition))*Xrate;
    ModeY_Distance_cm=abs(diff(ModesYPosition))*Yrate;
    
    if doplot
        figure
        axfield=subplot(3,3,[1,2,4,5]);
        plot(Xsmoothpanza,Ysmoothpanza,'b','LineWidth',2); hold on
        plot(Xmat(:,Xcols(IndexPanza)),Xmat(:,Ycols(IndexPanza)),'g'); 
%         plot(CenterX,CenterY,'g'); 
        plot(Corner1(1),Corner1(2),'+r','LineWidth',2);
        plot(Corner2(1),Corner2(2),'+r','LineWidth',2);
        plot(Corner3(1),Corner3(2),'+r','LineWidth',2);
        plot(Corner4(1),Corner3(2),'+r','LineWidth',2);
        axis([min([Corner1(1),Corner2(1),Corner3(1),Corner4(1)]),...
            max([Corner1(1),Corner2(1),Corner3(1),Corner4(1)]),...
            min([Corner1(2),Corner2(2),Corner3(2),Corner4(2)]),...
            max([Corner1(2),Corner2(2),Corner3(2),Corner4(2)])]);
        hold off;
        legend('smooth','raw')
        title(FN,'Interpreter','none')
        axpdfy=subplot(3,3,[3,6]);
        barh(ysbin,pysm,'k')
        grid on
        axpdfx=subplot(3,3,[7,8]);
        bar(xsbin,pxsm,'k')
        grid on
        linkaxes([axfield,axpdfy],'y');
        linkaxes([axfield,axpdfx],'x');
    end
    
    %% Velocity of the Belly (Bellycity)
    
    
    BaseXY=getlikelycoords(X.base_cola,X.base_cola1,X.base_cola2,Lthres);
    BaseXY=[BaseXY(:,1)*Xrate,BaseXY(:,2)*Yrate];
    
    CuelloXY=getlikelycoords(X.cuello,X.cuello1,X.cuello2,Lthres);
    CuelloXY=[CuelloXY(:,1)*Xrate,CuelloXY(:,2)*Yrate];
    
    Dcuellocola=twopartsdistance(BaseXY,CuelloXY);
    
    % Minimum lenght of axial length
    ThresVel=mean(Dcuellocola,'omitnan')-std(Dcuellocola,'omitnan');
    
    % Instante distance among frames
    d=get_distance([Xsmoothpanza.*Xrate,Ysmoothpanza.*Yrate]);  % [cm]
    % Instant bellocity
    veld=diff(d)./(1/fs);                                       % [cm / s]
    acel=diff(veld);                                            % [cm / s^2]
    drate=get_velocity_interval(d,ws,fs);                       % [cm / s]
    tvel=[0:numel(drate)-1]*ws;                                 % [s]
    fprintf('\n>Neck - Tail Base avg. distance: %3.2f cm\n>Progression Threshold: %3.2f cm\n Total distanca: %3.2fcm',...
        mean(Dcuellocola,'omitnan'),ThresVel,sum(d));
    if doplot
        figure;
        axs1=subplot(211);
        plot(tvel,drate,'b','LineWidth',2); hold on;
        plot([tvel(1),tvel(end)],[ThresVel,ThresVel],'k')
        plot([tvel(1),tvel(end)],[ThresVel,ThresVel],'r')
        title(FN,'Interpreter','none')
        ylabel(sprintf('distance rate [cm/%is]',ws))
        axs2=subplot(212);
        plot([0:numel(Dcuellocola)-1]./fs,Dcuellocola,'m','LineWidth',2);
        hold on;
        plot([0:numel(veld)-1]./fs,abs(veld),'r'); 
        plot([0:numel(d)-1]./fs,d,'g','LineWidth',2); hold off;
        ylabel('distance [cm]');
        xlabel('time [s]');
        legend('axiallength','velocity','distance')
        linkaxes([axs1,axs2],'x');
    end

    [AMP,TIMES]=findpeaks(drate,tvel,'MinPeakHeight',ThresVel);
    % AMP@[cm/s] | TIMES@[s]
    
    if isempty(AMP)
        fprintf('\n!>Poor movement detection, diminished velocity threshold\n')
        ThresVel=std(drate);
        [AMP,TIMES]=findpeaks(drate,tvel,'MinPeakHeight',ThresVel);
    end
    fprintf('\n[%i peaks detected]\n',numel(AMP))
    % Find continuous peaks in TIMES :
    PEAKS=zeros(numel(AMP),3);
    for n=1:numel(AMP)
        [~,tp]=find(tvel==TIMES(n));
        % Init of peak
        keepgo=true;
        tpre=tp;
        tinit=tpre;
        while keepgo && drate(tpre)-drate(tinit)>=0
            tpre=tinit;
            tinit=tpre-1;
            fprintf('<')
            if or(tpre<1,tinit<1)
                keepgo=false;
            end
        end
        % End of peak
        tpos=tp;
        tend=tpos;
        keepgo=true;
        while keepgo && drate(tend)-drate(tpos)<=0
            tpos=tend;
            tend=tpos+1;
            fprintf('>')
            if or(tpos>numel(drate),tend>numel(drate))
                keepgo=false;
            end
        end
        PEAKS(n,:)=[tinit,tvel(tend-1),AMP(n)];
        if doplot
            plot(axs1,[tinit:tvel(tend-1)],drate(tinit+1:tvel(tend-1)+1),'k')
        end
        fprintf('\n')
    end
    % Find Progressions
    ProgTable=findprogression(PEAKS);
    Nprogs=size(ProgTable,1);
    fprintf('>Results: %s with %i progressions.\n',FN,Nprogs);
    
    % Inter Progression Interval
    aux=1;
    for n=2:Nprogs
        IPI(aux)=[ProgTable(n,1)-ProgTable(n-1,2)];             % [cm]
        aux=aux+1;
    end
    meanIPI=mean(IPI);
    stdIPI=std(IPI);
    skewIPI=skewness(IPI);
    kurIPI=kurtosis(IPI);
    % Avg max Velocity
    VelProg=ProgTable(:,3);                                     % [cm/s]
    meanVEL=mean(VelProg);
    stdVEL=std(VelProg);
    skewVEL=skewness(VelProg);
    kurVEL=kurtosis(VelProg);
    % Duration
    DurProgs=ProgTable(:,2)-ProgTable(:,1);
    meanDUR=mean(DurProgs);
    stdDUR=std(DurProgs);
    skewDUR=skewness(DurProgs);
    kurDUR=kurtosis(DurProgs);
    
%     PosProg=[];
    MovementIndex=zeros(size(X,1),1);
    Xcm=Xmat(:,Xcols(IndexPanza)).*Xrate;
    Ycm=Xmat(:,Ycols(IndexPanza)).*Yrate;
    
    for j=1:size(ProgTable,1)
        
        A=round(ProgTable(j,1)*fs+1);
        B=round(ProgTable(j,2)*fs+1);
        Xbuff=zeros(2*(B-A+1),2);
        DIST(j)=sum(d(A:B));        % [cm]
        
        MovementIndex(A:B)=1;
        Xbuff(1:2:end,1)=Xsmoothpanza(A:B).*Xrate;
        Xbuff(1:2:end,2)=Ysmoothpanza(A:B).*Yrate;
        Xbuff(2:2:end,1)=Xcm(A:B);
        Xbuff(2:2:end,2)=Ycm(A:B);
        
%         OSCIL=get_distance(Xbuff);
%         plot(OSCIL); hold on
%         plot(smooth(OSCIL,80,smethod)); hold off
%         axis([0,numel(OSCIL),0,3])
%         % plot(Xcm(A:B),Ycm(A:B)); hold off
%         pause;
    end
%     DisProgs=get_distance(PosProg);
    
    meanDIST=mean(DIST);
    stdDIST=std(DIST);
    mediDIST=median(DIST);
    kurDIST=kurtosis(DIST);
    
    
    %% More parts
    
    % NarizXY=getlikelycoords(X.nariz,X.nariz1,X.nariz2,Lthres);
    % BaseCXY=getlikelycoords(X.base_cola,X.base_cola1,X.base_cola2,Lthres);
%     PanzaXY=getlikelycoords(X.panza,X.panza1,X.panza2,Lthres);
    % 
    % % Xmean=mean([NarizXY(:,1),BaseCXY(:,1),PanzaXY(:,1)],2,'omitnan');
    % % Ymean=mean([NarizXY(:,2),BaseCXY(:,2),PanzaXY(:,2)],2,'omitnan');
    % 
    % AxialA=twopartsdistance(NarizXY,PanzaXY);
    % AxialB=twopartsdistance(PanzaXY,BaseCXY);
    % VectorA=NarizXY-PanzaXY;
    % VectorB=BaseCXY-PanzaXY;
    % DOTAB=dot(VectorA,VectorB,2);
    % MagA=sqrt(sum(VectorA.^2,2));
    % MagB=sqrt(sum(VectorB.^2,2));
    % AngleAxis=acos(DOTAB./(MagA.*MagB));
    % 
    % AxisLength=AxialA+AxialB;
    % 
    % figure
    % ax1=subplot(211)
    % plot(t,AxisLength);
    % title('Tamaño Eje Axial [px]')
    % ax2=subplot(212)
    % plot(t,AngleAxis);
    % title('Ángulo Axial [rad]')
    % linkaxes([ax1,ax2],'x');
    %%  Differenc between Limbs and Belly
    PataDXY=getlikelycoords(X.pata_frontal_d,X.pata_frontal_d1,X.pata_frontal_d2,Lthres);
    PataIXY=getlikelycoords(X.pata_frontal_i,X.pata_frontal_i1,X.pata_frontal_i2,Lthres);

    DD=twopartsdistance([Xsmoothpanza,Ysmoothpanza],PataDXY);
    DI=twopartsdistance([Xsmoothpanza,Ysmoothpanza],PataIXY);
%     if doplot
%         figure
%         plot(DD); hold on;
%         plot(DI); hold off;
%     end


    % 
    Rtable=table({FN},...
        mean(Xsmoothpanza.*Xrate),std(Xsmoothpanza.*Xrate),kurtosis(Xsmoothpanza.*Xrate),skewness(Xsmoothpanza.*Xrate),...
        mean(Ysmoothpanza.*Yrate),std(Ysmoothpanza.*Yrate),kurtosis(Ysmoothpanza.*Yrate),skewness(Ysmoothpanza.*Yrate),...
        Nprogs,ModeX_Distance_cm,ModeY_Distance_cm,...
        meanIPI,stdIPI,skewIPI,kurIPI,...
        meanVEL,stdVEL,skewVEL,kurVEL,...
        meanDUR,stdDUR,skewDUR,kurDUR,...
        meanDIST,stdDIST,mediDIST,kurDIST,...
        mean(acel),std(acel),...
        mean(Dcuellocola,'omitnan'),std(Dcuellocola,'omitnan'),ThresVel);
    
    
    Rtable.Properties.VariableNames={'VideoName',...
        'MEAN_Xpath','STD_Xpath','KUR_Xpath','SKE_Xpath'...
        'MEAN_Ypath','STD_Ypath','KUR_Ypath','SKE_Ypath'...
        'N_Progression','XModesDistance_cm','YModesDistance_cm',...
        'meanIPI_sec','stdIPI_sec','skewIPI_sec','kurIPI_sec',...
        'meanVEL_cmps','stdVEL_cmps','skewVEL_cmps','kurVEL_cmps',...
        'meanDUR_s','stdDUR_s','skewDUR_s','kurDUR_s',...
        'meanPROGDIST_cm','stdPROGDIST_cm','medianPROGDIST_cm','kurPROGDIST_cm',...
        'meanAceleration','stdAceleration',...
        'meanLENGHT_cm','stdLENGHT_cm','Threshold_cm'};
    R=[R;Rtable];
    
    if doplot
        if i<numel(FileNameANS)
            pause
        end
    end
    %% Export .MAT File
    PartsSave=BodyPartsNames(5:end);
    Xparts=NaN*ones(size(Xmat,1),10*2+1);
    auxn=1;
    for n=1:numel(PartsSave)
        Xbuff=[Xmat(:,Xcols(4+n)),Xmat(:,Ycols(4+n))];
        indxok=find(Xmat(:,Ycols(4+n)+1)>Lthres);
        Xparts(indxok,auxn)=Xbuff(indxok,1);
        Xparts(indxok,auxn+1)=Xbuff(indxok,2);
        auxn=auxn+2;
    end
    Xparts(:,end)=MovementIndex;
    save([FN,'.mat'],'ProgTable','Xrate','Yrate','Lthres','Xparts',...
        'PartsSave','Xsmoothpanza','Ysmoothpanza');
end
fprintf('\n')
disp(R)

