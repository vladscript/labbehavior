% function knowx(x)

w=100;
% get samples untill get 2 modes:
onemode=true;
A=1;
% while onemode
for i=1:30
    xw=x(1:A+w-1);
    [bnx,px]=ksdensity(xw);
    % findpeaks(bnx,px);
    A=A+w;
    plot(xw,'LineWidth',2)
    hold on
    plot(diff(xw),'LineWidth',2)
    plot(diff(diff(xw)),'LineWidth',2)
    hold off;
    pause;
end