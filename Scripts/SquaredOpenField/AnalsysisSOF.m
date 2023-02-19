%% Import Coordinates XY
fprintf('\n>Load Data:')
% % Dimensions of the BOX
% % Width
% % Height
fs=30; % seems so
[FileName,FileUbication]=uigetfile('*.csv','Select a posture CSV file from DLC');
fprintf('Reading poses:')
X=GetDLCPostures([FileUbication,FileName]);
fprintf('done.\n')
fprintf('>File: %s\n Frames: %i\n>Length minutes:%3.1f\n',FileName,X.Frames(end),X.Frames(end)/fs/60)
%% Plot & Explore  Likelihoods
Lthres=0.8;                         % Likelihood Threshold
BodyPars=X.Properties.VariableNames(2:end); % each one with X,Y,L
% X-coordinates:    1:3:end
% Y-coordinates:    2:3:end
% Likelihoods:      3:3:end
N=round(numel(BodyPars)/3);
L=table2array(X(:,3:3:end)); % all likelihoods
% Plot
figure;
boxplot(L);
Ax=gca;
Ax.XTickLabel=BodyPars(1:3:end);
Ax.XTickLabelRotation=90;
ylabel('Likelihood')
title('Bodyparts quality detection')
hold on;
plot([0,N+1],[Lthres,Lthres],'-.k')
%% Plot & Explore  Likelihoods
NarizXY=getlikelycoords(X.narizX,X.narizY,X.narizL,Lthres);
BaseCXY=getlikelycoords(X.base_colaX,X.base_colaY,X.base_colaL,Lthres);
PanzaXY=getlikelycoords(X.panzaX,X.panzaY,X.panzaL,Lthres);
% Limits of the Field
PSDXY=getlikelycoords(X.PSDx,X.PSDy,X.PSDl,Lthres);
PSIXY=getlikelycoords(X.PSIx,X.PSIy,X.PSIl,Lthres);
PIDXY=getlikelycoords(X.PIDx,X.PIDy,X.PIDl,Lthres);
PIIXY=getlikelycoords(X.PIIx,X.PIIy,X.PIIl,Lthres);


% Averages
Xmean=mean([NarizXY(:,1),BaseCXY(:,1),PanzaXY(:,1)],2,'omitnan');
Ymean=mean([NarizXY(:,2),BaseCXY(:,2),PanzaXY(:,2)],2,'omitnan');

XCmeans=mean([PSDXY(:,1),PSIXY(:,1),PIDXY(:,1),PIIXY(:,1)],1,'omitnan');
YCmeans=mean([PSDXY(:,2),PSIXY(:,2),PIDXY(:,2),PIIXY(:,2)],1,'omitnan');

% Smooth
Xsmooth=smooth(Xmean);
Ysmooth=smooth(Ymean);
XCenter=mean(smooth(XCmean));
YCenter=mean(smooth(YCmean));
%% Plot Coordinate
figure;
subplot(211)
ax1=plot(X.Frames,NarizXY(:,1),X.Frames,BaseCXY(:,1),X.Frames,PanzaXY(:,1),...
    X.Frames,Xmean,X.Frames,Xsmooth);
grid on;
axis([X.Frames(1),X.Frames(end),min(XCmeans),max(XCmeans)])
subplot(212)
ax2=plot(X.Frames,NarizXY(:,2),X.Frames,BaseCXY(:,2),X.Frames,PanzaXY(:,2),...
    X.Frames,Ymean,X.Frames,Ysmooth);
axis([X.Frames(1),X.Frames(end),min(YCmeans),max(YCmeans)])
grid on;
legend('Nariz','BaseCola','Panza','Avg','Smooth')
% Trajecotry
figure; plot3(Xsmooth,Ysmooth,X.Frames); 
hold on
plot3(PSDXY(:,1),PSDXY(:,2),X.Frames)
plot3(PSIXY(:,1),PSIXY(:,2),X.Frames)
plot3(PIDXY(:,1),PIDXY(:,2),X.Frames)
plot3(PIIXY(:,1),PIIXY(:,2),X.Frames)
plot(XCenter,YCenter,'+k','MarkerSize',20)

% velocity and stuff
d=get_distance([Xsmooth,Ysmooth]);
ws=1; % seconds
drate=get_velocity_interval(d,ws,fs);
ksdensity(drate,linspace(min(drate),max(drate),100),'function','cdf')

AxialA=twopartsdistance(NarizXY,PanzaXY);
AxialB=twopartsdistance(PanzaXY,BaseCXY);
VectorA=NarizXY-PanzaXY;
VectorB=BaseCXY-PanzaXY;
DOTAB=dot(VectorA,VectorB,2);
MagA=sqrt(sum(VectorA.^2,2));
MagB=sqrt(sum(VectorB.^2,2));
AngleAxis=acos(DOTAB./(MagA.*MagB));

AxisLength=AxialA+AxialB;
figure
subplot(211)
Ax1=plot(X.Frames/fs,AxisLength); hold on
plot(X.Frames/fs,AxialA);
plot(X.Frames/fs,AxialB);
title('Velocity')
subplot(212)
Ax2=plot(1:numel(drate),drate);
title('Velocity')
