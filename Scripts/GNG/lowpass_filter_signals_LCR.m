function data_filt = lowpass_filter_signals_LCR(data,smvalue)

nlfilt=40; %filtro de orden 40 la frecuencia de corte es casi cuadrada

len= size(data,2);

%nlfilt = 5000;			% filter length.
if (nlfilt > len/3-1) % filt length must less than 1/3 of the data
    nlfilt = floor(len/3-1);
    if mod(nlfilt,2)
	nlfilt = nlfilt-1;
    end
end
%frecuencia de muestreo en milisegundos LCen14
normfreq_lpass = smvalue; %0.15;%lpass/(Fs/2);	% 1 corresponds to Nyquist rate. La mitad de la 1/freq funciona
hfilt = fir1(nlfilt, normfreq_lpass, 'low');
data_filt = filtfilt(hfilt, 1, data')'; %zero phase digital filter LCen14

