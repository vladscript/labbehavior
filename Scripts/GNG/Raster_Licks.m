%% Raster_plot
%% Go Raster plot
% % function Raster_Licks(data_go,time_before,time_after,...
% %     Raster_title,lick_bin,binsGo,data_nogo,binsNoGo,forfigs)
function Raster_Licks(usedA,time_before,time_after,...
    Raster_title,lick_bin,binsGo,usedB,binsNoGo)
% function Raster_Licks(data_go,time_before,time_after,...
%     Raster_title,lick_bin,binsGo,log2Stim,data_nogo,binsNoGo,endsGo,endsNoGo,numTrG,numTrNG,forfigs)
%% Plots rasterplor for two types of stimuli (Go and No-go)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%               Gamaliel Isaias Mendoza Cuevas              %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs:
%binary_data        - M by N binary matrix, M=trials, N= duration of trials
%                     (in ms) for first category of stimuli
%stimColor          - String for RGBCMYK ('r') or [x y z] from 0-1 for RGB
%time_before        - Is the time before stimulation occurs
%time_after         - Time after stimulus beginning (Stimulus + ITI)
%Raster_title       - String for rasterplot's name (e.g. 'Go trials')
%lick_bin          - Size of bin for which lick begining was added up
%bins4Stim          - Summary vector for licks during first stimulus category, length N/lick_bin
%also2Stim          - Boolean (0,1) for deciding whether to include second stimulus
%                     category
%nogo_binary        - M by N binary matrix, M=trials, N= duration of trials
%                     (in ms) for SECOND category of stimuli
%stim_2_binary      - Summary vector for licks during second stimulus category, length N/lick_bin
%
%
%##########################################################################
%If thre is no 2nd category, the function is called:
% Raster_Licks(binary_data,stimColor,time_before,time_after,...
%             Raster_title,lick_bin,bins4Stim,0,0,0)
%##########################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure('units','normalized','outerposition',[0 0 1 1]);
% figure('units','normalized','outerposition',[0 0 .5 1]);
%% GO
try
    rstr=figure('units','centimeters');
%     rstr= figure('units','centimeters','visible','off');
end
set(0,'DefaultAxesFontName','Arial')
FoSi=8.1;
subplot(311)
hold on;
stimD=2000;
axRas=time_before*-1:time_after-1;
Fs=1e3;
% go_f=fill([0,stimD,stimD,0],[0,0,size(data_go,1),size(data_go,1)]...
%     ,'g','FaceAlpha',0.5,'EdgeColor','none'); %Draws Stimulus
vt=0+1/1e3:1/1e3:2;
FP=10;
sinF=1/FP;
sinGr=sin(vt/sinF);
% figure, plot(sinGr)
% GDG=ones(size(data_go,1),stimD).*sinGr;
% GDG=ones(size(data_go,1),stimD);
% da=da*.125;
% go_f=imagesc(GDG);
alpGr=.4;
% go_f.AlphaData=alpGr;
% % colormap('gray')
% % colormap('winter')
% colormap('hsv')
GOstimrec=fill([000,000,2e3,2e3],[0,size(usedA,1)-.2,size(usedA,1)-.2,0],'k');             %Plots reward line
Grn=[0 256 0]/256;
GOstimrec.FaceColor='g';
GOstimrec.FaceAlpha=alpGr;
% rewSig.EdgeColor='m';
% magIllus=[0 0 256]/256;

GOstimrec.EdgeColor=Grn;
mkRT=1;
mkLck=mkRT/4;
clrLick=[.4 .4 .4];
clrRT=[0 0 0];
PuBlu=[88 124 190]/256;
PuOr=[221 96 0]/256;
% go_f.CData=da;
%%
% time_after=time_after;
% usedA=flipud(data_go);
% usedB=flipud(data_nogo);
row=1;
for r = 1:size(usedA,1) % Places ones instead of zeros according to go_table (i,j)
    trial=find(diff(usedA(r,:))>0);
    %     trial=find(data_go(r,:)>0);
    %     EndTr=plot(endsGo(r),r,'b*','MarkerFaceColor','b','MarkerSize',4);
    if trial
        errete=find(trial>=time_before & trial<time_before+time_after);
        subplot(311)
        h=plot(axRas(trial),r,'o','MarkerEdgeColor',clrLick,'MarkerFaceColor',clrLick,'MarkerSize',mkLck);
        try
            subplot(311)
            fstlk=plot(axRas(trial(errete(1))),r,'.','MarkerEdgeColor',clrRT,'MarkerFaceColor',clrRT,'MarkerSize',mkRT);
            %             text(axRas(trial(errete(1))),r,num2str(numTrG(r)),'Color',[.6 .6 .6]);
            %             EndTr=plot(endsGo(r),r,'b*','MarkerFaceColor','b','MarkerSize',4);
        end
    else
        r=r+1;
    end
end
% xlim([-time_before time_after-time_before])
ylim([0 size(usedA,1)])

% axis tight

% x2=[3000 3000];                     %Draws Reward
% y2=[0 size(data_go,1)];
% rewSig=plot(x2,y2,'color','m');             %Plots reward line
% x2=[2000 3000];                     %Draws Reward
% y2=[0 size(data_go,1)];
rewSig=fill([2000,2000,3e3,3e3],[0,size(usedA,1)-.2,size(usedA,1)-.2,0],'k');             %Plots reward line
rewSig.FaceColor='none';
% rewSig.EdgeColor='m';
magIllus=[165 82 153]/256;
rewSig.EdgeColor=magIllus;
rewSig.LineStyle='--';
axis tight
% title('Go')
% xlabel('Time (sec)'); ylabel(Raster_title)
% legend([fstlk,h(1),rewSig],...
%     'Reaction Time','Lick','Reward/Punishment','Location','best','Orientation','horizontal');%,...
% %         'numcolumns',2)
% legend('boxoff')
xlim([-time_before time_after-time_before])
set(gca,'XTick',[])
    set(gca,'XTicklabel',[])
% set(gca,'XTick',-time_before:Fs:time_after)
% set(gca,'XTickLabel',{-time_before/Fs:time_after/Fs})
set(gca,'YTick',0:size(usedA,1)/2:size(usedA,1))
set(gca,'YTickLabel',{0:size(usedA,1)/2:size(usedA,1)})
set(gca,'FontName','Arial')
set(gca,'FontSize',FoSi)
%% If No-Go
FP=400;
cosF=1/FP;
cosGr=sin(vt/cosF);
% matSin=ones(stimD).*cosGr;
matSin=zeros(stimD);
if ~isempty(usedB)
    subplot(312), hold on
    %     GDNG=matSin';
    %     GDNG=GDNG(1:size(data_nogo,1),:);
    %     nogo_f=imagesc(GDNG);
    %
    %     nogo_f.AlphaData=alpGr;
    % %     colormap('gray')
    %     colormap('winter')
    NGOstimrec=fill([000,000,2e3,2e3],[0,size(usedB,1)-.2,size(usedB,1)-.2,0],'k');             %Plots reward line
    NGOstimrec.FaceColor='b';
    NGOstimrec.FaceAlpha=alpGr;
    % rewSig.EdgeColor='m';
    Bl=[0 0 256]/256;
    NGOstimrec.EdgeColor=Bl;
    %     nogo_f=fill([0,stimD,stimD,0],[0,0,size(data_nogo,1),size(data_nogo,1)]...
    %         ,'r','FaceAlpha',0.25,'EdgeColor','none'); %Draws Stimulus
    row=1;
    for r = 1:size(usedB,1) % Places ones instead of zeros according to go_table (i,j)
        trial=find(diff(usedB(r,:))>0);
        %         trial=find(data_nogo(r,:)>0);
        %         EndTr=plot(endsNoGo(r),r,'b*','MarkerFaceColor','b','MarkerSize',4);
        if trial
            errete=find(trial>=time_before & trial<time_before+time_after);
            subplot(312)
            h=plot(axRas(trial),r,'o','MarkerEdgeColor',clrLick,'MarkerFaceColor',clrLick,'MarkerSize',mkLck);
            %             EndTr=plot(endsNoGo(r),r,'b*','MarkerFaceColor','b','MarkerSize',4);
            try
                subplot(312)
                fstlk=plot(axRas(trial(errete(1))),r,'.','MarkerEdgeColor',clrRT,'MarkerFaceColor',clrRT,'MarkerSize',mkRT);
                %                 text(axRas(trial(errete(1))),r,num2str(numTrNG(r)),'Color',[.6 .6 .6]);
                
            end
        else
            r=r+1;
        end
    end
    rewSig=fill([2000,2000,3e3,3e3],[0,size(usedA,1)-1,size(usedA,1)-1,0],'k');             %Plots reward line
    rewSig.FaceColor='none';
    magIllus=[165 82 153]/256;
    rewSig.EdgeColor=magIllus;
    rewSig.LineStyle='--';
    
    
    %     xlim([-time_before time_after-time_before])
    subplot(312)
%     title('No-Go')
    %     xlabel('Time (sec)'); ylabel(Raster_title)
    axis tight
    %     legend([fstlk,h(1),rewSig],...
    %     'Reaction Time','Lick','Reward/Punishment','Location','best','Orientation','horizontal');%,...
    %     legend([go_f,nogo_f,fstlk,h(1),rewSig,''],'Both stimuli','Go stim','No-Go stim',...
    %         'Reaction Time','Lick','Reward/Punishment','Location','southoutside','Orientation','horizontal',...
    %         'numcolumns',2)
    %     legend('boxoff')
    ylim([0 size(usedB,1)])
    xlim([-time_before time_after-time_before])
    set(gca,'XTick',[])
    set(gca,'XTicklabel',[])
    
%     set(gca,'XTick',-time_before:Fs:time_after)
%     set(gca,'XTickLabel',{-time_before/Fs:time_after/Fs})
%     set(gca,'FontName','Arial')
    set(gca,'YTick',0:size(usedA,1)/2:size(usedA,1))
    set(gca,'YTickLabel',{0:size(usedA,1)/2:size(usedA,1)})
    set(gca,'FontSize',FoSi)
end

%% Lick density
YBins=max([max(binsGo) max(binsNoGo)]);
% YBins=10;
x2=[3000 3000];                     %Draws Reward
y2=[0 YBins];

%%
subplot(313), hold on
secBin=floor(length(usedA)/1e3)-time_before/1e3;
rem=length(usedA)-secBin*1000;
if rem
    axxx=(time_before*-1)+lick_bin:lick_bin:secBin*1e3;
else
    axxx=(time_before*-1)+lick_bin:lick_bin:secBin*1e3-lick_bin;
end
% axxx=(time_before*-1)+lick_bin:lick_bin:floor((time_after-time_before)/1e3)*1e3;
% secBin=floor((length(data_go))/1e3);
% remTime=((time_after+time_before)/1e3)-secBin;
% TimeBins=secBin*(1e3/lick_bin);
% binsPost=length(binsGo)-TimeBins;
% binsPost=lick_bin:lick_bin:lick_bin*binsPost;
% axxx=[axxx binsPost+axxx(end)];
% both=fill([0,2000,2000,0],[0,0,YBins, YBins]...
%     ,[.4 .4 .4],'FaceAlpha',0.4,'EdgeColor','none'); %Draws Stimulus
% GBinned=plot(axxx(1:length(binsGo)),binsGo,'g');
% PuBlu=[97 144 202]/256;
% GBinned=plot(axxx(1:length(binsGo)),binsGo,'Color',PuBlu);
GBinned=plot(axxx(1:length(binsGo)),binsGo,'Color','g');
% NGBinned=plot(axxx(1:length(binsGo)),binsNoGo,'r');
% PuOr=[239 120 0]/256;
% NGBinned=plot(axxx(1:length(binsGo)),binsNoGo,'Color',PuOr);
NGBinned=plot(axxx(1:length(binsGo)),binsNoGo,'Color','b');

%     try
%         plot(axxx,binsNoGo,'r')
%     end
% rewSig=fill([2000,2000,3e3,3e3],[0,10,10,0],'k');             %Plots reward line
% rewSig.FaceColor='none';
% rewSig.EdgeColor=magIllus;
% rewSig.LineStyle='--';

AntiLick=fill([1000,1000,2e3,2e3],[0,10,10,0],'k');             %Plots reward line
AntiLick.FaceColor='none';
AntiLick.EdgeColor='k';
AntiLick.LineStyle='--';

xlim([-time_before time_after-time_before])
ylim([0 YBins])
% ylim([0 ceil(YBins)])

%     axis tight
%     xlabel('Time (ms)'), ylabel(['Licks'])
% xlabel('Time (ms)'), ylabel(['Licks/Time bin' newline '(bins of ' num2str(lick_bin) ' milliseconds)'])
% xlabel('Time (ms)'), ylabel(['Licks/second (Hz)'])
% title('Licking Rate')
% NGBinned
% legend([both,GBinned,NGBinned,rewSig],'Both stimuli','Lick Go','Lick No-Go',...
%         'Rew/Pun','Location','best','Orientation','horizontal',...
%         'numcolumns',2)
%     legend('boxoff')
set(gca,'XTick',-time_before:Fs:time_after)
set(gca,'XTickLabel',{-time_before/Fs:time_after/Fs})
set(gca,'FontName','Arial')
set(gca,'FontSize',FoSi)

%     axis tight
% end
% %% LD
% try
%     ne=subplot(313); hold on
%     both=fill([0,2000,2000,0],[0,0,max(binsGo),max(binsGo)]...
%         ,[.6 .6 .6],'FaceAlpha',0.5,'EdgeColor','none'); %Draws Stimulus
%     remLicks=find(sum(data_go>0));
%     secBin=floor((length(data_go))/1e3);
%     remTime=((time_after+time_before)/1e3)-secBin;
%     TimeBins=secBin*(1e3/lick_bin);
%     % bins=[secBin*(1e3/lick_bin) size(binary_data,2)-segsPre];
%     axxx=(time_before*-1)+lick_bin:lick_bin:floor(time_after/1e3)*1e3;
%     binsPost=length(binsGo)-TimeBins;
%     binsPost=lick_bin:lick_bin:lick_bin*binsPost;
%     axxx=[axxx binsPost+axxx(end)];
%     % axxx=linspace(time_before*-1,time_after,length(bins4Stim));
%     % axxx=linspace(-time_before+lick_bin,time_after,length(bins4Stim));
%     plot(axxx,binsGo,'Color',stimColor)
%     xlabel('Time (ms)'), ylabel(['Licks/Bin (bins of ' num2str(lick_bin) ' milliseconds)'])
%     % xlim([-time_before time_after-time_before])
%     xlim([-time_before time_after-time_before])
%     legend([both,go_f,nogo_f,fstlk,h(1),rewSig,''],'Both stimuli','Go stim','No-Go stim',...
%         'Reaction Time','Lick','Reward/Punishment','End of trial','Location','southoutside','Orientation','horizontal')
%     legend('boxoff')
% end
% saveas(f1,['Raster_' Raster_title],'png')
%%
% fi=applytofig(rstr,'FontMode','Fixed','Color','rgb','width',4,'height',6,'linewidth',.15);
% print(rstr,'-painters',forfigs,['Raster_' Raster_title])
disp(['Raster ' Raster_title ' done and saved'])


