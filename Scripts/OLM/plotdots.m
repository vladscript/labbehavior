% function plotdots
figure;
hold on
plot(rightLim(1),rightLim(2),'+','MarkerSize',5,'Color','r','LineWidth',3)
plot(leftLim(1),leftLim(2),'+','MarkerSize',5,'Color','r','LineWidth',3)
plot(topLim(1),topLim(2),'+','MarkerSize',5,'Color','r','LineWidth',3)
plot(bottomLim(1),bottomLim(2),'+','MarkerSize',5,'Color','r','LineWidth',3)
grid on;
ax1=gca;
ax1.YDir="reverse";
plot(ax1,pgonA,'FaceColor','blue','EdgeColor','blue')
plot(ax1,pgonB,'FaceColor','green','EdgeColor','green')

plot(ax1,Xnose,Ynose,'Color',[0.8 0.8 0.8],'Marker','.');

L=legend(ax1,'','','','','A','B','Nose');
L.AutoUpdate='off';

ax1.YLim=sort([topLim(2),bottomLim(2)]);
ax1.XLim=sort([leftLim(1),rightLim(1)]);

% Plot explorations in black
% interA, dA
% interB, dB
% plot(ax1,Xnose(interA),Ynose(interA),'Marker','.');
plot(ax1,Xnose(interA),Ynose(interA),'o','MarkerEdgeColor',[0 0 0 ],'MarkerFaceColor','k');
plot(ax1,Xnose(interB),Ynose(interB),'o','MarkerEdgeColor',[0 0 0 ],'MarkerFaceColor','k');
title(f(1:indxmark-1))