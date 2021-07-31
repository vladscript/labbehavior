% Open Field Porject Mean Cordinates
% 
function [XmeanSmooth,YmeanSmooth]=get_body_parts(t,X,fs)
%% Bodyparts: X|Y|likelihood
Snout=X(:,2:4);
EarA=X(:,5:7);
EarB=X(:,8:10);
Back=X(:,11:13);
TailBase=X(:,14:16);

Xmean=mean([Snout(:,1),EarA(:,1),EarB(:,1),Back(:,1),TailBase(:,1)],2);
XmeanSmooth=smooth(Xmean,fs);
Ymean=mean([Snout(:,2),EarA(:,2),EarB(:,2),Back(:,2),TailBase(:,2)],2);
YmeanSmooth=smooth(Ymean,fs);
%% PLOT COORDINATES
figure; 
axX=subplot(211); 
plot(t,Snout(:,1)); hold on;
plot(t,EarA(:,1)); 
plot(t,EarB(:,1)); 
plot(t,Back(:,1)); 
plot(t,TailBase(:,1)); 
plot(t,Xmean,'k','LineWidth',2);
plot(t,XmeanSmooth,'r','LineWidth',1); hold off;
ylabel('X-coordinate')
legend('Snout','EarA','EarA','Back','TailBase','Mean','MeanSmooth',...
    'Location','southwest')
axY=subplot(212); 
plot(t,Snout(:,2)); hold on;
plot(t,EarA(:,2)); 
plot(t,EarB(:,2)); 
plot(t,Back(:,2));
plot(t,Ymean,'k','LineWidth',2); 
plot(t,TailBase(:,2)); 
plot(t,YmeanSmooth,'r','LineWidth',1); hold off;
ylabel('Y-coordinate')
xlabel('seconds')
linkaxes([axX,axY],'x');