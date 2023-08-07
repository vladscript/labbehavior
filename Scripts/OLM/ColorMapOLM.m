% % Grid size for heatmap
% gridx     size of the grid in x-axis in cm
% gridy=3;  size of the grid in y-axis in cm
% KindMap;
% ColorMapName
% TaskData: Strucutre, fields:
% Xnose,Ynose,xratio,yratio,leftLim,rightLim,topLim,bottomLim,pgonA,pgonB
% 
% Example:
% >ColorMapOLM(1,1,'seq','Greens',TaskData)
% %% 1cm grid size in x and y using a squential of greens
function ColorMapOLM(gridx,gridy,KindMap,ColorMapName,TaskData)
% Get Data

Xnose=TaskData.Xnose;
Ynose=TaskData.Ynose;
xratio=TaskData.xratio;
yratio=TaskData.yratio;
leftLim=TaskData.leftLim;
rightLim=TaskData.rightLim;
topLim=TaskData.topLim;
bottomLim=TaskData.bottomLim;
pgonA=TaskData.pgonA;
pgonB=TaskData.pgonB;
fps=TaskData.fps;

% Colormap Complete Exploratory
stephstX=round(gridx/xratio);
stephstY=round(gridy/yratio);
xrange=sort([leftLim(1),rightLim(1)]);
yrange=sort([topLim(2),bottomLim(2)]);
ctrs={round(xrange(1)):stephstX:round(xrange(2)) round(yrange(1)):stephstY:round(yrange(2))};
% x,y

N = hist3([Xnose,Ynose],'Ctrs',ctrs); % FRAMES
Ncolors=max(N(:));
N=N/fps; % SECONDS
figure
imagesc(N')

CM=cbrewer(KindMap,ColorMapName,Ncolors);
% CM(1,:)=[1,1,1];
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

fprintf('\n[]Type: \n>HELP_CBREWER \n[]to see color bars menu\n');