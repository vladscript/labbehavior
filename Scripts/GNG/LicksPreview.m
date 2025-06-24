%% 
%% Load data4
fs=1000;
%% Binaring
licks=zeros(size(data4));
licks(data4>2.5)=1;
t=linspace(0,numel(licks)/fs,numel(licks));
%% Rasterize
bin=60;  % seconds
TotRows=ceil(t(end)/bin); % Total Rows
TotCols=bin*fs;
R=zeros(TotRows,TotCols);
a=1;
b=TotCols;
for n=1:TotRows
    if b>numel(licks)
        b=numel(licks);
    end
    l=licks(a:b);
    R(n,1:numel(l))=l;
    a=b+1;
    b=b+TotCols-1;
end
figure
imagesc(R)
colormap([1,1,1;0,0,0])
%% METRICS
% Spectral
fss=[2:.01:20];
[t,fre] = pwelch(licks,round(length(licks)*.10),round(length(licks)*.01),fss,fs);
[a,c]=findpeaks(t,"NPeaks",1,"SortStr","descend");   % spectral peak
FreqPeak=fre(c);          % frequency (OUTPUT)
% Lick duration
Onsets=find(diff(licks)>0);
Offsets=find(diff(licks)<0);

if numel(Onsets)<numel(Offsets)
    if Onsets(1)>Offsets(1)
        Offsets=Offsets(2:end);
    end
elseif numel(Onsets)>numel(Offsets)
    if Onsets(end)>Offsets(1)
        Onsets=Onsets(1:end-1);
    end
else
    disp('OK')
end

Nlicks=numel(Onsets);
LickpSec=Nlicks/(numel(licks)/fs);
Duration=(Offsets-Onsets);
medDur=median(Duration);
% Check:
    % Onsets(1)
    % Offsets(1)

% ILI
ILI=Onsets(2:end)-Offsets(1:end-1);
medILI=median(ILI);
% Duty cycle
DC=Duration(1:end-1)./(Duration(1:end-1)+ILI)
medDC=median(DC);

table(LickpSec,FreqPeak,medDur,medILI,medDC)