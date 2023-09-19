%  PLot distance to objects
figure
% axa1=subplot(111);
plot(dA,'Color','blue','LineWidth',2); hold on
plot(dB,'Color','green','LineWidth',2)

plot(dlA,'Color','blue','LineWidth',1,'LineStyle',':'); 
plot(dlB,'Color','green','LineWidth',1,'LineStyle',':');

plot(drA,'Color','blue','LineWidth',1,'LineStyle','--'); 
plot(drB,'Color','green','LineWidth',1,'LineStyle','--');

plot([0,Npoints],[Dclose Dclose],'Color','red','Marker','*')
L = legend('Object A','Object B',...
    '','','','',...
    sprintf('%2.2f cm threshold',Dclose),'Orientation','horizontal','Location','northoutside');
L.AutoUpdate='off';
plot([0,Npoints],[0 0],'Color','red','Marker','*')
title('Mouse parts: - nose; : left -- right; black dots: discarded')
ylabel('distance [cm]');
xlabel('frames');
axis tight; grid on;
% Discarded overlapping frames
for n=1:size(OLa,1)
    plot(OLa(n,1):OLa(n,2),dA(OLa(n,1):OLa(n,2)),'.k')
end
for n=1:size(OLb,1)
    plot(OLb(n,1):OLb(n,2),dB(OLb(n,1):OLb(n,2)),'.k')
end