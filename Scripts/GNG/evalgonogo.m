%% Stims and Respones Intel
function STIMRESPONSE=evalgonogo(dataperf)
fprintf('Searching performance')
STIMRESPONSE=categorical();
%%
% Chngs=find(diff(dataperf.ori));
% Stims=Chngs(1:2:end);
Stims=[find(diff(dataperf.ori)>0);numel(dataperf.ori)];
for i=1:numel(Stims)-1
    a=Stims(i);
    b=Stims(i+1)-1;
    StimWindow=dataperf.ori(a:b);
    RewAns=dataperf.rew(a:b);
    PunAns=dataperf.pun(a:b);
    % Stim
    % WinStim=unique(StimWindow(StimWindow>0));
    WinStim=max(StimWindow);
    % Respoonse
    WinHit=unique(RewAns(RewAns>0));
    WinFA=unique(PunAns(PunAns>0));
    % 1 is Go
    % 2 is No Go
    if numel(WinStim)~=1
        disp('PROBLEM')
    end
    
    if WinStim==1 %% GO       
        STIMRESPONSE(i,1)='Go';
        if isempty(WinHit)
            STIMRESPONSE(i,2)='Miss';
        else
            STIMRESPONSE(i,2)='Hit';
        end
    elseif WinStim==2
        STIMRESPONSE(i,1)='NoGo';
        if isempty(WinFA)
            STIMRESPONSE(i,2)='CR';
        else
            STIMRESPONSE(i,2)='FA';
        end
    else

    end
end

%%
% figure
% ax1=subplot(311)
% plot(dataperf.rew); hold on;
% stem(Stims,ones(size(Stims)),'r','Marker','.'); hold off;
% ax2=subplot(312)
% plot(dataperf.pun); hold on;
% stem(Stims,ones(size(Stims)),'r','Marker','.'); hold off;
% ax3=subplot(313)
% plot(dataperf.ori); hold on;
% stem(diff(dataperf.ori),'r','Marker','.'); hold off;
% 
% linkaxes([ax1,ax2,ax3],'x');