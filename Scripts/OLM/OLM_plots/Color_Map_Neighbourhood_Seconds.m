%% Color_Map_Neighbourhood
function N = Color_Map_Neighbourhood_Seconds(Nsize,gridx,gridy,DataOLM,Field,ColorSets)
% Considering ONLY intereactions AND an Nsize CM neighbourhood to the objects
% %  Input
%   Nsize:  Size Object Neighbourhood //cm
%   dA: distantce to object A
%   dB: distantce to object B
%   interA: Frames of interactions to object A
%   interB: Frames of interactions to object B


% Ouput
%% Colormap Exploratory
% Nsize=6;  % cm

NeighA=find(DataOLM.dA<=Nsize);
NeighB=find(DataOLM.dB<=Nsize);

colmapFramesA=intersect(NeighA,DataOLM.interA);
colmapFramesB=intersect(NeighB,DataOLM.interB);
colmaframes=unique([colmapFramesB,colmapFramesA]);


stephstX=round(gridx/DataOLM.xratio);
stephstY=round(gridy/DataOLM.yratio);
xrange=sort([Field.leftLim(1),Field.rightLim(1)]);
yrange=sort([Field.topLim(2),Field.bottomLim(2)]);
ctrs={round(xrange(1)):stephstX:round(xrange(2)) round(yrange(1)):stephstY:round(yrange(2))};

N = hist3([DataOLM.Xnose(colmaframes),DataOLM.Ynose(colmaframes)],'Ctrs',ctrs); % FRAMES
Ncolors=max(N(:));
N=N/Field.fps; % FRAMES
figure
imagesc(N')


CM=cbrewer(ColorSets.KindMap,ColorSets.ColorMapName,Ncolors);
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


pgonApix=Field.pgonA;
pgonBpix=Field.pgonB;
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
colorbar
% view(0,-90);
% plot(AxB,pgonB)
ylabel('[px]')
xlabel('[px]')
title(sprintf('%2.1f CM neighborhood Grid Size: x=%2.1f cm, y=%2.1f cm Colorbar: [s]',Nsize,gridx,gridy))
figCM=gcf;
figCM.Name='Color Map of Objects neighborhood';
N=N';
