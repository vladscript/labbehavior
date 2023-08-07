%% Color_Map_Neighbourhood
function Color_Map_Neighbourhood(Nsize,gridx,gridy,DataOLM,Field,ColorSets)
% Considering ONLY intereactions AND an Nsize CM neighbourhood to the objects
% %  Input
%   Nsize:  Size Object Neighbourhood //cm
%   dA: distantce to object A
%   dB: distantce to object B
%   interA: Frames of interactions to object A
%   interB: Frames of interactions to object B
% Ouput: clomaro
% 
% Example:
% >ColorSets.KindMap='qua';
% >ColorSets.ColorMapName='Set2';
% >Color_Map_Neighbourhood(3,1,1,DataOLM,Field,ColorSets)
%  %% this makes a color amp around 3 cm around the objects using a grid of
%  1x1 cm and using the set2 of qualitative colormap cbrewer
%% Colormap Exploratory
% Nsize=6;  % cm

pgonApix=Field.pgonA;
pgonBpix=Field.pgonB;

NeighA=find(DataOLM.dA<=Nsize);
NeighB=find(DataOLM.dB<=Nsize);

colmapFramesA=intersect(NeighA,DataOLM.interA);
colmapFramesB=intersect(NeighB,DataOLM.interB);
colmaframes=unique([colmapFramesB,colmapFramesA]);
InterTotal=numel(DataOLM.interA)+numel(DataOLM.interB);

stephstX=round(gridx/DataOLM.xratio);
stephstY=round(gridy/DataOLM.yratio);
% xrange=sort([Field.leftLim(1),Field.rightLim(1)]);
% yrange=sort([Field.topLim(2),Field.bottomLim(2)]);
xrange=[min(min(DataOLM.Xnose(colmaframes)),min(pgonApix.Vertices(:,1)))-Nsize,max(max(DataOLM.Xnose(colmaframes)),max(pgonBpix.Vertices(:,1)))+Nsize];
yrange=[min(min(DataOLM.Ynose(colmaframes)),min(pgonBpix.Vertices(:,2)))-Nsize,max(max(DataOLM.Xnose(colmaframes)),max(pgonApix.Vertices(:,2)))+Nsize];

ctrs={round(xrange(1)):stephstX:round(xrange(2)) round(yrange(1)):stephstY:round(yrange(2))};

N = hist3([DataOLM.Xnose(colmaframes),DataOLM.Ynose(colmaframes)],'Ctrs',ctrs); % FRAMES
% Ncolors=max(N(:));
% Ncolors=sum(N(:));
% Ncolors=10;
Ncolors=1/(min(N(N(:)>0))/max(N(N(:)>0)));

% 100*min(N(N(:)>0))/max(N(N(:)>0)); % minimum value diif from zero
% N=N/Field.fps; % SECONDS
N=100*N/InterTotal; % PERCENTAGE OF INTERACTION
figure
imagesc(N')


CM=cbrewer(ColorSets.KindMap,ColorSets.ColorMapName,Ncolors);
% CM(1,:)=[1,1,1];
colormap(CM)
clim([0 100])
% clim([100*min(N(N(:)>0))/max(N(N(:)>0)),100]);
% clim([min(N(N(:)>0)),max([])]);
AxB=gca;
AxB.YLim=[0.5,size(N,2)+.5];
AxB.XLim=[0.5,size(N,1)+.5];
Nticks=5;
AxB.YTick=round(linspace(1,size(N,2),Nticks));
AxB.XTick=round(linspace(1,size(N,1),Nticks));

AxB.YTickLabel=ctrs{2}(AxB.YTick);
AxB.XTickLabel=ctrs{1}(AxB.XTick);



DeltaX=ctrs{1}(end)-ctrs{1}(1);
DeltaY=ctrs{2}(end)-ctrs{2}(1);
% DeltaXpx=AxB.XLim(end)-AxB.XLim(1);
% DeltaYpx=AxB.YLim(end)-AxB.YLim(1);
DeltaXpx=size(N,1);
DeltaYpx=size(N,2);
% x->value
% (x/DeltaX)*DeltaXpx

pgonApix.Vertices(:,1) = DeltaXpx*((Field.pgonA.Vertices(:,1)-ctrs{1}(1))/DeltaX); % x 
pgonApix.Vertices(:,2) = DeltaYpx*((Field.pgonA.Vertices(:,2)-ctrs{2}(1))/DeltaY); % y

pgonBpix.Vertices(:,1) = DeltaXpx*((Field.pgonB.Vertices(:,1)-ctrs{1}(1))/DeltaX); % x 
pgonBpix.Vertices(:,2) = DeltaYpx*((Field.pgonB.Vertices(:,2)-ctrs{2}(1))/DeltaY); % y

hold on
plot(AxB,pgonApix,'FaceColor','blue','EdgeColor','blue')
plot(AxB,pgonBpix,'FaceColor','green','EdgeColor','green')

% ax1.YLim;=ax1.XLim;
% AxB.YTick=ax1.YTick;
% AxB.XTick=ax1.XTick;
cb=colorbar;
cb.Ticks=[(0:10:100)];

% view(0,-90);
% plot(AxB,pgonB)
ylabel('[px]')
xlabel('[px]')
title(sprintf('%2.1fcm Grid Size: x=%2.1f cm, y=%2.1f cm Colorbar: [interaction %%]',Nsize,gridx,gridy))
figCM=gcf;
figCM.Name='Color Map of Objects neighborhood: percentage of total interaction';