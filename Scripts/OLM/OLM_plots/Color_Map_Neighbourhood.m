%% Color_Map_Neighbourhood
% function N=Color_Map_Neighbourhood(Nsize,gridx,gridy,DataOLM,Field)
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

% pgonApix=pgonA;
% pgonBpix=pgonB;

NeighA=find(dA<=Nsize);
NeighB=find(dB<=Nsize);

colmapFramesA=intersect(NeighA,interA);
colmapFramesB=intersect(NeighB,interB);
colmaframes=unique([colmapFramesB,colmapFramesA]);
InterTotal=numel(interA)+numel(interB);
vidlength=Npoints;
Nframes=vidlength;
MaxLim=max([numel(interA),numel(interB)]/Nframes);

stephstX=round(gridx/xratio);
stephstY=round(gridy/yratio);
% xrange=sort([leftLim(1),rightLim(1)]);
% yrange=sort([topLim(2),bottomLim(2)]);
xrange=[min(min(Xnose(colmaframes)),min(pgonApix.Vertices(:,1)))-Nsize,max(max(Xnose(colmaframes)),max(pgonBpix.Vertices(:,1)))+Nsize];
yrange=[min(min(Ynose(colmaframes)),min(pgonBpix.Vertices(:,2)))-Nsize,max(max(Xnose(colmaframes)),max(pgonApix.Vertices(:,2)))+Nsize];

ctrs={round(xrange(1)):stephstX:round(xrange(2)) round(yrange(1)):stephstY:round(yrange(2))};

N = hist3([Xnose(colmaframes),Ynose(colmaframes)],'Ctrs',ctrs); % FRAMES
% Ncolors=max(N(:));
% Ncolors=sum(N(:));
% Ncolors=10;
N=100*N/Nframes;

% Ncolors=1/(min(N(N(:)>0))/max(N(N(:)>0)));
% InterTotal/Nframes
% 100*min(N(N(:)>0))/max(N(N(:)>0)); % minimum value diif from zero
% N=N/fps; % SECONDS
% N=100*N/InterTotal; % PERCENTAGE OF INTERACTION
figure
imagesc(N')
colormap jet;
CM=colormap;
CM(1,:)=[1,1,1];
colormap(CM)

% clim([min(N(N(:)>0)),MaxLim]);
clim([min(N(N(:)>0)),max(N(:))]);

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
colorbar;
% cb.Ticks=[(0:10:100)];

% view(0,-90);
% plot(AxB,pgonB)
ylabel('[px]')
xlabel('[px]')
title(sprintf('%2.1fcm Grid Size: x=%2.1f cm, y=%2.1f cm Colorbar: [%% Length]',Nsize,gridx,gridy))
figCM=gcf;
figCM.Name='Color Map of Objects neighborhood: percentage total frames';
N=N';