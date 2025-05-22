% this code read and plot behavioral data, and calculate % correct
% response, % wait during delay
% 1: rewards
% 2: movement
% 3: licks
% 4: punishment
% 5: stimuli: 1 Go, 2: NoGo
function [corr_lick,per_corr,total_water,dataout]=cal_performance_LCR(task)
%% process data

rewout = task(:,1);
rewout(find(rewout<2))=0;
rewout(find(rewout>2))=1;           % OUTPUT REWARD

punout = task(:,4);
punout(find(punout<1))=0; 
punout(find(punout>1))=1;           % OUTPUT PUNISHMENT

oriout = task(:,5);                 % OUPUT ORIENTATIONS

dataout.rew=rewout;
dataout.pun=punout;


oriout = roundn(oriout,-1);
for i = 1:length(oriout)
    if oriout(i)<0.2
        oriout(i)=0;
    else if oriout(i)>1.5
            oriout(i)=2;
        else
            oriout(i)=1;
        end
    end
end

dataout.ori=oriout;
% find trials when a mouse waited during delay

df_rew = diff(rewout);
df_pun = diff(punout);
df_ori = diff(oriout);
df_go = diff(oriout==1);
df_nogo = diff(oriout==2);

delay = 0; %input('delay (sec): '); % in sec
stimDur = 2; %input('stimulus dur (sec): '); % in sec
fdur = 0.033105888; % image frame duration
ephy_r = 1000; % ephys sampling rate

for i = 1:size(df_rew,1)
    if df_rew(i) < 0 % find indices for reward-on
        df_rew(i) = 0;
    end
    
    if df_pun(i) < 0 % find indices for pun-on
        df_pun(i) = 0;
    end
    
    if df_ori(i) > 0 % find indices for stim-off
        df_ori(i) = 0;
    end 
end

df_ori = abs(df_ori); % 1 when stim-off
pos_rew = find(df_rew); % indices for rewared trials    
pos_ori = find(df_ori); % indices for stim-off          
go_stim=find(df_go>0);
nogo_stim=find(df_nogo>0);

% find indices and orientation of rewarded stim 
ori_idx_rew = zeros(length(pos_rew),1); % indices for rewarded stim-off
tmp = [];
for i = 1:length(pos_rew)
    val = pos_rew(i);
    tmp = abs(pos_ori - val);
    [idx, idx] = min(tmp); % find presented stim before reward
    ori_idx_rew(i,1) = pos_ori(idx);
end
ori_rew = df_ori(ori_idx_rew); % orientations of rewarded stims

% find punished trials (but waited for a delay)
pos_all_pun = find(df_pun); % idx for all punished trials
ori_idx_pun = zeros(length(pos_all_pun),1);
pos_pun = zeros(length(pos_all_pun),1);
tmp = [];
for i = 1:length(pos_all_pun)
    val = pos_all_pun(i);
    tmp = abs(pos_ori - val); % # of frames between stim off and punishment
    if min(tmp)> delay*ephy_r % if punishment happens after the delay
    [idx, idx] = min(tmp); % find presented stim before punishment
    ori_idx_pun(i,1) = pos_ori(idx);
    pos_pun(i,1) = pos_all_pun(i,1);
    else
        continue
    end
end
pos_pun(pos_pun==0)=[];% idx for punished trials (but waited for a delay)
ori_idx_pun(ori_idx_pun==0)=[]; % idx for visual stim-off for punished trials(but waited for a delay)
ori_incorr = df_ori(ori_idx_pun); % orientation of punished stims (waited for a delay)

% parameters to save
% per_corr = (length(pos_rew)/(length(pos_rew)+ length(pos_pun)))*100;
hit_per=(length(pos_rew)/length(go_stim))*100;
false_per=(length(pos_all_pun)/length(nogo_stim))*100;
per_corr = hit_per-false_per;
% per_wait = ((length(pos_rew)+length(pos_pun))/length(pos_ori))*100;
%corr_r = (length(find(ori_rew==2))/length(ori_rew))*100;
corr_lick = (length(find(ori_rew==1))/length(go_stim))*100;
total_water = length(pos_rew)*4;
% save('task_performance','corr_lick','per_corr','total_water')
disp(corr_lick)
disp(per_corr)
disp(total_water)