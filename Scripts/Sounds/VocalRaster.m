%% MAKE VOCAL - RASTERs
% 
% IT WORKS AT 2 MODES:
%   > Single File:    rows: intervals (user-defined "trials")
%   > Multiple Files: rows: files
% 
% Solved Issue: vocals are way too short so raster columns are
% bins of time and whose values are counts of vocalization (binary) and how long (color)
% 
% Input
%   Output files from DeepSqueck (xlsx)
%   User Interface:
%     Audio Sampling Frequency
%     Length of Audio in s
% Output (\outputCSVs)
%   Audio Times of volcalizations (CSV)
%   Binary Binned Raster Matrix (CSV)
%   Length Binned Raster Matrix (CSV)
% 
clear; clc;
% Read multiple file in a folder
[A,Direction]=uigetfile('*.xlsx','MultiSelect','on');
if ischar(A)
    N=1;
    Archs{1}=A;
    fprintf('\n>Single File Mode\n')
else
    N=numel(A);
    Archs=A;
    fprintf('\n>Multiple File Mode N=%i\n',N);
end
%% User Input
% Sampling [Hz]
prompt = {'Sampling Frequency [kHz]'};
dlgtitle = 'fs';
dims = [1 30];
definput = {'340'};
fsinput = inputdlg(prompt,dlgtitle,dims,definput);
fs=str2double(fsinput)*1000;
% Length Recording [s]
prompt = {'Length recording [minutes]'};
dlgtitle = 'min';
dims = [1 35];
definput = {'5'};
Linput = inputdlg(prompt,dlgtitle,dims,definput);
L=str2double(Linput)*60;
if N==1
    % Multiple Records Raster Width [secs]
    prompt = {'Raster  Trials/Segments [seconds]'};
    dlgtitle = 's';
    dims = [1 40];
    definput = {'60'};
    COLNUMinput = inputdlg(prompt,dlgtitle,dims,definput);
    rownum=round(L/str2double(COLNUMinput{1}));
end
% Window Raster [samples]
prompt = {'Raster bin length [s]'};
dlgtitle = 's';
dims = [1 45];
definput = {'0.5'};
COLNUMinput = inputdlg(prompt,dlgtitle,dims,definput);
w=str2double(COLNUMinput)*fs;
%  Binning
prompt = {'Binning (vocalizations rate)'};
dlgtitle = 'ms';
dims = [1 30];
definput = {'100'};
bininput = inputdlg(prompt,dlgtitle,dims,definput);
bin=str2double(fsinput)/1000; % SECONDS

% w=Ns*fs;
% Color Map for 
ColorTypeVocals;
CMtypes =cbrewer('qual','Paired',numel(Types));
HayClass=false;
TableOut=table();
Tallvalues=table();
%% Main Loop
if N>1
    Vall=zeros(N,L*fs/w);
    Nall=zeros(N,L*fs/w);
    Lall=zeros(N,L*fs/w);
end
IVIall=[];
CWall=[];
Dall=[];
for n=1:N
    fprintf('\n>Loading %s, ',Archs{n})
    DATA=readtable([Direction,Archs{n}]);
    fprintf('done.\n, ')
    % Use Begin & End Times
    Ta=DATA.BeginTime_s_;
    Tb=DATA.EndTime_s_;
    % Creat zero vectors 
    Dbin=zeros(1,L*fs/w); % Length of vocalization(s)
    Vbin=zeros(1,L*fs/w); % Binary (there was or not vocalizations)
    Nbin=zeros(1,L*fs/w); % Number of vocalizations
    if ismember('Classification',DATA.Properties.VariableNames)
        HayClass=true;
        C=categorical(DATA.Classification);
        Cbin=zeros(1,L*fs/w); % Types of Vocalizations
        [~,indxcols]=ismember(C,Types);
    else
        HayClass=false;
    end
    % Vocalizations Loop
    for m=1:numel(Ta)
        fprintf('\n>Vocal #%i',m)
        a=round(Ta(m)*fs);
        b=round(Tb(m)*fs);
        l=DATA.CallLength_s_(m);        % length
        
        % V(a:b)=1;
        inicio=ceil(a/w);
        fin=ceil(b/w);
        if fin>L*fs/w
            fin=round(L*fs/w);
        end
        Vbin(inicio:fin)=1;              % If vocalization(s)
        Nbin(inicio:fin)=Nbin(inicio:fin)+1;  % N vocs
        Dbin(inicio:fin)=Dbin(inicio:fin)+l;  % Length
        if HayClass
            coltype=indxcols(m);
            Cbin(inicio:fin)=coltype;  % Color
        end
    end
    if N>1
        Vall(n,:)=Vbin;
        Nall(n,:)=Nbin;
        Lall(n,:)=Dbin;
        if HayClass
            Call(n,:)=Cbin;
        end
    end
    %% Features
    % Latency: [s]
    Latency=Ta(1);
    % Inter Vocal Interval: [s]
    IVI=Ta(2:end)-Tb(1:end-1);
    IVIall=[IVIall;IVI];
    % Oberlaping Vocs: IVI<0
    Noverlap=numel(find(IVI<0));
    % IVI(IVI<0)=0;
    % Instant Frequency: [Hz] Ignored

    % FI=1./(INI*10^-3);
    % FIall=[FIall;FI];
    
    % Vocal Duration: [s]
    D=Tb-Ta;
    Dall=[Dall;D];
    % Work Cycle [%]
    INI=Ta(2:end)-Ta(1:end-1);
    CW=100*D(1:end-1)./INI;
    CWall=[CWall;CW];
    % Rate Binning: [Hz]
    [tbin,VF]=vocalfreq(Ta,Tb,bin);
    RateV=VF/bin; 
    Rate=RateV(RateV>0);
    
    % Stats & Features: Ignore Overlapped (!)
    % maximum
    IVImax=max(IVI(IVI>0));
    CWmax=max(CW(and(CW>0,CW<100))); 
    Dmax=max(D);
    Rmax=max(Rate);
    % mean
    IVImean=mean(IVI(IVI>0));
    CWmean=mean(CW(and(CW>0,CW<100)));
    Dmean=mean(D);
    Rmean=mean(Rate);
    % mode
    IVImode=mode(IVI(IVI>0));
    CWmode=mode(CW(and(CW>0,CW<100)));
    Dmode=mode(D);
    Rmode=mode(Rate);
    % minimum
    IVImin=min(IVI(IVI>0));
    CWmin=min(CW(and(CW>0,CW<100)));
    Dmin=min(D);
    Rmin=min(Rate);
    % Coefficient of Variation (Regular Rates)
    IVIcv=mean(IVI(IVI>0))/std(IVI(IVI>0));
    % FIcv=mean(FI)/std(FI);
    % Dcv=mean(D)/std(D);
    Rcv=mean(Rate)/std(Rate);
    % OUTPUT
    FName=Archs{n};
    T=table({FName},Latency,IVImin,IVImode,IVImean,IVImax,IVIcv,...
        CWmin,CWmode,CWmean,CWmax,...
        Dmin,Dmode,Dmean,Dmax,...
        Rmin,Rmode,Rmean,Rmax,Rcv, ...
        Noverlap);
    
    TableOut=[TableOut;T];
    Tvalues=table(repmat({FName},size(D)),D,[IVI;NaN],[CW;NaN]);
    Tallvalues=[Tallvalues;Tvalues];
end
%%
F=figure;
F.Units='normalized';
title(FName)
subplot(311)
% histogram(IVIall)
C1=cdfplot(IVIall(IVIall>0));
xlabel('Inter Vocalizations Intervals [s]')
ylabel('Cumulative Probability')
axis tight; grid on;
subplot(312)
% histogram(CWall)
C2=cdfplot(CWall(and(CWall>0,CWall<100)));
xlabel('Work Cycle [%]')
ylabel('Cumulative Probability')
axis tight; grid on;
subplot(313)
% histogram(Dall)
C3=cdfplot(Dall);
C1.LineWidth=2;
C2.LineWidth=2;
C3.LineWidth=2;
xlabel('Voc. Duration [s]')
ylabel('Cumulative Probability')
axis tight; grid on;
%     subplot(414)
%     bar(tbin,VF)
%     xlabel('Time [s]')
%     ylabel('Voc. Rate (Hz)')
%     axis tight; grid on;
    F.Position= [0.1667 0.0676 0.2406 0.7778];

%% Outputs
if N==1
    Ncols=L/(w/fs)/rownum;
    Vraster=reshape(Vbin,Ncols,rownum)';
    Draster=reshape(Dbin,Ncols,rownum)';
    Nraster=reshape(Nbin,Ncols,rownum)';
    Plot_Raster(Vraster,w/fs);
    Plot_Raster(Draster,w/fs);
    Plot_Raster(Nraster,w/fs);
    if HayClass
        Craster=reshape(Cbin,Ncols,rownum)';
        Plot_Raster(Craster,w/fs,CMtypes);
        Colfig=gcf;
        Colfig.Children(1).FontSize=7;
        Colfig.Children(1).TicksMode='manual';
        Colfig.Children(1).Ticks=(1:numel(Types))/numel(Types)-0.5/numel(Types);
        Colfig.Children(1).TickLabels=Types;
    end
else
    Plot_Raster(Vall,w/fs);
    Plot_Raster(Lall,w/fs);
    Plot_Raster(Nall,w/fs);
    if HayClass
        Plot_Raster(Call,w/fs,CMtypes);
        Colfig=gcf;
        Colfig.Children(1).FontSize=7;
        Colfig.Children(1).TicksMode='manual';
        Colfig.Children(1).Ticks=(1:numel(Types))/numel(Types)-0.5/numel(Types);
        Colfig.Children(1).TickLabels=Types;
    end
    disp(table([1:N]',Archs','VariableNames',{'Rows','File Names'}));
end
%% Write Table
Tallvalues.Properties.VariableNames={'File','Duration_s','IVI_s','WorkCycle_%'};
filetime=char(datetime("now"));
filetime(filetime==':')='_';
filetime(filetime==' ')='-';
Destination=[Direction,'Table_',filetime,'.csv'];
writetable(TableOut,Destination);
Destination=[Direction,'Table_ALLVALUES_',filetime,'.csv'];
writetable(Tallvalues,Destination);
fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See output table here</a>\n',Direction);