% function [go_time,nogo_time,go_frecs,nogo_frecs,power_go_frecs,power_nogo_frecs,data_parcel_go,data_parcel_nogo,goPSD,nogoPSD]=lick_parcel_gimc(vis_data,data,period_time)
% function [go_time,nogo_time,data_parcel_go,data_parcel_nogo,go_pow,go_f,nogo_pow,nogo_f,goPSD,nogoPSD,cum_go_spect]=lick_parcel_gimc(vis_data,data,period_time,t_pre)
function [all_data_parceled,data_parcel_go,data_parcel_nogo,treadmill_go,treadmill_nogo,RTs]=...
    lick_parcel_LCR(pos_ori,corrected_licks,time_before,dif_times,go_posts,nogo_posts,treadmill)
%   Finds the onset of visual stimuli and parcelate the data time t_pre(ms) before and
%   after time t_post(ms) after the onset of stimuli for two orientations go=1 nogo=2

Fs=1e3;
maxT=round(max(dif_times)/Fs)*Fs+time_before;
all_data_parceled=zeros(size(dif_times,1), maxT);
treadcols=max(mean(dif_times));
treadmill_all=zeros(size(dif_times,1),round(treadcols));
for n=1:size(dif_times,1)
    try
        lickT=corrected_licks(pos_ori(n)-time_before:(pos_ori(n)+floor(dif_times(n)/1e3)*1e3)-1)';
        if length(lickT)> maxT
            lickT=lickT(1:maxT);
        end
        all_data_parceled(n,1:length(lickT))=lickT;
        treadmill_trial=treadmill(pos_ori(n)-time_before:pos_ori(n)+floor(dif_times(n)/1e3)*1e3);
        treadmill_all(n,1:length(treadmill_trial))=treadmill_trial;
        RTs(n,1)=max(min(find(corrected_licks(pos_ori(n):pos_ori(n)+floor(dif_times(n)/1e3)*1e3)>0)));
    catch
        %         lickRems=1e4-
        lickT=corrected_licks(pos_ori(n)-time_before:end);
        if length(lickT)> maxT
            lickT=lickT(1:maxT);
        end
        all_data_parceled(n,1:length(lickT))=lickT;
        treadmill_trial=treadmill(pos_ori(n)-time_before:end);
        treadmill_all(n,1:length(treadmill_trial))=treadmill_trial;
        RTs(n,1)=nan;
    end
end




data_parcel_go=all_data_parceled(go_posts,:);
data_parcel_nogo=all_data_parceled(nogo_posts,:);
treadmill_go=treadmill_all(go_posts,:);
% absTr_go=abs(round(treadmill_go,2));
% for t=1:size(treadmill_go)
%     sin_tr_go(t,1:length(absTr_go(t,:)))=2*pi*cos(absTr_go(t,:));
% end
treadmill_nogo=treadmill_all(nogo_posts,:);
% absTr_nogo=abs(treadmill_nogo);
% for t=1:size(treadmill_nogo)
%     sin_tr_nogo(t,1:length(absTr_nogo(t,:)))=2*pi*cos(absTr_nogo(t,:));
% end

%%
% data_parcel_go=zeros(size(go_stim,1),t_pre+max(times_go));
% data_parcel_nogo=zeros(size(nogo_stim,1),t_pre+max(times_nogo));


% for n=1:size(go_stim,1)
%     lickTrial=lickData(go_stim(n)-1-t_pre:go_stim(n)-1+times_go(n));
%     data_parcel_go(n,1:length(lickTrial))=lickTrial;
% end
%
% for n=1:size(nogo_stim,1)
%     lickTrial=lickData((nogo_stim(n)+1)-t_pre:nogo_stim(n)+times_nogo(n));
%     data_parcel_nogo(n,1:length(lickTrial))=lickTrial;
% end
%% previous fft
% go_transposed=data_parcel_go';
% data_parcel_go_vector=reshape(go_transposed,[],1)';
% X=data_parcel_go_vector;
% L=size(X,2);
% Fs=1000;
% f = Fs*(0:(L/2))/L; %Rango de despliegue de frecuencias L
% Y = fft(X);
% P2 = abs(Y)/L;
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
%
%
% nogo_transposed=data_parcel_nogo';
% data_parcel_nogo_vector=reshape(nogo_transposed,[],1)';
% X=data_parcel_nogo_vector;
% % L=size(X,2);
% Fs=1000;
% f = Fs*(0:(L/2))/L; %Rango de despliegue de frecuencias L
% Y = fft(X);
% P4 = abs(Y)/L;
% P3 = P4(1:L/2+1);
% P3(2:end-1) = 2*P3(2:end-1);
% lower_frec=1;
% upper_frec=20;
% lower_frec_position=find(f==lower_frec);
% upper_frec_pos=find(f==upper_frec);
%
% sp=figure;
% subplot(211)
% plot(f(lower_frec_position:end),10*log10(P1(lower_frec_position:end)),'g-')
% hold on
% goPSD= lowpass_filter_signals_LCR(P1,0.05);
% plot(f(lower_frec_position:end),10*log10(goPSD(lower_frec_position:end)))
% xlabel('Frequency (Hz)'), ylabel ('Power (dB)')
%
% subplot(212)
% plot(f(lower_frec_position:end),10*log10(P3(lower_frec_position:end)),'r')
% hold on
% nogoPSD = lowpass_filter_signals_LCR(P3,0.05);
% plot(f(lower_frec_position:end),10*log10(nogoPSD(lower_frec_position:end)))
% xlabel('Frequency (Hz)'), ylabel ('Power (dB)')
%
% [go_pow,f_pos]=max(goPSD(lower_frec_position:end));
% go_f=f(f_pos+lower_frec_position-1);
% subplot(211)
% plot(f(f_pos+lower_frec_position-1),10*log10(go_pow),'ko')
% [nogo_pow,f_pos]=max(nogoPSD(lower_frec_position:end));
% nogo_f=f(f_pos+lower_frec_position-1);
% subplot(212)
% plot(f(f_pos+lower_frec_position-1),10*log10(nogo_pow),'ko')
% frec_cut=f(lower_frec_position:upper_frec_pos);
% spect_cut_go=goPSD(lower_frec_position:upper_frec_pos);
% go_spect=spect_cut_go/max(spect_cut_go);
% cum_go_spect=cumsum(spect_cut_go)/max(cumsum(spect_cut_go));
% print(sp,'spects.pdf','-dpdf')
% saveas(sp,'spects','png')

% figure
% plot(frec_cut,cum_go_spect), hold on
% plot(frec_cut,go_spect)

%
% signal_periods=t_post/period_time; time_fft=period_time;
% p=1; q=1;
% % figure
% for period=1:signal_periods
%     time_to_analyze=q:time_fft;
%     [lick_freq_fft,lick_f_power]=lick_fft(time_to_analyze,data_parcel_go,period_time);
%     if lick_freq_fft
%         go_frecs(period)=lick_freq_fft;
%         power_go_frecs(period)=lick_f_power;
%     else
%         go_frecs(period)=0;
%         power_go_frecs(period)=0;
%     end
%     q=q+period_time;
%     time_fft=time_to_analyze(end)+period_time;
%
% end
% EPS_figure(0+period_time/Fs:period_time/Fs:t_post/Fs,go_frecs,'Time (s)','Freq (Hz)')
% % EPS_figure(0+period_time/Fs:period_time/Fs:t_post/Fs,power_go_frecs,'Power (Hz)','Time (s)')
% % figure
% signal_periods=t_post/period_time; time_fft=period_time;
% p=1; q=1;
% for period=1:signal_periods
%     time_to_analyze=q:time_fft;
%     [lick_freq_fft,lick_f_power]=lick_fft(time_to_analyze,data_parcel_nogo,period_time);
%     if lick_freq_fft
%         nogo_frecs(period)=lick_freq_fft;
%         power_nogo_frecs(period)=lick_f_power;
%     else
%         nogo_frecs(period)=0;
%         power_nogo_frecs(period)=0;
%     end
%     q=q+period_time;
%     time_fft=time_to_analyze(end)+period_time;
%
% end
% EPS_figure(0+period_time/Fs:period_time/Fs:t_post/Fs,nogo_frecs,'Time (s)','Freq (Hz)')
%%
% EPS_figure(0+period_time/Fs:period_time/Fs:t_post/Fs,power_nogo_frecs,'Power (Hz)','Time (s)')

% Fs=1e3;
% trial_time=period_time/Fs:(period_time/Fs):8;
% freq_time=figure;
% plot(trial_time,go_frecs,'g.-'), hold on
% plot(trial_time,nogo_frecs,'r.-')
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% % pwr_fig=figure;
% plot(trial_time,power_go_frecs*100,'c.-')
% plot(trial_time,power_nogo_frecs*100,'m.-')
% xlabel('Time (s)')
% ylabel('Power (dB)')
% legend({'Hz over time (Go)', 'Hz over time (No-Go)','Power of frecs over time (Go, multiplied by 100)', 'Power of frecs over time (No-Go, multiplied by 100)'})
% legend('boxoff')
%
% saveas(freq_time,'Freq_Time','png')
% saveas(pwr_fig,'Freq_power','png')



% figure
% plot(sum(data_parcel_go))
% hold on
% plot(sum(data_parcel_nogo))
% hold off



