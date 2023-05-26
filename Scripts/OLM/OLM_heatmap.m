%% OLM heatmap
% Grid size for heatmap
gridx=3;    % cm
gridy=3;    % cm
% Color map for heatmap (google CBREWER for more):
KindMap='seq';
ColorMapName='PuRd';

%% Colormap Exploratory

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

%% blur version (experimental)
% ww=4;
% kernel=ones(ww)/ww^2;
% b_N=imfilter(N,kernel);
% figure; imagesc(b_N')
% colormap(CM)
% hold on
% plot(pgonApix,'FaceColor','blue')
% plot(pgonBpix,'FaceColor','green')
% colorbar