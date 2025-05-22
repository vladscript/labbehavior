% Histogram_LickRate PeriStim
LRfig=figure;
Rgo=R(ors==stimis(1),:);
Rnogo=R(ors==stimis(2),:);
subplot(131)
plot(T-PreStim/fs,R,'Color',[0.9 0.9 0.9]);
hold on;
plot(T-PreStim/fs,mean(R),'LineWidth',2); 
rectangle('Position',[PreStim/fs 0 StimLength/fs max(R(:))],'EdgeColor','k');
grid on;
ti=title([[MouseID{i},'-',Sesion{i}]]);
ti.Interpreter='none';
ylabel('Lick rate (Hz)')
subplot(132)
plot(T-PreStim/fs,R(ors==stimis(1),:),'Color',[0.95 0.95 0.95]);
hold on;
plot(T-PreStim/fs,mean(R(ors==stimis(1),:)),'LineWidth',2); 
rectangle('Position',[PreStim/fs 0 StimLength/fs max(Rgo(:))],'EdgeColor','k');
grid on;
title(sprintf('Stim: %i °',stimis(1)))
subplot(133)
plot(T-PreStim/fs,R(ors==stimis(2),:),'Color',[0.95 0.95 0.95]);
hold on;
plot(T-PreStim/fs,mean(R(ors==stimis(2),:)),'LineWidth',2); 
rectangle('Position',[PreStim/fs 0 StimLength/fs max(Rnogo(:))],'EdgeColor','k');
grid on;
title(sprintf('Stim: %i °',stimis(2)))
LRfig.Position=[889.8000 416.2000 560.0000 199.2000];