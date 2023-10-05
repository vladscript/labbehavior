%%  Pupil Processing Script
% Read DATA

% Impor Screen gray values
[fileScrren,selpathScreen]=uigetfile('*.mat','MultiSelect','off','SCREEN mat file');
load([selpathScreen,fileScrren]);   % Loads Index variable: avg gray screen

% Import proxy of pupil area
[fileEye,selpathEye]=uigetfile('*.mat','MultiSelect','off','EYE mat file');

fps=30;

%% Load
fprintf('\n>Loading:')
load([selpathScreen,fileScrren])
load([selpathEye,fileEye])
fprintf('>done.\n')

%% Show Raw Data
plot_eye_signals(A,Blink,Peyearea,Index,fps,LHvec);

%% Pre-Processing

% Pupil Size: A ->  y

% Smooth
lpFilt = designfilt('lowpassfir','PassbandFrequency',0.125, ...
         'StopbandFrequency',0.2,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
fvtool(lpFilt)
y=filtfilt(lpFilt,A);

% Spectral
% melSpectrogram(zscore(A)',fps,'WindowLength',15*fps,'SpectrumType','power')

% Lid Distance: Blink

% Eye area: Peyearea (lids and corners)

% Index: Screen Stimuli


%%
% for U30
% Start: 3191
% End: 112506
% Trim signal
% a=3191;
% b=112506;
% 
% x_eye= A(a:b);
% x_pan=Index(a:b);

% AR model

% a = lpc(x_pan,3);
% xpan_est=filter([0 -a(2:end)],1,x_pan);