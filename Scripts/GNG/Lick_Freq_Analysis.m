%% Freq Analysis
function  [G_Frecs_rep]=Lick_Freq_Analysis(bin_data,lick_bin,nmeG)
% close all
forfigs='-depsc';
% Secs_previous_MaxLick=0;
% Secs_previous_MaxLick=Secs_previous_Ana;
% Secs_previous_MaxLick=1e3;
% maxptNG=CoeffRTNG.coeff_Gauss_NG(1);
% maxptG=axxx(binsNoGo==max(binsNoGo));
% maxptG=maxptG(1);
% 
% if maxptG-axxx(end)==0
% %     maxptNG=CoeffRTNG.coeff_Gauss_NG(1);
%     point_4_Frec_Ana=(maxptG-Secs_previous_MaxLick)+time_before;
%     bin_data_go=data_parcel_go(:,point_4_Frec_Ana+1:maxptG+time_before);
% elseif maxptG < 0
%         bin_data_go=data_parcel_go(:,1:Secs_previous_MaxLick);
% else
%     point_4_Frec_Ana=(maxptG)+time_before;
%     bin_data_go=data_parcel_go(:,point_4_Frec_Ana-Secs_previous_MaxLick+1+lick_bin:point_4_Frec_Ana+Secs_previous_MaxLick+lick_bin);
% end
% 
% 
% 
% %%
% maxptNG=axxx(binsNoGo==max(binsNoGo));
% maxptNG=maxptNG(1);
% 
% if maxptNG-axxx(end)==0
% %     maxptNG=CoeffRTNG.coeff_Gauss_NG(1);
%     point_4_Frec_Ana=(maxptNG-Secs_previous_MaxLick)+time_before;
%     bin_data_nogo=data_parcel_nogo(:,point_4_Frec_Ana+1:maxptNG+time_before);
% elseif maxptNG <0
%         bin_data_nogo=data_parcel_nogo(:,1:Secs_previous_MaxLick);
% else
%     point_4_Frec_Ana=(maxptNG)+time_before;
%      bin_data_nogo=data_parcel_nogo(:,point_4_Frec_Ana-Secs_previous_MaxLick+1+lick_bin:point_4_Frec_Ana+Secs_previous_MaxLick+lick_bin);
% end
% 
% bin_data_go
%%
clear PSDs
clear noPSDs

%         bin_data_go=data_go;
% bin_data=bin_data_go;
% lick_bin=lick_bin;
FrecSpect=1e3;
%         segsPre=segsPre*1e3;
times4FFT=round(size(bin_data,2)/lick_bin);

ini=1;
firs=1;
go_frec_pow=zeros(1,times4FFT);
go_frec=zeros(1,times4FFT);
%         clear go_frec
%         clear go_frec_pow
%         clear PSDs
%         clear P1
fss=[2:.01:20];
Fs=1e3;
colorPSD=256/times4FFT;

for ms=1:times4FFT
    try
        [go_frec(ms),go_frec_pow(ms),PSDs(ms,:),fs]=lick_fft_analysis...
            (bin_data(:,firs+1:firs+lick_bin),fss,[0 (ms*colorPSD/256) 0]...
            ,['PSD (Go stimulus) ' nmeG]);
        %             ms=ms+1;
        %             firs=firs+lick_bin;
    catch
        %                 ms=ms+1;
        rems=length(bin_data(:,firs:end));
        if rems>0
            %                     rems=1e3;
            [go_frec_rems,go_frec_pow_rems,PSDs_rems,fs_rems]=lick_fft_analysis...
                (bin_data(:,firs:end),fss,[0 (ms*colorPSD/256) 0],['PSD (Go stimulus) ' nmeG]);
            PSDs(ms,1:length(PSDs_rems))=PSDs_rems;
        end
        %                 [go_frec_rems,go_frec_pow_rems,PSDs_rems,fs_rems]=lick_fft_analysis(data_go(:,firs+1:end),fss,[0 (100+(ms*10))/256 0],'PSD (Go stimulus)');
        %                 [go_frec(ms+1),go_frec_pow(ms+1),PSDs(ms+1,:),fs]=lick_fft_analysis(data_parcel_go(:,firs+1:firs+rems),fss,[0 (100+(ms*10))/256 0],'PSD (Go stimulus)');
        
    end
    %             ,...
    %                 ['Spectrogram for Go trials (' [num2str((ms-1)*lick_bin/1e3) '-' num2str((ms*lick_bin)/1e3)] ' s)'],'g');
    firs=firs+lick_bin;
end
% fi=applytofig(gcf,'FontMode','scaled','FontSize','1','Color','cmyk','width',4,'height',2,'linewidth',.15);
% print(gcf,['PSD (Go stimulus) ' nmeG],'-depsc')
% s        specSurf(PSDs,fs,lick_bin,'Go',summer)
bands=2:10;
try
    p1=find(fs==(bands(1)));
    p2=find(fs==(bands(end)));
    frs=fss(p1:p2);
    GAna='regular';
    GPSDs=PSDs(p1:p2);
catch
    p1=find(fs_rems==(bands(1)));
    p2=find(fs_rems==(bands(end)));
    frs=fs_rems(p1:p2);
    GPSDs=PSDs_rems(p1:p2);
    
    GAna='rems';
end
% print(gcf,'Spectra ','-depsc')
GoFsAv=PSDs(:,p1:p2);
MatFs=[go_frec go_frec_rems go_frec_pow go_frec_pow_rems];
G_Frecs_rep=MatFs(MatFs>0);
% fi=applytofig(gcf,'FontMode','scaled','FontSize','1','Color','cmyk','width',4,'height',2,'linewidth',.15);
print(gcf,['PSD_' nmeG],forfigs)
%         GoFsAv=GoFsAv';
%         meanGoPows=mean(GoFsAv);
%         GoRelChange=mean(GoFsAv);
%         GoRelChange=GoRelChange/GoRelChange(1);
%         GoRelChange=GoRelChange-GoRelChange(1);
%         [go_frec,go_frec_pow,goPSD]=lick_fft_analysis(data_parcel_go,'Spectrogram for Go trials','g');
%         [go_pow,go_f,nogo_pow,nogo_f,goPSD,nogoPSD]=lick_fft_analysis...
%         lick_bin=lick_bin;
%% NOGO Spect
%         clear nogo_frec
%         clear nogo_frec_pow
%         clear noPSDs
%         clear noPSDs_rems
%         clear noP1
try
bin_data_=bin_data_nogo;
%         bin_data=bin_data_nogo;
lick_bin=lick_bin;
time_before=time_before;
times4FFT=round(size(bin_data_,2)/lick_bin);
colorPSD=256/times4FFT;
ini=1;
firs=1;
nogo_frec_pow=zeros(1,times4FFT);
nogo_frec=zeros(1,times4FFT);
for ms=1:times4FFT
    try
        [nogo_frec(ms),nogo_frec_pow(ms),noPSDs(ms,:),nofs]=...
            lick_fft_analysis(bin_data_(:,firs+1:firs+lick_bin),fss,[(ms*colorPSD/256) 0 0],['PSD (No-Go stimulus) ' nmeNG]);
        %             ms=ms+1;
        %             firs=firs+lick_bin;
    catch
        %                 ms=ms+1;
        rems=length(bin_data(:,firs:end));
        if rems>0
            %                     rems=1e3;
            [nogo_frec_rems,nogo_frec_pow_rems,noPSDs_rems,nofs_rems]=lick_fft_analysis...
                (bin_data_(:,firs:end),fss,[(ms*colorPSD/256) 0 0],['PSD (No-Go stimulus) ' nmeNG]);
            noPSDs(ms,1:length(noPSDs_rems))=noPSDs_rems;
        end
        %                 [go_frec_rems,go_frec_pow_rems,PSDs_rems,fs_rems]=lick_fft_analysis(data_go(:,firs+1:end),fss,[0 (100+(ms*10))/256 0],'PSD (Go stimulus)');
        %                 [go_frec(ms+1),go_frec_pow(ms+1),PSDs(ms+1,:),fs]=lick_fft_analysis(data_parcel_go(:,firs+1:firs+rems),fss,[0 (100+(ms*10))/256 0],'PSD (Go stimulus)');
        
    end
    %             ,...
    %                 ['Spectrogram for Go trials (' [num2str((ms-1)*lick_bin/1e3) '-' num2str((ms*lick_bin)/1e3)] ' s)'],'g');
    firs=firs+lick_bin;
end
%%
fi=applytofig(gcf,'FontMode','scaled','FontSize','1','Color','cmyk','width',4,'height',2,'linewidth',.15);
print(gcf,['PSD (No-Go stimulus) ' nmeNG],forfigs)
end
%%
% for s=1:size(PSDs,1)
%     maxP=max(PSDs(s,:));
%     PSDs(s,:)=PSDs(s,:)/maxP(1);
% end
% for s=1:size(noPSDs,1)
%     maxP=max(noPSDs(s,:));
%     noPSDs(s,:)=noPSDs(s,:)/maxP(1);
% end
%%


%         specSurf(noPSDs,fs,lick_bin,'No-Go',autumn)
try
    p1=find(nofs==(bands(1)));
    p2=find(nofs==(bands(end)));
    frs=fss(p1:p2);
    NGAna='regular';
    NGPSDs=noPSDs(p1:p2);
    NoGoFsAv=noPSDs(:,p1:p2);
catch
    try
    p1=find(nofs_rems==(bands(1)));
    p2=find(nofs_rems==(bands(end)));
    frs=nofs_rems(p1:p2);
    NGAna='rems';
    NGaxis=nofs_rems;
    NGPSDs=noPSDs_rems(p1:p2);
    NoGoFsAv=noPSDs_rems(:,p1:p2);
    end
    
end


% try
% MatFs=[go_frec go_frec_rems go_frec_pow go_frec_pow_rems
%     nogo_frec nogo_frec_rems nogo_frec_pow nogo_frec_pow_rems];
% catch
%     MatFs=[go_frec go_frec_rems go_frec_pow go_frec_pow_rems];
% 
% end
% G_Frecs_rep=MatFs(MatFs>0);

%% Func

%         NoGoFsAv=NoGoFsAv';
%         meanNoPows=mean(NoGoFsAv);
%         NoRelChange=mean(NoGoFsAv);
%         NoRelChange=NoRelChange/NoRelChange(1);
%         NoRelChange=NoRelChange-NoRelChange(1);
%         %%
%         figure
%         yyaxis right
%         plot(meanGoPows,'g-'), hold on
%         yyaxis right
%         plot(meanNoPows,'r-')
%         yyaxis left
%         plot(GoRelChange,'c--'), hold on
%         plot(NoRelChange,'m--')
%
%         %         [go_frec,go_frec_pow,goPSD]=lick_fft_analysis(data_parcel_go,'Spectrogram for Go trials','g');
%         %         [go_pow,go_f,nogo_pow,nogo_f,goPSD,nogoPSD]=lick_fft_analysis...
%         %
%         % allPSDs=[PSDs;noPSDs];
%         % x=size(allPSDs,1);
%         % y=size(allPSDs,2);
%         % [X,Y]=meshgrid(fs,1:x);
%         % Z=allPSDs;
%         % figure
%         % mesh(X,Y,Z,'FaceColor','interp',...
%         %    'EdgeColor','none',...
%         %    'FaceLighting','gouraud')
%         % xlabel('Frequency (Hz)')
%         % ylabel('Time(s)')
%         % zlabel('Power/Freq (dB/Hz)')
try
disp(['Lick Frequency Analyzed, Anysis of Go ' GAna ' and No-Go ' NGAna])
catch
    disp(['Lick Frequency Analyzed, Anysis of Go ' GAna ])
end