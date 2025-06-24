%% READ FOLDERS ONE BY ONE
% SETUP
% Mouse Folder must be contain Sessions Folders
clear;
checkFolders=true;
Tall=table;
Nsec=1;     % Pre stimulus time [s]
ws=100;     % Sliding Window [ms]
cylrad=5;   % Cylinder Radius[cm]
ol=0;       % Window OverLapping (Speed and Licking Rate) [%]
fs=1000;    % [Hz] NIDAQ  Sampling Frequency
PreStim=round(Nsec*fs); % Samples Pre Stimulus

% GNGfolder=uigetdir(pwd);
%% Get Session Folders of X- mouse
GNGfolder=uigetdir(pwd,'Mouse Sessions Folder');
list=dir(GNGfolder);
OKdir=[];
ListNames={};
aux=1;
for i=1:numel(list)
    if list(i).isdir  && (~or(strcmp('.',list(i).name),strcmp('..',list(i).name)))
        OKdir=[OKdir;i];
        ListNames{aux}=list(i).name;
        ListDirs{aux}=list(i).folder;
        aux=aux+1;
    else
        fprintf('*')
    end
end
fprintf('\n')
[foldsess,ok]=listdlg('PromptString',{'Select Folder Sessions',...
        'Sessions Data',''},...
        'SelectionMode','multiple','ListString',ListNames);
FolderNameSessions=ListNames(foldsess);
FolderSessions=ListDirs(foldsess);
%% Get session-mat files
MatFileSessions={};
for i=1:numel(foldsess)
    % Session Intel
    GNGfolder=[FolderSessions{i},filesep, FolderNameSessions{i}];
    IndxssSep=strfind(GNGfolder,filesep);
    MouseIDc=GNGfolder(IndxssSep(end-1)+1:IndxssSep(end)-1);
    DateSess=GNGfolder(IndxssSep(end)+1:end);
    Datec=DateSess(1:find(DateSess=='-',1)-1);
    Sesionc=DateSess(find(DateSess=='-',1)+1:end);
    % GUI to corroborate
    answer={};
    while isempty(answer)
        prompt = {'Mouse ID:','Date: YY/MM/DD','Session:'};
        dlgtitle = 'Check';
        dims = [1 35];
        definput = {MouseIDc,Datec,Sesionc};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
    end

    % Final step:
    MouseID{i}=answer{1};
    Date{i}=answer{2};
    Sesion{i}=answer{3};
    matfiles=ls([FolderSessions{i},filesep,FolderNameSessions{i},filesep,'*.mat']);
    Nmatf=size(matfiles,1);
    if size(matfiles,1)>1
        MF=matfiles;
        if ischar(MF)
            MFchar=MF;
            MF={};
            for c=1:size(MFchar,1)
                MF{c}=MFchar(c,~isspace(MFchar(c,:)));
            end
        end
    else
        MF{1}=matfiles;
    end

    [f,ok]=listdlg('PromptString',{'Select a MAT file.',...
        'Session Intel.',''},...
        'SelectionMode','single','ListString',MF);
    if ok
        MatFileSessions{i}=MF{f};
    else
        MatFileSessions{i}='';
    end
end
%% Processing
% while checkFolders
for i=1:numel(FolderSessions)
    %% Sensor Data and Metadata
    % 1: rewards
    % 2: movement
    % 3: licks
    % 4: punishment
    % 5: stimuli: 1 Go, 2: NoGo
    % 6: nothing
    % Read Session Folder
    %GNGfolder=uigetdir(pwd);
    GNGfolder=[FolderSessions{i},filesep, FolderNameSessions{i}];
    task=getdatagng(GNGfolder);
    rw= task(:,1);
    mov= task(:,2);
    Thelicks=task(:,3);
    pn= task(:,4);
%     % Session Intel
%     IndxssSep=strfind(GNGfolder,filesep);
%     MouseID=GNGfolder(IndxssSep(end-1)+1:IndxssSep(end)-1);
%     DateSess=GNGfolder(IndxssSep(end)+1:end);
%     Date=DateSess(1:find(DateSess=='-',1)-1);
%     Sesion=DateSess(find(DateSess=='-',1)+1:end);
%     % GUI to corroborate
%     answer={};
%     while isempty(answer)
%         prompt = {'Mouse ID:','Date: YY/MM/DD','Session:'};
%         dlgtitle = 'Check';
%         dims = [1 35];
%         definput = {MouseID,Date,Sesion};
%         answer = inputdlg(prompt,dlgtitle,dims,definput);
%     end
%     % Final step:
%     MouseID=answer{1};
%     Data=answer{2};
%     Sesion=answer{3};
    % Stimuli info: read MAT file from acquisition
%     matfiles=ls([GNGfolder,filesep,'*.mat']);
%     Nmatf=size(matfiles,1);
%     if size(matfiles,1)>1
%         MF=matfiles;
%         if ischar(MF)
%             MFchar=MF;
%             MF={};
%             for c=1:size(MFchar,1)
%                 MF{c}=MFchar(c,~isspace(MFchar(c,:)));
%             end
%         end
%     else
%         MF{1}=matfiles;
%     end
    clc%% Task Performance: 
    disp('Hits/Performance/Water')
    % 3th-party previous function:
    [Hits,Performance,total_water,dataperf]=cal_performance_LCR(task);
    % Recovered filtered data: dataperf
    STIMRESPONSE=evalgonogo(dataperf);
    % Check Onsets accoridng to STIMRESPONSE
    StimsOK=find(~isundefined(STIMRESPONSE(:,1))); % omit undefined cases
    STIMRESPONSE=STIMRESPONSE(StimsOK, :);
    % Categorical STIM-RESPONSE
    OUTPUT=winperfor(STIMRESPONSE,0); % Instaneous Performace
    FInsta=gcf;
    ti=title([[MouseID{i},'-',Sesion{i}]]);
    ti.Interpreter='none';
%     [f,ok]=listdlg('PromptString',{'Select a MAT file.',...
%         'Session Intel.',''},...
%         'SelectionMode','single','ListString',MF);
    
    % Checking Data    
    if ~isempty(MatFileSessions{i})
        load([GNGfolder,filesep,MatFileSessions{i}]);
        STI=parameters.sequence; % Orientations|Contrasts
        ORI=categorical(STI(:,1),[0,90],{'Go', 'NoGo'});
        if isempty(setdiff(ORI,STIMRESPONSE(:,1)))
            disp('Correct sequence of stimuli')
        else
            disp('Check stimuli sequence!!!!!')
        end
    else
        fprintf('\n>No task data, using arduino s\n')
        STIstr=STIMRESPONSE(:,1);
        STI=zeros(size(STIstr));
        STI(STIstr=='Go')=1;
        % Get paramaters from Arduino Data
    end
    ors=STI(:,1); % numerical sequence of stim degrees
    stimis=unique(ors); % unique stimulus
    % Variable 'parameters'
    %% Stim Analysis: how random?
    % Transitions
    % Rows Current
    % Columns Next
%     MATTRAN=zeros(numel(stimis));
%     for k=2:numel(ors)
%         Curr=find(stimis==ors(k));      % Current   t
%         Preb=find(stimis==ors(k-1));    % Previous  t-1
%         MATTRAN(Curr,Preb)=MATTRAN(Curr,Preb)+1; % Increase frec
%         % EntropyRate
%         FrecStims=sum(MATTRAN,1);
%         mu=sum(MATTRAN,1)./(sum(MATTRAN(:)));
%         Hrate(k)=0;
%         for i=1:numel(mu)
%             A(:,i)=MATTRAN(:,i)./FrecStims(:,i);
%             h(i)=0;
%             for j=1:size(A,2)
%                 h(i)=h(i)-A(i,j)*log2(A(i,j));
%             end
%             Hrate(k)=Hrate(k)+mu(i)*h(i);
%         end
%     end
%     
    
%     B=zeros(2,numel(ors));
%     Gofrq=0;
%     NoGofrq=0;
%     for i=1:numel(ors)
%     % Emission Porbability/ Observation Probabilities
%         if ors(i)==stimis(1)
%             Gofrq=Gofrq+1;
%             
%         else
%             NoGofrq=NoGofrq+1;
%             
%         end
%         B(2,i)=NoGofrq/i; % Go Probability at each State
%         B(1,i)=Gofrq/i; % Go Probability at each State
%         Entrpy(i)=-sum([NoGofrq/i, Gofrq/i].*log2([NoGofrq/i, Gofrq/i])); % Entro
%     end
%     
    [MATTRAN,Hrate,Entrpy]=howrandom(ors);
    
    NansHrate=find(isnan(Hrate));
    [MaxH, MaxHTrail]=max(Hrate);
    [MinH, MinHTrail]=min(Hrate((NansHrate(end)+1:end)));
    MinHTrail=MinHTrail+NansHrate(end)+1;

    MT=array2table(MATTRAN,'RowNames',{'Go_t';'NoGo_t'},'VariableNames',{'Go_t+1','NoGo_t+1'});
    disp(MT)
    % %% HMM
    % N = 2;  % Adjust based on your data
    M = numel(ors);  % Adjust based on your data
    A = MATTRAN/sum(MATTRAN(:));
    Prepe=sum(A([1,4]));
    Ptran=sum(A([2,3]));
    pdfE=histogram(Entrpy);
    asyEnt=pdfE.BinEdges(end-1);
    NtrialStblEntorpy=find(smooth(Entrpy)>=asyEnt,1);

    [BestPerfo,BestTrial]=max(OUTPUT.InstaPerfor(NtrialStblEntorpy:end));
    [WorstFA,WorstTrial]=max(OUTPUT.InstaFAc(NtrialStblEntorpy:end));
    [BeststDeltaP,BestImproveTrail]=max(OUTPUT.DeltaPerfo(NtrialStblEntorpy:end));
    BestTrial=BestTrial+NtrialStblEntorpy;
    WorstTrial=WorstTrial+NtrialStblEntorpy;
    BestImproveTrail=BestImproveTrail+NtrialStblEntorpy;
    %% CHECK STIMULUS AS SAVED by ADQUISITION
%     % Entropy Rate (Wikipedia's Def)
%     mu=sum(MATTRAN,1)./(sum(MATTRAN(:)));
%     HrateW=0;
%     for i=1:numel(mu)
%         h(i)=0;
%         for j=1:size(A,2)
%             h(i)=h(i)-A(i,j)*log2(A(i,j));
%         end
%         HrateW=HrateW+mu(i)*h(i);
%     end
    
    % plot(Entrpy);
    % hold on
    % plot(smooth(Entrpy),'LineWidth',2);
    % [MaxEntropy, Position]=max(smooth(Entrpy));
    % Correlation beteen Entropy and Performance?
    % [Rfa,Pfa]=corr(Entrpy',OUTPUT.CumFAPerc,'rows','complete');
    % [Rhit,Phit]=corr(Entrpy',OUTPUT.CumHitsPerc,'rows','complete');
    % [Rperf,Pperf]=corr(Entrpy',OUTPUT.CumFPerfoPerc,'rows','complete');
    % scatter(OUTPUT.CumFAPerc,Entrpy',[],1:numel(Entrpy),'filled')
    
    % Autocorrelation of the stimulo
    orsInt=ones(size(ors));
    orsInt(ors==90)=2;
    % ACF=autocorr(orsInt,numel(ors)-1);
    ACF=autocorr(ors,numel(ors)-1);
    ACFlagone=ACF(2);
    % % % figure
    % % % subplot(1,2,1)
    % % % plot(Entrpy);
    % % % xlabel('Trial')
    % % % ylabel('Entropy [Bits]')
    % % % grid on;
    % % % subplot(1,2,2)
    % % % imagesc(A)
    % % % Ax=gca;
    % % % Ax.XTickMode='manual';
    % % % Ax.YTickMode='manual';
    % % % Ax.XTick=[1,2];
    % % % Ax.YTick=[1,2];
    % % % Ax.XTickLabel={'Go','No Go'};
    % % % Ax.YTickLabel={'Go','No Go'};
    % % % ylabel('Previous')
    % % % xlabel('Next')
    % % % colormap gray
    % % % colorbar
    % [estA, estB] = hmmtrain(orsInt, A, B, 'Tolerance', 1e-4, 'Maxiterations', 100,'Verbose',true);
    % 
    % disp(estA);
    % disp(estB);
    %% MOVEMENT PRE-PROCESSING
    
    [Z,Zs,Turns,RZ]=procemov(mov);
    % Z: Sensor accumulated Turns Displacement
    % Zs: Smoothed Z
    % Turns: Frames where complete turns Sign: direction
    %  RZ: Volts Amplitude Changes of Direction
    Turns(end)=Turns(end)-1; % OK
    Volts2piRad=floor(max(RZ)); % Volts per Turn
    NGiros=sum(RZ>Volts2piRad);
    
    [D,Spped]=voltmovtocm(Zs,Turns,RZ,cylrad,ws,fs);
    TotalDistance=round(D(end));
    
    %% RASTERIZE LICK & SPEED
    % onsets of Go/NoGo in 
    LickThreshold=1.5;
    TheStims=task(:,5);
    Onsets=find(diff(TheStims)>0.5);
    Offsets=find(diff(-TheStims)>0.5);
    StimDur=Offsets(1:min([numel(Offsets),numel(Onsets)]))-Onsets(1:min([numel(Offsets),numel(Onsets)]));
    StimLength=abs(round(round(mean(StimDur))/fs)*1000);
    OnsetsNoGo=Onsets(TheStims(Onsets+1)>1.7);
    OnsetsGo=setdiff(Onsets,OnsetsNoGo);
    fprintf(">Found: %i Go and %i No Go stimulus\n",numel(OnsetsGo),numel(OnsetsNoGo));
    Onsets=find(diff(TheStims)>0.95)-PreStim;
    % 5: stimuli: 1 Go, 2: NoGo
    % avginter=round(mean(Onsets));
    avginter=round(mean(diff(Onsets)));
%     LickMatrix=zeros(numel(Onsets),round(max(diff(Onsets))));
    LickMatrix=zeros(numel(ors),round(mean(diff(Onsets))));
%     MovMatrix=zeros(numel(Onsets),round(max(diff(Onsets))));
%     MovMatrix=zeros(numel(ors),round(max(diff(Onsets))));
    MovMatrix=zeros(numel(ors),round(mean(diff(Onsets))));
    SpeMatrix=[];
    
    for n=1:numel(Onsets)
        a=Onsets(n);
        if n==numel(Onsets)
            b=a+avginter-1;
            if b>numel(Onsets)
                b=numel(Onsets);
            end
        else
            b=Onsets(n+1)-1;
        end
        LikSegment=Thelicks(a:b);
        MovSegment=D(a:b); 
        LickMatrix(n,LikSegment>LickThreshold)=1;
        MovMatrix(n,1:numel(MovSegment))=MovSegment;
        VelSement=get_velocity_interval(MovSegment,ws/fs,fs);
        VS=VelSement';
        if n>1
            if size(VS,2)<size(SpeMatrix,2)
                VS=[VS,zeros(1,size(SpeMatrix,2)-size(VS,2))];
            elseif size(VS,2)>size(SpeMatrix,2)
                VS=[VS(1:size(SpeMatrix,2))];
            end
        end
        SpeMatrix=[SpeMatrix;VS];
    end
    % Features:
    LicksGo=LickMatrix(ors==stimis(1),:);
    LicksNoGo=LickMatrix(ors==stimis(2),:);
    LickPercGO=100*sum(LicksGo(:))/(sum(LicksGo(:))+sum(LicksNoGo(:)));
    LickPercNoGO=100*sum(LicksNoGo(:))/(sum(LicksGo(:))+sum(LicksNoGo(:)));
    %% PLOT RASTER (fast vis)
    % Input (Lick Matrix,ors,)
    if size(LickMatrix,1)<numel(ors)
        LickMatrix(end+1,:)=zeros(size(LickMatrix(1,:)));
        fprintf('*')
    end
    if size(SpeMatrix,1)<numel(ors)
        SpeMatrix(end+1,:)=zeros(size(SpeMatrix(1,:)));
        fprintf('x')
    end
    figure
    A1=subplot(131);
    imagesc(LickMatrix)
    A1.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A1.XTick)
        A1.XTickLabel{n}=num2str(A1.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix,1)],'EdgeColor','k')
    ti=title([[MouseID{i},'-',Sesion{i}]]);
    ti.Interpreter='none';
    ylabel('Trials')
    
    A2=subplot(132);
    
    imagesc(LickMatrix(ors==stimis(1),:))
    A2.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A2.XTick)
        A2.XTickLabel{n}=num2str(A2.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix(ors==stimis(1),:),1)],'EdgeColor','k')
    title(sprintf('Stim: %i °',stimis(1)))
    xlabel('Peri-Stimuli [ms]')
    A3=subplot(133);
    imagesc(LickMatrix(ors==stimis(2),:))
    A3.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A3.XTick)
        A3.XTickLabel{n}=num2str(A3.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix(ors==stimis(2),:),1)],'EdgeColor','k');
    title(sprintf('Stim: %i °',stimis(2)))
    CM=[1 1 1; 0 0 0];
    colormap(CM);
    %% SORT BY:
    % % % % Hits
    % % % % Correct Rejects
    % % % % False Alarmas
    % % % % Incorrect Rejects
    % % % Sorting=[find(STIMRESPONSE(:,2)=='Hit');find(STIMRESPONSE(:,2)=='Miss');...
    % % %     find(STIMRESPONSE(:,2)=='CR');find(STIMRESPONSE(:,2)=='FA')];
    % % % figure
    % % % imagesc(LickMAtrix(Sorting,:))
    % % % title('Complete')
    % % % colormap(CM);
    %% LICK RATE
    [T,R]=lickrate(LickMatrix,ws,ol,fs);
%     LRfig=figure;
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
    %% MOVEMENT PLOTS
    % % % figure
    % % % subplot(211)
    % % % tD=linspace(0,numel(D)/fs/60,numel(D)); % MINUTES
    % % % plot(tD,D)
    % % % grid on;
    % % % ylabel('Distance [cm]')
    % % % xlabel('Time [min]')
    % % % twin=linspace(0,numel(mean(SpeMatrix))*ws/1000,numel(mean(SpeMatrix)));
    % % % subplot(234)
    % % % plot(twin-PreStim/1000,mean(SpeMatrix))
    % % % axis([min(twin-PreStim/1000),max(twin-PreStim/1000),0,1.1*max(SpeMatrix(:))]);
    % % % ylabel('cm/s')
    % % % grid on;
    % % % subplot(235)
    % % % plot(twin-PreStim/1000,mean(SpeMatrix(ors==stimis(1),:)))
    % % % axis([min(twin-PreStim/1000),max(twin-PreStim/1000),0,1.1*max(SpeMatrix(:))]);
    % % % xlabel('s')
    % % % grid on;
    % % % subplot(236)
    % % % plot(twin-PreStim/1000,mean(SpeMatrix(ors==stimis(2),:)));
    % % % axis([min(twin-PreStim/1000),max(twin-PreStim/1000),0,1.1*max(SpeMatrix(:))]);
    % % % grid on;
    %% FEATURES
    RowsGO=find(ors==stimis(1));
    RowsNOGO=find(ors==stimis(2));

    Vgo=SpeMatrix(RowsGO(RowsGO<size(SpeMatrix,1)),:);
    Vnogo=SpeMatrix(RowsNOGO(RowsNOGO<size(SpeMatrix,1)),:);
    
    PercDistGo=100*sum(sum(Vgo*ws/1000))/(sum(sum(Vgo*ws/1000))+sum(sum(Vnogo*ws/1000)));
    PercDistNoGo=100*sum(sum(Vnogo*ws/1000))/(sum(sum(Vgo*ws/1000))+sum(sum(Vnogo*ws/1000)));
    % TotalDistance=(sum(sum(Vgo*ws/1000))+sum(sum(Vnogo*ws/1000)));
    
    PercLickGo=100*sum(sum(Rgo,2))/sum(R(:));
    PercLickNoGo=100*sum(sum(Rnogo,2))/sum(R(:));
    
    % False Alarms
    FAindx=find(STIMRESPONSE(:,2)=='FA');
    Alter=0;
    Same=0;
    for j=1:numel(FAindx)
        if FAindx(j)>1
            if STIMRESPONSE(FAindx(j)-1,1)=='Go'
                Alter=Alter+1;
            else
                Same=Same+1;
            end
        end
    end
    PercAlterFA=100*Alter/numel(FAindx);
    PercSameFA=100*Same/numel(FAindx);
    
    % Hits
    
    MISSindx=find(STIMRESPONSE(:,2)=='Miss');
    Alter=0;
    Same=0;
    for j=1:numel(MISSindx)
        if MISSindx(j)>1
            if STIMRESPONSE(MISSindx(j)-1,1)=='NoGo'
                Alter=Alter+1;
            else
                Same=Same+1;
            end
        end
    end
    PercAlterMISS=100*Alter/numel(MISSindx);
    PercSameMISS=100*Same/numel(MISSindx);
    
    
    %% OUPUT: MAT FILE
    fprintf('\n>Saving MAT file:')
    IndxSeps=strfind(GNGfolder,filesep);
    % CurrFolder=pwd;
    CurrFolder=GNGfolder;
    FolderIndx=strfind(CurrFolder,filesep);
    Destinity=[CurrFolder(1:FolderIndx(end)),'GNG_results',filesep];
    if ~exist(Destinity,'dir')
        mkdir(Destinity)
        fprintf('Directory: %s created',Destinity)
    end
    MouseName=MouseID{i};
    DateName=Date{i};
    SesionName=Sesion{i};
    save([Destinity,MouseID{i},'-',Sesion{i},'.mat'],"MouseName","DateName","SesionName",...
        "Hits","Performance","STIMRESPONSE","OUTPUT","Hrate",...
        "dataperf","Entrpy","A","LickMatrix","D","SpeMatrix","MovMatrix");
    fprintf('done.\n')
    fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See MAT file here</a>\n',Destinity);
    
    %% OUTPUT: TABLE
    t=table({MouseID{i}},{Sesion{i}},{Date{i}},OUTPUT.H,OUTPUT.FA,OUTPUT.P,...
        BestTrial, BestPerfo, WorstTrial, WorstFA,BestImproveTrail, BeststDeltaP,...
        Hrate(end),MaxH, MaxHTrail,MinH, MinHTrail,PercDistGo,PercDistNoGo, TotalDistance,...
        LickPercGO,LickPercNoGO,PercLickGo, PercLickNoGo,...
        PercAlterFA,PercSameFA, PercAlterMISS,PercSameMISS,...
        Prepe,Ptran,NtrialStblEntorpy,ACFlagone);
    t.Properties.VariableNames={'ID','Session','Date','Hits','FA','P',...
        'BestTrial', 'BestPerfo', 'WorstTrial', 'WorstFA','BestImprove', 'BeststDeltaP'...
        'EntropyRate','MaxEtropy', 'MaxEtropyTrial','MinEnropy', 'MinEtropyTrial','GO_perc_dist','NOGO_perc_dist','TotalDist',...
        'PercenLickGO','PercenLickNOGO','PercenLickGOb','PercenLickNOGOb',...
        'FAperTRAN','FAperREP','MISSpercTRAN','MISSpercREP',...
        'REP_prob','TRAN_prob','EntropiestTrial','ACCstim'};
    
    % Distance@Go
    % Distance@NoGo
    % Distance@Stim
    % Distance@InterStim
    % fs
    Tall=[t;Tall];
    disp(Tall);
%     FolderIndx=strfind(GNGfolder,filesep);
%     GNGfolderpre=GNGfolder(1:FolderIndx(end)-1);
%     GNGfolder=uigetdir(GNGfolderpre);
%     if GNGfolder==0
%         checkFolders=false;
%     end
end
fprintf('\n>Saving table:')
writetable(Tall,[Destinity,MouseID{i},'.csv'])
fprintf('done.\n')
% disp('Run the script >GoNoGo_Animal')
