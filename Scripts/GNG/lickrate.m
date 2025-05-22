function [T,R]=lickrate(LickMAtrix,ws,ol,fs)
% Input:
% ws: size of the window [ms]
% ol: overlaping [%]
% fs: Sampling Frequency [Hz]
% Output:
% R: Matrix of Lick Rates [Hz]
% T: Time Vector
[N,M]=size(LickMAtrix);
TotalSecTrial=M/fs;
Nwin=ceil(TotalSecTrial/(ws/1000));
R=[];
T=[];
% % Test
% ws=500; % ms
% ol=0;
% Main Loop
for n=1:N
    fprintf('\nCounting Licks@ %i trial:',n);
    r=LickMAtrix(n,:);
    dr=diff(r);
    licks=zeros(size(r));
    [~,licksamp]=findpeaks(dr);
    licks(licksamp+1)=1;
    a=1;
    b=round(ws*1000/fs);
    i=1;
    W=round(ws/1000*fs);
    aux=0;
    while b<numel(licks)
        if n==1
            T(i)=aux+mean(b-a)/fs; % [Seconds]
            aux=T(i);
        end
        R(n,i)=sum(licks(a:b))/(ws/1000); % Hz
        b=b+W-round(ol/100*W);
        a=a+W-round(ol/100*W);
        if b>numel(licks)
            b=numel(licks);
        end
        i=i+1;
    end
    fprintf('done.');
end
fprintf('\n');