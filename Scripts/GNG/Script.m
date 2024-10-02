clear
close all
clc
% Read Folder

ss=uigetdir(pwd);
dirsu=ss;           % Current Folder Session
SubjDir=dir;        % Structure of SubFolders SESSIONS
noisy=0;            % task parameter
CueLog=0;           % task parameter
LogPunished=1;      % task parameter
dsub=pwd;           % current folder
disp(['This folder has ' num2str(length(SubjDir)-2) ' subfolders.'])
%% Folders to analyze
folTh = [1:numel(SubjDir)-2]; % onlye one session
%% ??
Tr_log=1;
bb=1;
ta=1;
%% % Sessions Loop
for foloop = 1:numel(folTh)
    foldNL=folTh(foloop); % index of folder
    currFo = SubjDir(foldNL+2).name; % 2 to ignore '.' AND '..' dir outputs
    % cd(fullfile(currFo)); % dont' go inside
%     FOlderDAta=fullfile(dirsu,currFo)
    %% PERFORMANCE ANALYSIS
    [oriout,go_stim,nogo_stim,corrected_licks,...
    Hits,FA,CR,misses,performance,...
    task,pos_ori,dif_times,go_posts,nogo_posts,licks_count]=...
    cal_performance_LCR_GAMAf(dsub,currFo,noisy);
    
    points_errased=1:50;
    raw_licks=task(:,3);
    %             raw_licks=BU;
    for point_e= points_errased
        [corrected_licks]=correct_licks(raw_licks,point_e);
        licks_count(point_e)=sum(find(diff(corrected_licks))>0);
    end
    th_licks=find(diff(licks_count)==0);
    %             th_licks=5e2;
    th_licks=points_errased(th_licks(1));
    [corrected_licks]=correct_licks(raw_licks,th_licks);
    bin_data_go=corrected_licks';
    lick_bin=length(bin_data_go);
    [GF]=Lick_Freq_Analysis(bin_data_go,lick_bin,'Licking-spectra-full-session')
    
    time_before=1;
    time_before=time_before*1e3;
    lick_bin=100;
    Fs=1e3;
    treadmill=task(:,2);
    lenpos=min([length(go_posts) length(nogo_posts)]);
    [speed_raw,speed_smooth]= getLocSpeed(treadmill,1e3,500,0);
    [all_data_parceled,data_parcel_go,data_parcel_nogo,treadmill_go,treadmill_nogo,RTs]=...
        lick_parcel_LCR(pos_ori,    corrected_licks,    time_before,dif_times,go_posts(1:lenpos),nogo_posts(1:lenpos),speed_smooth);
    points_after=length(all_data_parceled);
    %         points_after=round((length(all_data_parceled)-(time_before))/1e3);
    points_after=floor((length(all_data_parceled))/1e3);
    points_after=points_after*1e3;
    %         Tr_len=time_after+time_before;
    Tr_len=points_after;
    %         Tr_len=1e4;
    if Tr_len>1e4
        Tr_len=1e4;
        endsGo=Tr_len-time_before;
        endsNoGo=Tr_len-time_before;
        points_after=Tr_len-time_before;
    else
        %             try
        endsGo=Tr_len;
        endsNoGo=Tr_len;
        Trial_length=(Tr_len)*(1/1000);
    end
    data_go=data_parcel_go(:,1:Tr_len);
    data_nogo=data_parcel_nogo(:,1:Tr_len);
    disp('Data parcelation done')

    lick_bin=100;
    Fs=1e3;
    numTrG=1:size(data_go,1);
    numTrNG=1:size(data_nogo,1);
    
    
    %%Licking_Rate_Analysis
    time_after=1e4;
    aT=-time_before+lick_bin:lick_bin:time_after-time_before;
    aT=aT/Fs;
    [binsGo,binsNoGo,go_lick_DownSampled,binary_begs_Go,binary_begs_NoGo,LickDif]=lick_density(data_go,data_nogo,lick_bin);
    
    %%
    % Pre-stimuli rate
    miOne=find(aT==-.9);
    miO=find(aT==0);
    preRate_G=mean(binsGo(miOne:miO));
    preRate_NG=mean(binsNoGo(miOne:miO));
    
    %Anticipatory rate
    sec_Anticip=1;
    firstBin=find(aT==sec_Anticip);
    lastBin=find(aT==sec_Anticip+1);
    secBin=2;
    binDos=find(aT==secBin);
    binTres=find(aT==secBin+1);
    mn_Go_LickRate=mean(binsGo(firstBin:lastBin));
    mn_NoGo_LickRate=mean(binsNoGo(firstBin:lastBin));
    
    % Reward Rate
    RewRate=mean(binsGo(binDos:binTres));
    PunRate=mean(binsNoGo(binDos:binTres));
    
    PreIndexGo=mn_Go_LickRate/RewRate;
    Go_Rates=[preRate_G mn_Go_LickRate RewRate];
    Nogo_Rates=[preRate_NG mn_NoGo_LickRate PunRate];
    LickIncThr=mean(diff(binsGo)+(2*std(diff(binsGo))));
    LickDecThr=mean(diff(binsGo)-(2*std(diff(binsGo))));
    disp('Licking behavior analyzed')
    lick_bin=100;
    orderTrs='Chronological trials';
    Raster_Licks(data_go,time_before,time_after,orderTrs,lick_bin,binsGo,data_nogo,binsNoGo)
    cd ..
    cd ..
end
