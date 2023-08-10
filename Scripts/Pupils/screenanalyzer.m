clc;
clear;
%% SCREEN ONSET STIMULUS
load('SCREENS.mat');

%% Plot data
N=numel(X);
offset=1000;
for i=1:N
    x=zscore(X{i});
    % plot(x+offset,'b','LineWidth',2); hold on;
%     plot(x,'b','LineWidth',2); hold on;
%     plot(diff(x),'LineWidth',2)
%     plot(diff(diff(x)),'LineWidth',2)
%     hold off;
    XLimit=find(x>0,1);
    ax=gca;
    ax.XLim=[0,2*XLimit];
    xs=x(1:2*XLimit);
    % findpeaks(xs,'NPeaks',1,'SortStr','descend');
    [bnx,px]=ksdensity(xs);
    [Amp,Xbin]=findpeaks(bnx,px);
    modezero=min(abs(Xbin));
    [~,indxmodes]=setdiff(abs(Xbin),modezero);
    [~,bigmodeindx]=max(Amp(indxmodes));
    bigmode=Xbin(indxmodes(bigmodeindx));
    modex=abs(bigmode-modezero);

    [~,indxsort]=sort(Amp);
    bimodesdelta=diff(Xbin(indxsort));
    
    if modex>bimodesdelta(1)
        disp(modex);
    else
        disp(bimodesdelta(1));
    end

    subplot(121); plot(xs)
    subplot(122); plot(px,bnx); grid on;

    % offset=offset+max(x);
    if i<N
        pause;
    end
end
%%