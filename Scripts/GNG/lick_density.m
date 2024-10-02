%%%%%%%%Lick density
function [binsGo,binsNoGo,go_lick_DownSampled,nogo_lick_DownSampled,binary_begs_Go,binary_begs_NoGo,LickDif]=lick_density(data_go,data_nogo,TimeBin)
cols=size(data_go,2);
% % % % TimeOfReward=3000; %%%%% Time of reward in milliseconds
windowBin=TimeBin;      %%%% Size of bin
periodForBaseline=500;%%%%% will count the licks during this period
% % % % deviations=1;

binary_begs_Go=zeros(size(data_go,1),cols);
binary_begs_NoGo=zeros(size(data_nogo,1),cols);

for t = 1:size(data_go,1)
    begs=(diff(data_go(t,:))>0)*1;
    dif_begs=find(begs);
    plus_dif_begs=dif_begs+1;
    begs(dif_begs)=0;
    begs(plus_dif_begs)=1;
    binary_begs_Go(t,1:length(begs))=begs;
end

for t = 1:size(data_nogo,1)
    begs=(diff(data_nogo(t,:))>0)*1;
    dif_begs=find(begs);  
    plus_dif_begs=dif_begs+1;
    begs(dif_begs)=0;
    begs(plus_dif_begs)=1;
    binary_begs_NoGo(t,1:length(begs))=begs;
end
%%
%%%%%%%%%%%%Lick Density for GO Stim
intSteps=floor(cols/windowBin);
doubStep=(cols/windowBin);
subSteps=doubStep-intSteps;
if subSteps >0
    totalSteps=intSteps+1;
else
    totalSteps=intSteps;
end
%% Go summary
firstPoint=1; %%%%%%%%initial point in bin
step=1;       %%%%%%%% last point in bin
nextStep=windowBin; %%% Cuts afterwards to 8000
tr=1;
for tr=1:size(binary_begs_Go,1)
    tra=binary_begs_Go(tr,:);
%     tra=binary_begs_Go(:);
    for step=1:totalSteps%%%%%Throughout the whole period of time
        try
        licks=sum(tra(:,firstPoint:step*TimeBin));
%             licks=sum(sum(binary_begs_Go(:,firstPoint:nextStep)));
        catch
%             licks=sum(sum(binary_begs_Go(:,firstPoint:end)));
            licks=sum(tra(:,firstPoint:end));
        end
        firstPoint=firstPoint+windowBin;
        nextStep=nextStep+windowBin;    
        binsGo(tr,step)=licks;
    end
    firstPoint=1;
    nextStep=windowBin;
end
%% No-Go summary
firstPoint=1; %%%%%%%%initial point in bin
step=1;       %%%%%%%% resets counter
nextStep=windowBin; %%% Cuts after 8000
tr=1;
for tr=1:size(binary_begs_NoGo,1)
    tra=binary_begs_NoGo(tr,:);
%     tra=binary_begs_Go(:);
    for step=1:totalSteps%%%%%Throughout the whole period of time
        try
        licks=sum(tra(:,firstPoint:step*TimeBin));
%             licks=sum(sum(binary_begs_Go(:,firstPoint:nextStep)));
        catch
%             licks=sum(sum(binary_begs_Go(:,firstPoint:end)));
            licks=sum(tra(:,firstPoint:end));
        end
        firstPoint=firstPoint+windowBin;
        nextStep=nextStep+windowBin;    
        binsNoGo(tr,step)=licks;
    end
    firstPoint=1;
    nextStep=windowBin;
end
%%
go_lick_DownSampled=binsGo;
nogo_lick_DownSampled=binsNoGo;
binsGo=(1/(TimeBin/1e3))*(binsGo/size(data_go,1));
% binsGo=(binsGo/size(data_go,1))/(TimeBin/1e3);
binsNoGo=(1/(TimeBin/1e3))*(binsNoGo/size(data_nogo,1));
% go_lick_DownSampled=binsGo;
% nogo_lick_DownSampled=binsNoGo;



% binsNoGo=(binsNoGo/size(data_nogo,1))/(TimeBin/1e3);
binsGo=sum(binsGo);
binsNoGo=sum(binsNoGo);
LickDif=binsGo-binsNoGo;
% area=trapz(difference);
% licksForBase=mean(binsGo(1:round(periodForBaseline/windowBin)));

% binnedGo=mean(binsGo);
% binnedNoGo=mean(binsNoGo);