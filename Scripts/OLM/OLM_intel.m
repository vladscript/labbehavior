%% To do
% 1) Make colormap only for neighbouhood of the objects

%% load data
% read csv from deeplabcut
clear;
[file,selpath]=uigetfile('*.csv')
X=readdlctableOLM([selpath,file]);

%% SETUP 

% Minimum distance to objects to consider an interaction:
Dclose=1;               % cm
% Likelihood Threshold for DLC detections
LikeliTh=0.9;
% Seconds to measure velocity
ws=1;           % s

% Acquisition rate
fps=30;                 % Hz: dafult frames per second (user input)
prompt={'fps:'};
name='Rate:';
numlines=[1 50];
defaultanswer={num2str(fps)};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
fps= str2double(answer{1});

% Size of the Field (FIXED)
VerticalLenght=30;      % cm
HorizontalLenght=30;    % cm

% % Grid size for heatmap
gridx=3;    % cm
gridy=3;    % cm
% Color map for heatmap (google CBREWER for more):
KindMap='seq';
ColorMapName='PuRd';

[TotalFrames,COLS]=size(X);
Nparts=round((COLS-1)/3);

OkIndx= find(X.nosel>=LikeliTh);
DiscarFrames=TotalFrames -   numel(OkIndx);
PrcDiscFrames=100*(DiscarFrames/TotalFrames);
fprintf('>%s  \n>Nose likelihood threshold: %3.3f \n> %i discarded frames: %3.1f %% of the video.',file,LikeliTh,DiscarFrames,PrcDiscFrames)
pause(0.5);

%% Nose Coordinates
fprintf('\n>Reading nose coordinates:')
tnose=X.FRAME(OkIndx);
Xnose=X.nosex(OkIndx);
Ynose=X.nosey(OkIndx);
fprintf(' ready.\n')

%% Field Area:
% LikeliTh=0.96
% Get the most likely coordinates

xtop=X.topx(X.topl>LikeliTh);
Xtop=mostlikelyvalue(xtop);
ytop=X.topy(X.topl>LikeliTh);
Ytop=mostlikelyvalue(ytop);

xrig=X.rightx(X.rightl>LikeliTh);
Xrig=mostlikelyvalue(xrig);
yrig=X.righty(X.rightl>LikeliTh);
Yrig=mostlikelyvalue(yrig);

xlef=X.leftx(X.leftl>LikeliTh);
Xlef=mostlikelyvalue(xlef);
ylef=X.lefty(X.leftl>LikeliTh);
Ylef=mostlikelyvalue(ylef);

xdow=X.downx(X.downl>LikeliTh);
Xdow=mostlikelyvalue(xdow);
ydow=X.downy(X.downl>LikeliTh);
Ydow=mostlikelyvalue(ydow);

% Horizontal
leftLim=[Xlef,Ylef];
rightLim=[Xrig,Yrig];
% Vertical
topLim=[Xtop,Ytop];
bottomLim=[Xdow,Ydow];

[pxr,binxr]=ksdensity(xrig,linspace(min(xrig),max(xrig),100),'Function','pdf');
[pxl,binxl]=ksdensity(xlef,linspace(min(xlef),max(xlef),100),'Function','pdf');
[pxt,binxt]=ksdensity(xtop,linspace(min(xtop),max(xtop),100),'Function','pdf');
[pxd,binxd]=ksdensity(xdow,linspace(min(xdow),max(xdow),100),'Function','pdf');

[pyr,binyr]=ksdensity(yrig,linspace(min(yrig),max(yrig),100),'Function','pdf');
[pyl,binyl]=ksdensity(ylef,linspace(min(ylef),max(ylef),100),'Function','pdf');
[pyt,binyt]=ksdensity(ytop,linspace(min(ytop),max(ytop),100),'Function','pdf');
[pyd,binyd]=ksdensity(ydow,linspace(min(ydow),max(ydow),100),'Function','pdf');


figure;
ax1=subplot(3,3,[2,3,5,6]);         % FIELD
plot(xtop,ytop,'Color',[0.9 0.5 0.5]) % top 
hold on
plot(xrig,yrig,'Color',[0.9 0.9 0.5]) % right
plot(xlef,ylef,'Color',[0.9 0.9 0.25]) % left
plot(xdow,ydow,'Color',[0.9 0.5 0.1]) % bottom

plot(rightLim(1),rightLim(2),'+','MarkerSize',10,'Color','k','LineWidth',3)
plot(leftLim(1),leftLim(2),'+','MarkerSize',10,'Color','k','LineWidth',3)
plot(topLim(1),topLim(2),'+','MarkerSize',10,'Color','k','LineWidth',3)
plot(bottomLim(1),bottomLim(2),'+','MarkerSize',10,'Color','k','LineWidth',3)
grid on;
A1=gca;
ax2=subplot(3,3,[8,9]);
plot(binxt,pxt,'Color',[0.9 0.5 0.5]); hold on
plot(binxr,pxr,'Color',[0.9 0.9 0.5]); 
plot(binxl,pxl,'Color',[0.9 0.9 0.25]);
plot(binxd,pxd,'Color',[0.9 0.5 0.1]); hold off
title('Detection Modes @x')
axis tight
grid on
A2=gca;
ax3=subplot(3,3,[1,4]);
plot(pyl,binyl,'Color',[0.9 0.9 0.25]); hold on
plot(pyt,binyt,'Color',[0.9 0.5 0.5]); 
plot(pyd,binyd,'Color',[0.9 0.5 0.1]);
plot(pyr,binyr,'Color',[0.9 0.9 0.5]); hold off
title('Detection Modes @y')
axis tight
grid on
ax3.YLim=ax1.YLim;
ax2.XLim=ax1.XLim;
A3=gca;
ax1.YDir='reverse';
ax3.YDir='reverse';
linkaxes([A1,A3],'y')
linkaxes([A1,A2],'x')
AreaDs=get_distance([bottomLim;topLim;leftLim;rightLim]);
VertDistance=AreaDs(2);
HorrtDistance=AreaDs(4);

fprintf('>>Area diameters: of:\n>Vertical: %3.2f px \n>Horizontal: %3.2f px\n',VertDistance,HorrtDistance);
% Constants to convert to cm ###########################################
yratio=VerticalLenght/VertDistance; % [cm/px]
xratio=HorizontalLenght/HorrtDistance; % [cm/px]

%% OBJECTS A & B

CenterArea=mean([leftLim;rightLim; topLim;bottomLim]);
Cx=CenterArea(1);

fprintf('\n Searching Object A [left]')
okL=find(sum([X.oa1l>LikeliTh, X.oa2l>LikeliTh,X.oa3l>LikeliTh,X.oa4l>LikeliTh],2)==4);
okCx=find(sum([X.oa1x<Cx, X.oa2x<Cx, X.oa3x<Cx, X.oa4x<Cx],2)==4);
okA=intersect(okL, okCx);
xoa1=X.oa1x(okA);
yoa1=X.oa1y(okA);
xoa2=X.oa2x(okA);
yoa2=X.oa2y(okA);
xoa3=X.oa3x(okA);
yoa3=X.oa3y(okA);
xoa4=X.oa4x(okA);
yoa4=X.oa4y(okA);
pgonA=rectangleobject(xoa1,yoa1,xoa2,yoa2,xoa3,yoa3,xoa4,yoa4);
fprintf('\n')
fprintf('\nSearching Object B [right]')
okL=find(sum([X.ob1l>LikeliTh, X.ob2l>LikeliTh,X.ob3l>LikeliTh,X.ob4l>LikeliTh],2)==4);
okCx=find(sum([X.ob1x>Cx, X.ob2x>Cx, X.ob3x>Cx, X.ob4x>Cx],2)==4);
okB=intersect(okL, okCx);
xob1=X.ob1x(okB);
yob1=X.ob1y(okB);
xob2=X.ob2x(okB);
yob2=X.ob2y(okB);
xob3=X.ob3x(okB);
yob3=X.ob3y(okB);
xob4=X.ob4x(okB);
yob4=X.ob4y(okB);
pgonB=rectangleobject(xob1,yob1,xob2,yob2,xob3,yob3,xob4,yob4);
fprintf('\n')

PA=polygonperimeter(pgonA,xratio,yratio);
PB=polygonperimeter(pgonB,xratio,yratio);

plot(ax1,pgonA,'FaceColor','blue','EdgeColor','blue')
plot(ax1,pgonB,'FaceColor','green','EdgeColor','green')
fprintf('>>Perimeters: of:\n>Object A: %3.2f px -> %3.2f cm \n>Object B: %3.2f px -> %3.2f cm \n',pgonA.perimeter,PA,pgonB.perimeter,PB);

%% Colormap Complete Exploratory

stephstX=round(gridx/xratio);
stephstY=round(gridy/yratio);
xrange=sort([leftLim(1),rightLim(1)]);
yrange=sort([topLim(2),bottomLim(2)]);
ctrs={round(xrange(1)):stephstX:round(xrange(2)) round(yrange(1)):stephstY:round(yrange(2))};
% x,y

N = hist3([Xnose,Ynose],'Ctrs',ctrs); % FRAMES
Ncolors=max(N(:));
N=N/fps; % FRAMES
figure
imagesc(N')


CM=cbrewer(KindMap,ColorMapName,Ncolors);
CM(1,:)=[1,1,1];
colormap(CM)
AxB=gca;
AxB.YLim=[1,size(N,2)];
AxB.XLim=[1,size(N,1)];
Nticks=5;
AxB.YTick=round(linspace(1,size(N,2),Nticks));
AxB.XTick=round(linspace(1,size(N,1),Nticks));

AxB.YTickLabel=ctrs{2}(AxB.YTick);
AxB.XTickLabel=ctrs{1}(AxB.XTick);

pgonApix=pgonA;
pgonBpix=pgonB;
DeltaX=ctrs{1}(end)-ctrs{1}(1);

DeltaY=ctrs{2}(end)-ctrs{2}(1);
% DeltaXpx=AxB.XLim(end)-AxB.XLim(1);
% DeltaYpx=AxB.YLim(end)-AxB.YLim(1);
DeltaXpx=size(N,1);
DeltaYpx=size(N,2);
% x->value
% (x/DeltaX)*DeltaXpx

pgonApix.Vertices(:,1) = DeltaXpx*((pgonA.Vertices(:,1)-ctrs{1}(1))/DeltaX); % x 
pgonApix.Vertices(:,2) = DeltaYpx*((pgonA.Vertices(:,2)-ctrs{2}(1))/DeltaY); % y

pgonBpix.Vertices(:,1) = DeltaXpx*((pgonB.Vertices(:,1)-ctrs{1}(1))/DeltaX); % x 
pgonBpix.Vertices(:,2) = DeltaYpx*((pgonB.Vertices(:,2)-ctrs{2}(1))/DeltaY); % y

hold on
plot(AxB,pgonApix,'FaceColor','blue','EdgeColor','blue')
plot(AxB,pgonBpix,'FaceColor','green','EdgeColor','green')

% ax1.YLim;=ax1.XLim;
% AxB.YTick=ax1.YTick;
% AxB.XTick=ax1.XTick;
colorbar
% view(0,-90);
% plot(AxB,pgonB)
ylabel('[px]')
xlabel('[px]')
title(sprintf('Complete CM Grid Size: x=%i cm, y=%i cm Colorbar: [s]',gridx,gridy))


%% NOSE TRACKING

plot(ax1,Xnose,Ynose,'Color',[0.42 0.35 0.2])
legend(ax1,'','','','','','','','','A','B','Nose')
% Other parts:
% Center
% plot(ax1,xcen,ycen)
% plot(ax1,xlatleft,ylatleft)
% plot(ax1,xlatright,ylatright)
ax1.YLim=sort([topLim(2),bottomLim(2)]);
ax1.XLim=sort([leftLim(1),rightLim(1)]);



%% Distance from Nose to Objects

% % AUTOMATIC THRESHOLD **********************
% % dCloseB=OLMinteraction(dB);
% % dCloseA=OLMinteraction(dA);
% % Dclose=mean([dCloseA,dCloseB]);
% % ******************************************

Npoints=numel(Xnose);

fprintf('\n>Measuring distances: .')

for i=1:Npoints
    x=Xnose(i)*xratio; y=Ynose(i)*yratio;
    [dA(i),x_polyA(i),y_polyA(i)] = p_poly_dist(x, y, pgonA.Vertices(:,1)*xratio, pgonA.Vertices(:,2)*yratio);
    [dB(i),x_polyB(i),y_polyB(i)] = p_poly_dist(x, y, pgonB.Vertices(:,1)*xratio, pgonB.Vertices(:,2)*yratio);
    %plot(x,y,'ko')
end
fprintf('.. done.')
fprintf('~Negative distance means overlapping -> discarding frames:\n');
OLa=overlapobjectframes(dA,Dclose);
OLb=overlapobjectframes(dB,Dclose);

NoverA=size(OLa,1);
NoverB=size(OLb,1);


% Discarded overlapping frames
disA=[]; tdisA=0;
if NoverA>0
    for n=1:NoverA
        disA=[disA,OLa(n,1):OLa(n,2)];
        tdisA=tdisA+OLa(n,3);
    end
end

disB=[]; tdisB=0;
if NoverB>0
    for n=1:NoverB
        disB=[disB,OLb(n,1):OLb(n,2)];
        tdisB=tdisB+OLb(n,3);
    end
end


% N Interactions
% Continuous intervasl under threshold:
IA=interactobjectframes(dA,Dclose);
IB=interactobjectframes(dB,Dclose);

NinterA=size(IA,1)-NoverA;
NinterB=size(IB,1)-NoverB;

% PLOT ******************
figure
% axa1=subplot(111);
plot(dA,'Color','blue','LineWidth',2); hold on
plot(dB,'Color','green','LineWidth',2)
plot([0,Npoints],[Dclose Dclose],'Color','red','Marker','*')
L = legend('Object A','Object B',sprintf('%2.2f cm threshold',Dclose),'Orientation','horizontal','Location','northoutside');
L.AutoUpdate='off';
plot([0,Npoints],[0 0],'Color','red','Marker','*')
title(' Distance Nose to:')
ylabel('cm');
xlabel('frames');
axis tight; grid on;
% Discarded overlapping frames
for n=1:NoverA
    plot(OLa(n,1):OLa(n,2),dA(OLa(n,1):OLa(n,2)),'.k')
end
for n=1:NoverB
    plot(OLb(n,1):OLb(n,2),dB(OLb(n,1):OLb(n,2)),'.k')
end
% Interactions


drawnow;
%  CALCULATIONS **************************
interA=setdiff(find(dA<Dclose),disA);
interB=setdiff(find(dB<Dclose),disB);
TotalInter=numel(interA)+numel(interB);

prefA=numel(interA)/(TotalInter)*100;
prefB=numel(interB)/(TotalInter)*100;
fprintf('>Total Interaction (<%2.1f cm)with A and B objects: %3.2f seconds',Dclose,TotalInter/fps);
fprintf('\n>A object: %3.2f %%',prefA);
fprintf('\n>B object: %3.2f %%\n',prefB);
fprintf('\n>Minimum interaction-distance to Object A: %3.2f cm\n',min(dA(interA)));
fprintf('>Minimum interaction-distance to Object B: %3.2f cm\n',min(dB(interB)));

%% Motor stuff

% velthres=20;    % cm/s

% Total Distance %statistics: mean, 
t=X.FRAME(OkIndx)*(1/fps); % TIME IN SECONDS
[Xsmoothnose,Ysmoothnose]=smoothpath(t,Xnose,Ynose);
d=get_distance([Xsmoothnose*xratio,Ysmoothnose*yratio]);
TotalDistance=sum(d(2:end)); % [cm]

% % velocity statistics: mean
% Velocity=diff(d)/(1/fps); % [cm/s]

% Rate of movement
drate=get_velocity_interval(d,ws,fps);
velthres=median(drate); % cm/s
tvel=[0:numel(drate)-1]*ws; % [s]

[AMP,TIMES]=boufinder(drate,tvel,velthres);

figure
bar(tvel,drate)
ylabel('cm/s');
xlabel('s')
hold on
for n=1:numel(AMP)
    plot(TIMES(n),AMP(n),'r*');
end
plot([0,TIMES(end)],[velthres,velthres],'--r')
% bouts


% figure
% ax2=subplot(211);
% plot(diff(d))

% linkaxes([axa1,ax2],'x')
% ws=1; % seconds
% drate=get_velocity_interval(d,ws,fps);

%% Generate OUTPUT

fprintf('\n>Saving table: ')
FileOutput=getDir2Save();
indxmark=strfind(file,'DLC');
if isempty(indxmark)
    indxmark=strfind(file,'resnet');
end
VidID{1}=file(1:indxmark-1);
Name=[file(1:indxmark-1),'_OLMintel.csv'];

fprintf('%s',Name);

Rtable=table(VidID,Dclose, ...
    TotalInter/fps,prefA,prefB, ...
    NinterA,NinterB,numel(disA)/fps,numel(disB)/fps,NoverA,NoverB,...
    TotalDistance,ws,...
    median(drate),numel(TIMES),median(AMP),TotalFrames/fps,...
    yratio,xratio,PA,PB,PrcDiscFrames);

Rtable.Properties.VariableNames={'Video_ID','Threshold_cm',...
        'TotaTimeInter_s','A_percent','B_percent',...
        'N_inter_A','N_inter_B','OverlapA_s','OverlapB_s','N_over_A','N_over_B',...
        'TotalDistance_cm','WindowTime_s','MedianVelWin_cm_s','N_Bouts','MedianVelBout_cm_s','VideoLength_s',...
        'yratio_cm_px','xratio_cmp_px','A_perimeter_cm','B_perimeter_cm','Frames_Discardesd_percent'};

fprintf('\n@ %s\n',FileOutput);
writetable(Rtable,[FileOutput,Name])
disp(Rtable);
%% ColorMap in the Object's Neighbourhood
DataOLM.dA=dA;
DataOLM.dB=dB;
DataOLM.interA=interA;
DataOLM.interB=interB;
DataOLM.Xnose=Xnose;
DataOLM.Ynose=Ynose;
DataOLM.xratio=xratio;
DataOLM.yratio=yratio;

Field.leftLim=leftLim;
Field.rightLim=rightLim;
Field.topLim=topLim;
Field.bottomLim=bottomLim;
Field.pgonA=pgonA;
Field.pgonB=pgonB;
Field.fps=fps;

ColorSets.KindMap=KindMap;
ColorSets.ColorMapName=ColorMapName;

Color_Map_Neighbourhood(Nsize,gridx,gridy,DataOLM,Field,ColorSets);

ssfunc='>>Color_Map_Neighbourhood(Nsize,gridx,gridy,DataOLM,Field,ColorSets);';
fprintf('For different color maps, run: \n %s\n',ssfunc)
fprintf('Ony change: \n\nNsise: Neighborhood size in cm\n')
fprintf('\ngridx: size of grid in x-axis in cm\n')
fprintf('\ngridy: size of grid in y-axis in cm\n')
