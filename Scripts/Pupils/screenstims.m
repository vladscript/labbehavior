function [FranesStim,FranesScreen,STIM_INTER]=screenstims(fs_exp,v,ws)
% VARIANCE SIGNAL $$$
%H=histogram(v);
[~,BinEdges]=histcounts(v);
AmpMin=BinEdges(find(BinEdges>0,1));

SS=zeros(size(v));
SS(v>AmpMin)=1;         % Threshold of variance
dSS=derifilter(SS);     % WHOLE SIGNAL

[~,PosPeak]=findpeaks(dSS);
[~,NegPeak]=findpeaks(-dSS);

% figure;
% plot(1:numel(s_exp),s_exp);
% hold on;
% plot(1:numel(v),v);
% plot(1:numel(fs_exp),fs_exp);
% Ax=gca;

% INTERVALS
STIM_INTER=[];
for n=1:numel(PosPeak)
    A=PosPeak(n)+ws;
    B=NegPeak(find(NegPeak>A,1));
    % Ax.XLim=[A,B];
    % Interval Start   
    aux=1;
    while abs(fs_exp(A))>=abs(fs_exp(A-aux))
        A=A-aux;
        aux=aux+1;
        fprintf('.')
        if rem(7,aux)==0
            fprintf('\n')
        end
    end
    aux=1;
    while v(B)>=v(B+aux)
        B=B+aux;
        aux=aux+1;
        fprintf('.')
        if rem(7,aux)==0
            fprintf('\n')
        end
    end
    % SAVE
    STIM_INTER=[STIM_INTER;A,B];
%     pause
end
DUR=STIM_INTER(:,2)-STIM_INTER(:,1);

% CHECK & FILTER $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% figure;
% plot(1:numel(s_exp),s_exp);
% hold on;
% Stim_Length=mode(DUR);
FranesStim=[];
for n=1:numel(PosPeak)
    A=STIM_INTER(n,1);
    B=STIM_INTER(n,2);
    xs=fs_exp(A:B);
%     plot(A:B,s_exp(A:B),'*k')
    FranesStim=[FranesStim,A:B];
end

FranesScreen=setdiff(1:numel(fs_exp),FranesStim);

% GET CDF s of relational size (%)
% no stim:  white screen
% stim:     bars
% Displacement

% absds=abs(ds);
% Nenv=9;
% [up1,lo1] = envelope(absds,Nenv,'peak');
