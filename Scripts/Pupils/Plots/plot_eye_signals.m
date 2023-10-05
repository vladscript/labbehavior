function plot_eye_signals(A,Blink,Peyearea,Index,fps,LHvec)
% EYE RELATED ############################################################
t_eye=linspace(0,numel(A)/fps/60,numel(A)); % MINUTES
t_screen=linspace(0,numel(Index)/fps/60,numel(Index)); % MINUTES

missPupilindx=find(LHvec<1);
missBlinks=find(isnan(Blink));
missPeye=find(isnan(Peyearea));

ax1=subplot(411);
plot(t_eye,A); hold on;
plot(t_eye(missPupilindx),A(missPupilindx),'xr','LineStyle','none'); hold off;
axis tight; grid on;
xlabel('min')
ylabel('Pupil Size [a.u.]')

ax2=subplot(412);
plot(t_eye,Blink); hold on;
plot(t_eye(missPupilindx),Blink(missPupilindx),'xr','LineStyle','none'); hold off;
axis tight; grid on;
xlabel('min')
ylabel('Vertical Lid Axis [a.u.]')

ax3=subplot(413);
plot(t_eye,Peyearea); hold on;
plot(t_eye(missPupilindx),Peyearea(missPupilindx),'xr','LineStyle','none'); hold off;
axis tight; grid on;
xlabel('min')
ylabel('Eye Area [a.u.]')


% SCREE NRELATED ##########################################################

ax4=subplot(414);
plot(t_screen,Index); hold on;
plot(t_screen(missPupilindx),Index(missPupilindx),'xr','LineStyle','none'); hold off;
axis tight; grid on;
xlabel('min')
ylabel('Avg Screen Gray [a.u.]')

linkaxes([ax1,ax2,ax3,ax4],'x')
end