function OUTPUT=winperfor(STIMRESPONSE, ifplot)
fprintf('>Checking Performance Metrics')
% if isempty(varargin)
%     StrialsIn=10;
% else
%     StrialsIn=varargin{1};
% end
Ntrials=size(STIMRESPONSE,1);
%% Global Metrics
% %Performance = %Hits - %FA
H=round(100*sum(STIMRESPONSE(:,2)=='Hit')/(sum(STIMRESPONSE(:,2)=='Hit')+sum(STIMRESPONSE(:,2)=='Miss')));
FA=round(100*sum(STIMRESPONSE(:,2)=='FA')/(sum(STIMRESPONSE(:,2)=='FA')+sum(STIMRESPONSE(:,2)=='CR')));
P=H-FA;
fprintf('\nChecking arduinos data:\n>Hits: %i \n>FA: %i \n>Performance: %i\n',H,FA,P);
OUTPUT.P=P;
OUTPUT.FA=FA;
OUTPUT.H=H;
%% Time Accumulative
SumHits=cumsum(STIMRESPONSE(STIMRESPONSE(:,1)=='Go',2)=='Hit');
SumFA=cumsum(STIMRESPONSE(STIMRESPONSE(:,1)=='NoGo',2)=='FA');
% SumP=round(100*(SumHits./(1:numel(SumHits))'-SumFA./(1:numel(SumFA))'));
% Phits=round(100*(SumHits./(1:numel(SumHits))'));
% Pfa=100*(SumFA./(1:numel(SumFA))');

CumRes=STIMRESPONSE(:,2);
CumSti=STIMRESPONSE(:,1);

InstaHits=0;
InstaMisses=0;
InstaCRs=0;
InstaFAs=0;
InstaPerfomances=zeros(Ntrials, 1);
InstaHitsOK=zeros(Ntrials, 1);
InstaFAsOK=zeros(Ntrials, 1);
for i=1:Ntrials
    cs=CumSti(i);   % Stimulus
    cr=CumRes(i);   % Response
    if cs=='Go'
        if cr=='Hit'
            InstaHits=InstaHits+1;
        else % Miss
            InstaMisses=InstaMisses+1;
        end
    else % No Go
        if cr=='CR'
            InstaCRs=InstaCRs+1;
        else % FA
            InstaFAs=InstaFAs+1;
        end
    end
    % Hits - % FA
    Nhits=sum(CumSti(1:i)=='Go');
    if Nhits==0
        pHits=0;
    else
        pHits=InstaHits/sum(CumSti(1:i)=='Go');
    end
    Nfas=sum(CumSti(1:i)=='NoGo');
    if Nfas==0
        pFAs=0;
    else
        pFAs=InstaFAs/sum(CumSti(1:i)=='NoGo');
    end
    InstaPerfomances(i)=pHits-pFAs;
    InstaHitsOK(i)=pHits;
    InstaFAsOK(i)=pFAs;
    OUTPUT.InstaHitsc=round(100*InstaHitsOK);
    OUTPUT.InstaFAc=round(100*InstaFAsOK);
    OUTPUT.InstaPerfor=round(100*InstaPerfomances);
    % Performance Instnaneous Ghange Analysis
    dP=derifilter(round(100*InstaPerfomances));
    OUTPUT.DeltaPerfo=dP;

end

if ifplot

    figure
    subplot(211); 
    hold on;
    plot(round(100*InstaPerfomances),'LineWidth',2); 
    plot(round(100*InstaHitsOK),'LineWidth',2); 
    plot(round(100*InstaFAsOK),'LineWidth',2,'Color','green'); 
    plot([1,numel(InstaFAsOK)],[75 75],'LineStyle','-.')
    
    legend('Performance','Hits','FA')
    ylabel('%')
    
    hold off;
    axis([0 numel(InstaPerfomances) min([0, min(round(100*InstaPerfomances))]) 100]); 
    grid on;
    
    
    subplot(212)
    plot(dP,'LineWidth',2,'Color','k')
    grid on;
    hold on
    ylabel('\Delta Performance')
    [~,locs,~,p]=findpeaks(dP);
    [Npeaks,pIndx]=find(p==max(p));
    BestTrials=[];
    for n=1:numel(Npeaks)
        a=locs(Npeaks(n));
        aux=1;
        while a-aux<1
            if dP(a-aux)<dP(a)
                a=a-aux;
            end
        end
        BestTrials=[BestTrials,a:locs(Npeaks(n))];
        plot(a:locs(Npeaks(n)), dP(a:locs(Npeaks(n))),'y','LineWidth',2)
    end
    xlabel('Trials')
end
%%

% fprintf('Peaks @ Instantaneous:\n>Hits: %i \n>FA: %i \n>Performance: %i\n',max(round(100*InstaHitsOK)),max(round(100*InstaFAsOK)),max(round(100*InstaPerfomances)));
% BestHittrials=find(round(100*InstaHitsOK)==max(round(100*InstaHitsOK)));
% LasBestHit=BestHittrials(end);
% WorstFatrials=find(round(100*InstaFAsOK)==max(round(100*InstaFAsOK)));
% LasWostFa=WorstFatrials(end);
% BesstPertrials=find(round(100*InstaPerfomances)==max(round(100*InstaPerfomances)));
% LasBestPer=BesstPertrials(end);
% fprintf('Last Best trials @ TRIALS \n>Hits: %i \n>FA: %i \n>Performance: %i\n',LasBestHit,LasWostFa,LasBestPer);
%% Sliding Instantaneous
% SW=[round(StrialsIn/2),StrialsIn,round(StrialsIn*2)];
% % figure;
% subplot(212)
% for s=1:numel(SW)
%     Strials=SW(s);
%     Pw=[];
%     for i=1:Ntrials
%         aux=1;
%         if i<=Ntrials-Strials
%             R=STIMRESPONSE(i:i+Strials-1,2);
%             S=STIMRESPONSE(i:i+Strials-1,1);
%         else
%             R=STIMRESPONSE(end-Strials+1:end,2);
%             S=STIMRESPONSE(end-Strials+1:end,1);
%         end
%         Hw=round(100*sum(R=='Hit')/(sum(S=='Go')));
%         FAw=round(100*sum(R=='FA')/(sum(S=='NoGo')));
%         Pw(i)=Hw-FAw;
%     end
%     OUTPUT.InstaPerf{s}=Pw;
%     plot(Pw,'LineWidth',2); hold on;
%     [BestPerf(s),BestTrial(s)]=max(Pw);
% end
% axis tight; grid on;
% [GoodPerf,SSindx]=max(BestPerf);
% % BestInterval=BestTrial(SSindx):BestTrial(SSindx)+SW(SSindx)-1;
% fprintf('Best instant interval doing a %i%% performance :\n> From trial %i to %i',GoodPerf,BestTrial(SSindx),BestTrial(SSindx)+SW(SSindx)-1)
% %% Fixed Windows
% R=STIMRESPONSE(:,2);
% S=STIMRESPONSE(:,1);
% OL=0.5; % Overlapping
% a=1;
% b=StrialsIn;
% posx=[];
% aux=1;
% Pwind=[];
% while b<numel(S)
%     r=R(a:b);
%     Pwind(aux)=sum(r=='Hit')/StrialsIn-sum(r=='FA')/StrialsIn;
%     posx=[posx,round(mean([a,b]))];
%     a=round(a+StrialsIn*OL);
%     b=round(b+StrialsIn*OL);
%     if b>numel(S)
%         b=numel(S);
%     end
%     aux=aux+1;
% end
% OUTPUT.WinPerX=posx;
% OUTPUT.WinPerX=round(100*Pwind);
% bar(posx,round(100*Pwind)); hold off;
% legend(sprintf('Slide: %i',SW(1)),sprintf('Slide: %i',SW(2)),sprintf('Slide: %i',SW(3)),sprintf('Fixed: %i',StrialsIn))
% ylabel('Performance %')
% xlabel('Trials')
% [Bperfo,IndexPerfo]=max(round(100*Pwind));
% fprintf('\n Best window of %i trials:\n> %i%% performace in trials from %i to %i',StrialsIn,Bperfo,round(posx(IndexPerfo)-StrialsIn/2),round(posx(IndexPerfo)+StrialsIn/2))