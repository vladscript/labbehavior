function Corners=plot_centers(EYE_AVGPOSITION,EYE_STDPOSITION,Centers_Pupil,EYE_center,fps)


% Plot Eye Area
%   lid_top     corner_left     lid_bot    corner_right
LimitsX=[EYE_AVGPOSITION(2)-EYE_STDPOSITION(2),EYE_AVGPOSITION(4)+EYE_STDPOSITION(4)];
LimitsY=[EYE_AVGPOSITION(1+4)-EYE_STDPOSITION(1+4),EYE_AVGPOSITION(3+4)+EYE_STDPOSITION(3+4)];

Corners=[EYE_AVGPOSITION(2),EYE_AVGPOSITION(2+4);...
    EYE_AVGPOSITION(4),EYE_AVGPOSITION(4+4)];

Lids=[EYE_AVGPOSITION(3),EYE_AVGPOSITION(3+4);...
    EYE_AVGPOSITION(1),EYE_AVGPOSITION(1+4)];
figure;
subplot(2,2,[1,3])
plot(EYE_center(:,1),EYE_center(:,2),'LineStyle','none','Marker','.','Color',[0.75 0.75 0.75]);
hold on
plot(Centers_Pupil(:,1),Centers_Pupil(:,2),'LineStyle','none','Marker','.','Color','black');
Li=line([Corners(1,1),Corners(2,1)],[Corners(1,2),Corners(2,2)]);
Li.Color='m';
L=legend('Eye Center','Pupil Center','Corner Axis');
L.AutoUpdate="off";
L.Location='southeast';
plot(Corners(1,1),Corners(1,2),'xr','MarkerSize',10,'LineWidth',2);
plot(Corners(2,1),Corners(2,2),'xr','MarkerSize',10,'LineWidth',2);

plot(Lids(1,1),Lids(1,2),'xr','MarkerSize',10,'LineWidth',2);
plot(Lids(2,1),Lids(2,2),'xr','MarkerSize',10,'LineWidth',2);

AxXY=gca;
AxXY.XLim=LimitsX;
AxXY.YLim=LimitsY.*[0.5 1.5];
hold on;

xlabel('px')
ylabel('px')
grid on;

AxXY.YDir='reverse';
% figure
a1=subplot(2,2,2);
T=numel(Centers_Pupil(:,1));
PltX=plot((1:T)/fps,Centers_Pupil(:,1),(1:T)/fps,EYE_center(:,1));
PltX(1).Color=[0,0,0];
PltX(2).Color=[0.75 0.75 0.75];
grid on;
ylabel('x-axis[px]')
a2=subplot(2,2,4);
T=numel(Centers_Pupil(:,2));
PltY=plot((1:T)/fps,Centers_Pupil(:,2),(1:T)/fps,EYE_center(:,2));
PltY(1).Color=[0,0,0];
PltY(2).Color=[0.75 0.75 0.75];
grid on;
ylabel('y-axis[px]')
xlabel('s')
linkaxes([a1,a2],'x');
[R1,P1]=corr(Centers_Pupil(:,1),EYE_center(:,1));
[R2,P2]=corr(Centers_Pupil(:,2),EYE_center(:,2));
fprintf('\n>Correlation between x-axis of pupil and eye center: R=%2.2f, P=%2.2f',R1,P1);
fprintf('\n>Correlation between y-axis of pupil and eye center: R=%2.2f, P=%2.2f\n',R2,P2);
title(a1,['Corr: ',num2str(R1)])
title(a2,['Corr: ',num2str(R2)])