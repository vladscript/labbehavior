function [speed_raw,speed_smooth] = getLocSpeed(data_treadmill, final_sampRate, smooth_window_width, ToPlotOrNot)
%%
%Function for converting raw rotary encoder signal to treadmill speed

%  for k = 1:length(data_treadmill.treadmill)
    
    %Grab data
%     temp_treadmill = data_treadmill.treadmill{1,k}; %Treadmill voltage signal
temp_treadmill = data_treadmill;
temp_sampRate =1e3;
%     temp_sampRate = data_treadmill.sampRate{1,k}; %Sampling rate in Hz
%     temp_h = data_treadmill.h{1,k}; %Additional meta-data (not using here)

    %Downsample treadmill signal to X Hz (Only tested for 10 and 20 Hz)
    downsampFac = temp_sampRate/final_sampRate; %Downsampling factor
    
    if mod(downsampFac,1) > 0
        disp('Ratio between original and final sampling rate not an integer')
        return
    else
    end
    
    temp_treadmill_ds = downsample(temp_treadmill, downsampFac); %Downsample raw treadmill voltage signal
    
    %Apply moving average filter (500 ms) to remove higher frequency components (decreases the noise for approximative derivative)
    temp_treadmill_ds_mm = movmean(temp_treadmill_ds,final_sampRate/2);
  
    %Get time vectors and compute approximative derivative of treadmill voltage output
    dtime = 1/temp_sampRate; %Define timestep
    timevec = ((0:length(temp_treadmill)-1)*dtime)'; %Timevector
    dtime_ds = dtime*downsampFac; %Downsampled timestep
    timevec_ds = ((0:length(temp_treadmill_ds)-1)*dtime_ds)'; %Downsampled timevector    
    treadmill_deriv = abs(diff(temp_treadmill_ds_mm)/dtime_ds); %Compute approximative derivative    
        
    %Correct approximative derrivative when the treadmill passes its reset point (i.e., 5 V --> 0 V)
    correcthresh = max(treadmill_deriv)*0.4; %Set threshold    
    resetpoints = find(treadmill_deriv > correcthresh); %Find the points above threshold
    treadmill_deriv_corr = treadmill_deriv;

    %Define data-point to use for correcting reset data point (0.5 s before and after � this is trial-and-error, no perfect logic to it
    points_window = 0.5/(1/final_sampRate);
    
    for i = 1:length(resetpoints) %correct voltage reset points in deriv by setting to mean of neighboring points (Derivative, not raw voltage so setting to mean is OK)
            try %In case the reset point is at the far end of the recording, we only use the preceeding or subsequent point to correct the value (otherwise it exceed matrix dimensions)    
                treadmill_deriv_corr(resetpoints(i)) = (treadmill_deriv_corr(resetpoints(i)-points_window) + treadmill_deriv_corr(resetpoints(i)+points_window))/2;
            catch    
%                 disp('far edge of recording')
                try %Try and only use preceeding data point
                    treadmill_deriv_corr(resetpoints(i)) = treadmill_deriv_corr(resetpoints(i)-points_window);
                catch
                    try %Try using only subsequent data point
                        treadmill_deriv_corr(resetpoints(i)) = treadmill_deriv_corr(resetpoints(i)+points_window);
                    catch
                    end 
                end
            end    
    end
%%
    %Do an additional iteration just to be sure all reset points are fixed
    
    %Define data-point to use for correcting reset data point (1.5 s before and after � this is trial-and-error, no perfect logic to it
    points_window2 = 1.5/(1/final_sampRate);
    
    if any(treadmill_deriv_corr >= correcthresh) == 1
        
        resetpoints2 = find(treadmill_deriv_corr >= correcthresh); %Find points above threshold
        treadmill_deriv_corr2 = treadmill_deriv_corr;
        
        for i = 1:length(resetpoints2) %correct voltage rest points in deriv by setting to mean of neighboring points (Derivative, not raw voltage so setting to mean is OK)
            try %In case the reset point is at the far end of the recording, we only use the preceeding point to correct the value (otherwise it exceed matrix dimensions)    
                treadmill_deriv_corr2(resetpoints2(i)) = (treadmill_deriv_corr2(resetpoints2(i)-points_window2) + treadmill_deriv_corr2(resetpoints2(i)+points_window2))/2;
            catch
%                disp('far edge of recording - 2nd iteration') 
               
               try %Try and only use preceeding data point
                  treadmill_deriv_corr2(resetpoints2(i)) = treadmill_deriv_corr2(resetpoints2(i)-points_window2); 
               catch
                   try %Try using only subsequent data point
                       treadmill_deriv_corr2(resetpoints2(i)) = treadmill_deriv_corr2(resetpoints2(i)+points_window2);
                   catch
                   end
               end
            end
        end

    else
        treadmill_deriv_corr2 = treadmill_deriv_corr;
    end
    
    %Computer treadmill speed 
    C = pi * 7; % Circumference in cm from diameter
    range = max(treadmill_deriv_corr2) - min(treadmill_deriv_corr2); %Get range of treadmill output values
    ratio = treadmill_deriv_corr2./range; % Ratio of range at each point to be converted to ratio of total wheel distance
    speed_temp = C.*ratio; %Ratio of total wheel distance is speed at each time point
    
    %Apply moving average filter in a X ms window to smooth the trace a bit
    window_size = (final_sampRate/1000)*smooth_window_width;
    speed_temp_mm = movmean(speed_temp, window_size);

    if ToPlotOrNot == 1
    k=1;
        figure(1)
%         subplot(length(data_treadmill),1,k);
        plot(timevec_ds(1:end-1)./60, speed_temp_mm, 'k');
        xlim([-inf inf])
        ylim([-inf max(speed_temp_mm)*1.1])
        title("Recording # " + k + "");
        ylabel('Speed [cm/s]')
        
        if k == length(data_treadmill)
            xlabel('Time [s]')
        else
        end
        
    else
    end
    
    %Put data into structure
%     speed.raw{1,k} = speed_temp;
    speed_raw = speed_temp;
    speed_smooth = speed_temp_mm;
%     speed.smooth{1,k} = speed_temp_mm;
%     speed.sampRate{1,k} = final_sampRate;
%     speed.time_sec{1,k} = timevec_ds(1:end-1);

%  end
 
end
