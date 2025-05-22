%% ALl Session-METRICS by ANIMAL
% Read Animal Folder obained by GETRASTER

[f,d]=uigetfile({'*.mat'},'Files','MultiSelect','on');
N=size(f,2);
% Colors:
CM =cbrewer('seq','PuBu',N);
%% Read .mat files from directory
Asess=[]; % Trans-Matrix
DISTANCE=[];
ENTROPY=[];
ENTROPYRATE=[];
ALLSTIMS=[];
HITS=[];
FAS=[];
PERFS=[];
ACall=[];
figure;
% hold on;
% grid on;
for i=1:N
    load([d,f{i}]); % load varaibles
%     Asess(i,:)=[A(1),A(2),A(3),A(4)];
%     ENTROPY=[ENTROPY;Entrpy];
%     ENTROPYRATE=[ENTROPYRATE;Hrate];
%     [GN,~,G]=unique(STIMRESPONSE(:,1));
%     Gbin=G-1;
%     [AC,LAG]=autocorr(Gbin,50);
%     ACall=[ACall,AC];

%     ALLSTIMS=[ALLSTIMS,Gbin];
%     % Hits
%     HITS=[HITS,OUTPUT.InstaHitsc];
%     % FA
%     FAS=[FAS,OUTPUT.InstaFAc];
    % Performance
    if size(OUTPUT.InstaPerfor,1)==size(PERFS,1)
        PERFS=[PERFS,OUTPUT.InstaPerfor];
    end
    
    plot(OUTPUT.InstaPerfor,'Color',CM(i,:)); hold on;
    % plot(OUTPUT.InstaFAc,'r'); 
    % pause;
end
axis([0 200 -100 100])
t=title(MouseName);
t.Interpreter='none';
fprintf('completed\n')

% %figure;
% EB=errorbar(1:200,mean(ENTROPYRATE,1,'omitnan'),std(ENTROPYRATE,1,'omitnan'),'CapSize',0);
% EB.Color='green';

% bar(LAG,mean(ACall,2,'omitnan'),'green'); hold on;
% EB=errorbar(LAG,mean(ACall,2,'omitnan'),std(ACall'),'CapSize',0);
% EB.Color='green';

%% Accumulate/Avergae Metrics
% disp(mean(Asess,3));
% 
% stem(Gbin)
% 
% plot(mean(ENTROPY',2));
% 
% plot(mean(ENTROPYRATE));
% 
% SIMSTIMSESS = squareform(1-pdist(ALLSTIMS','hamming'));
% D=diag(SIMSTIMSESS);
% UpMat = [D.', squareform((SIMSTIMSESS-diag(D)).')];
% 
% histogram(UpMat(N+1:end) );
% 
% InterSessSim=diag(SIMSTIMSESS,1);
% plot(2:numel(InterSessSim)+1,InterSessSim)
% ylabel('Simmilarity withprevious session')
% xlabel('Session')
% 
% %% Save Animal Profile
% % Add MAT info into mat from 'GoNoGo_Previewer'
% %% Save Table-Data