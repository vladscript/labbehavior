%% Plots OPENFIELD PATH, INSTANT DISTANCE, VELOCUTY AND VELOCITY HISTOGRAM
MEASURES;
WindowTime=60; % seconds
% Retrieve Data
W=Image_WH(1); % Width
H=Image_WH(2); % Width
HortScale=Scale_WH(1)/DiametersPix(1);
VertScale=Scale_WH(2)/DiametersPix(2);
d_smooth=get_distance([XYcm(:,1),XYcm(:,2)]);
d_rate=get_velocity_interval(d_smooth,WindowTime,fps);
velocity=diff(d_smooth)*fps;
% Field Center
Cx=Field_Centroid(1)*HortScale; Cy=Field_Centroid(2)*VertScale; % cm

%       Open Field
figure; % Show Path and Circular Surface (center,radiosX,radiusY)
avgspeed=sum(d_smooth)/(numel(d_smooth)/fps/60);
plot(Cx,Cy,'Marker','+','MarkerSize',15); hold on
rectangle('Position',[Cx-SmallDiameter/2,Cy-SmallDiameter/2,SmallDiameter,SmallDiameter],'Curvature',[1,1])
% rectangle('Position',[Cx-Dx/2,Cy-Dy/2,Dx,Dy],'Curvature',[1,1])
plot(XYcm(:,1),XYcm(:,2)); grid on;
axis([0,HortScale*W,0,VertScale*H]);
daspect([1,1,1]);
title(gca,sprintf('Open Field of %s Total:%3.2f[cm] @ %3.2f[cm/min]',NameVideo,...
    sum(d_smooth),avgspeed),'Interpreter','none')
xlabel('[cm]'); ylabel('[cm]');
%       Distance,Velocity & Histogram Velocity
figure    
subplot(211)
[hAx,~,~]=plotyy(linspace(0,numel(d_smooth)/fps,numel(d_smooth)),d_smooth,...
    linspace(0,numel(velocity)/fps,numel(velocity)),velocity);
title(gca,sprintf('Instant Values of %s',...
    NameVideo),'Interpreter','none')
xlabel('Time (sec)')
ylabel(hAx(1),'Distance [cm]') % left y-axis
ylabel(hAx(2),'Velocity [cm/s]') % right y-axis
% Plot Distance per Time
subplot(212)
barax=bar(d_rate);
barax.XData=barax.XData*WindowTime;
barax.BarWidth=1;
title(gca,sprintf('Velocity Histogram of %s',NameVideo),'Interpreter','none')
ylabel(sprintf('[cm/s]'));
xlabel('Time (sec)')
axis tight
