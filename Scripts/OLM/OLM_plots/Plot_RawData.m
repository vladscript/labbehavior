%% plot area 
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
plot(ax1,pgonA,'FaceColor','blue','EdgeColor','blue')
plot(ax1,pgonB,'FaceColor','green','EdgeColor','green')
plot(ax1,Xnose,Ynose,'Color','black')
plot(ax1,Xlatright,Ylatright,'Color',[0.9 0.9 0.8]);
plot(ax1,Xlatleft,Ylatleft,'Color',[0.9 0.9 0.8]);
Leg1=legend(ax1,'','','','','','','','','A','B','Nose');
Leg1.AutoUpdate='off';
ax1.YLim=sort([topLim(2),bottomLim(2)]);
ax1.XLim=sort([leftLim(1),rightLim(1)]);