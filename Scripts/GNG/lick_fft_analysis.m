% function [stim_frec,frec_pow,stimPSD]=lick_fft_analysis(parceled_matrix,SpectTitle,stimColor)
function [stim_frec,frec_pow,stimPSD,fs]=lick_fft_analysis(parceled_matrix,FreqsVec,stimColor,nameFig)
lower_frec=2;
upper_frec=20;
matrix_transposed=parceled_matrix';
data_parcel_vector=reshape(matrix_transposed,[],1)';
X=data_parcel_vector;
L=size(X,2);
Fs=1000;
% f = Fs*(0:(L/2))/L; %Rango de despliegue de frecuencias L
% lower_frec_position=find(f>=lower_frec-.05 & f<=lower_frec+.12);
% lower_frec_position=min(lower_frec_position);
% upper_frec=20;
% upper_frec_pos=find(f>=upper_frec-.05 & f<=upper_frec+.1);
% upper_frec_pos=min(upper_frec_pos);
% go_upper_frec_pos=find(fgo==upper_frec);
% Y = fft(X);
% P2 = abs(Y)/L;
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% Y=fft(X);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% stimPSD= lowpass_filter_signals_LCR(P1,.02);
frecbyRes=FreqsVec;
% [t,fs] = pwelch(X,2048,256,frecbyRes,Fs);
[t,fs] = pwelch(X,round(length(X)*.10),round(length(X)*.01),frecbyRes,Fs);
lower_frec_position=find(fs>=lower_frec-.05 & fs<=lower_frec+.1);
% lower_frec_position=find(f>=lower_frec-.05 & f<=lower_frec+.05);
lower_frec_position=min(lower_frec_position);
upper_frec=20;
upper_frec_pos=find(fs>=upper_frec-.05 & fs<=upper_frec+.1);
% upper_frec_pos=find(f>=upper_frec-.05 & f<=upper_frec+.05);
upper_frec_pos=min(upper_frec_pos);
stimPSD=lowpass_filter_signals_LCR(t,1/Fs);
maxP=max(stimPSD);
% stimPSD=stimPSD/maxP(1);
% plot(fs,t), hold on
psdfig=figure(3e3); hold on
% plot(fs,log(stimPSD),'Color',stimColor);
% plot(fs(lower_frec_position:upper_frec_pos),log(stimPSD(lower_frec_position:upper_frec_pos)),'Color',stimColor);
plot(fs(lower_frec_position:upper_frec_pos),stimPSD(lower_frec_position:upper_frec_pos),'Color',stimColor);
axis tight
xlabel('Frequency (Hz)')
% ylabel('Power/Frequency(dB/Hertz)')
ylabel('Power (a.u.)')
% print(psdfig,nameFig,'-depsc')
%%
% lower_frec_position=find(f==lower_frec);
% upper_frec_pos=find(f==upper_frec);

% sp=figure;
% % subplot(211)
% plot(f(lower_frec_position:end-1),10*log10(P1(lower_frec_position:end-1)),stimColor)
% hold on

% stimPSD= lowpass_filter_signals_LCR(P1,.001);
% plot(f(lower_frec_position:upper_frec_pos),(stimPSD(lower_frec_position:upper_frec_pos)))
% plot(f(lower_frec_position:),10*log10(stimPSD(lower_frec_position:end-1)))
% xlabel('Frequency (Hz)'), ylabel ('Power (dB)')
% title(SpectTitle)
[frec_pow,f_pos]=max(stimPSD);
stim_frec=fs(f_pos);
% subplot(211)
% plot(f(f_pos+lower_frec_position-1),10*log10(frec_pow),'ko')
% print(sp,[SpectTitle '.pdf'],'-dpdf')
% print(sp,'-painters','-depsc2',SpectTitle)


% try
%     nogo_transposed=parceled_matrix_nogo';
%     data_parcel_nogo_vector=reshape(nogo_transposed,[],1)';
%     X=data_parcel_nogo_vector;
%     L=size(X,2);
%     Fs=1000;
%     fnogo = Fs*(0:(L/2))/L; %Rango de despliegue de frecuencias L
%     nogo_lower_frec_position=find(fnogo==lower_frec);
%     % nogo_upper_frec_pos=find(fnogo==upper_frec);
%     Y = fft(X);
%     P4 = abs(Y)/L;
%     P3 = P4(1:L/2+1);
%     P3(2:end-1) = 2*P3(2:end-1);
% end
% 
% try
%     subplot(212)
%     plot(fnogo(nogo_lower_frec_position:end-1),10*log10(P3(nogo_lower_frec_position:end-1)),'r')
%     hold on
%     nogoPSD = lowpass_filter_signals_LCR(P3,0.05);
%     plot(fnogo(nogo_lower_frec_position:end-1),10*log10(nogoPSD(nogo_lower_frec_position:end-1)))
%     xlabel('Frequency (Hz)'), ylabel ('Power (dB)')
%     title(SpectTitle)
% end
% 
% 
% try
%     [nogo_pow,f_pos]=max(nogoPSD(nogo_lower_frec_position:end));
%     nogo_f=fnogo(f_pos+nogo_lower_frec_position-1);
%     subplot(212)
%     plot(fnogo(f_pos+nogo_lower_frec_position-1),10*log10(nogo_pow),'ko')
% end
% frec_cut=f(lower_frec_position:upper_frec_pos);
% spect_cut_go=goPSD(go_lower_frec_position:go_upper_frec_pos);
% go_spect=spect_cut_go/max(spect_cut_go);
% cum_go_spect=cumsum(spect_cut_go)/max(cumsum(spect_cut_go));
