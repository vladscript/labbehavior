%%  Pupil Processing Script
% PROMINENCE INSTEAD OF PEAKAMPLITUDES
% ADD MOVEMENT DATA !!!
clear; 
%                                               Read DATA
% Import Screen gray values
[fileScrren,selpathScreen]=uigetfile('*.mat','MultiSelect','off','SCREEN mat file');
disp(fileScrren);
% Import proxy of pupil SIZE and more variables
[fileEye,selpathEye]=uigetfile([selpathScreen,'*.mat'],'MultiSelect','off',['EYE mat file linked to ',fileScrren]);
disp(fileEye);
% Acquisition rate
fps=60;                 % Hz: default frames per second (user input)
prompt={'fps:'};
name='Rate:';
numlines=[1 25];
defaultanswer={num2str(fps)};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
fps= str2double(answer{1});

%% Load
fprintf('\n>Loading & settings:')
load([selpathScreen,fileScrren])
load([selpathEye,fileEye])
% Low-Pass Filtering
lpFilt = designfilt('lowpassfir','PassbandFrequency',0.125, ...
         'StopbandFrequency',0.2,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% fvtool(lpFilt)
fprintf('>done.\n')
%% PLOT SPATIAL DATA
% 
Corners=plot_centers(EYE_AVGPOSITION,EYE_STDPOSITION,Centers_Pupil,EYE_center,fps);
% left and right corners of the eye
%% Pre-Processing Index: Screen & Stimuli
% DATA ####################################################################
s=zscore(Index);            % Shape of gray changes
dsf=derifilter(s);          % derivative of gray changes
% DETECT START & END OF THE EXPERIMENT #####################################
% Peak of the high frequencies
% [Nstart,Nend]=highfrqChanges(dsf);              % EXPERIMENT SAMPLE INTERVA
ws=100; % sliding window for variance computing
vx=varfilt(s,ws);
[Nstart,Nend]=StartEndVar(vx);                                  % OUTPUT 
s_exp=s(Nstart:Nend);   % -------------> TO PROCESS
fs_exp=filtfilt(lpFilt,s_exp);  % smooth scren signal
v=varfilt(s_exp,ws);           % variance of scrren signal
% dv=derifilter(v);               % fast changes in scren signal
[FranesStim,FranesScreen,STIM_INTER]=screenstims(fs_exp,v,ws);  % OUTPUT 
% 
%% Pre-Processing Pupil Size:       A ->  y
lt=LHvec(Nstart:Nend);
y=filtfilt(lpFilt,A);
% % % Spectral
% % melSpectrogram(zscore(ys)',fps,'WindowLength',15*fps,'SpectrumType','power',...
% %     'FrequencyRange',[0,0.125*fps/2])
ys=y(Nstart:Nend);
% Maxiimum Size
% ybig=[y(1:Nstart),y(Nend:end)]; % Only from start
ybig=y(1:Nstart); % Only from start
[py,biny]=ksdensity(ybig,linspace(min(ybig),max(ybig),100));
[~,MaxSize]=findpeaks(py,biny,"NPeaks",1,'SortStr','descend');
ys=ys/MaxSize; % PUPIL SIZE %
% 
%% PLOT RAW DATA

plot_eye_signals(A,Blink,Peyearea,Index,fps,LHvec,MaxSize,Nstart,Nend);

%% Pre-Processing Lid Distance: Blink -> b
% Regression of NaN values
b=smoothdata(Blink);
Blink(isnan(Blink))=b(isnan(Blink));
% Low-Pass filtering
b=filtfilt(lpFilt,Blink);
bs=b(Nstart:Nend);
%% Pre-Processing Eye area: Peyearea (lids and corners)
% 
% UNNECESSARY
% 
%% Pre-processing Eye Trace          Centers_Pupil->
CP=Centers_Pupil(Nstart:Nend,:);
CP_x=filtfilt(lpFilt,CP(:,1));
CP_y=filtfilt(lpFilt,CP(:,2));
Ctrace=get_distance([CP_x,CP_y]);
CornDist=get_distance(Corners);
EyeSize=CornDist(end);
Ctrace=Ctrace/EyeSize; % DISTANCE TRAVELED / ni proportion to corner distance
CumCtrace=cumsum(Ctrace(lt>0));
TotalDisplacement=CumCtrace(end); % of the corsner distance

%% EXPLORATORY ANALYSIS
% Pupils Size %
OutPut_SizeAll=numstats(ys(lt>0));
OutPut_Size=exploratoryresults(intersect(FranesScreen,find(lt>0)),intersect(FranesStim,find(lt>0)),ys);
title('Pupil Size %')
% Hi_Freq Changes in pupil size
dys=derifilter(ys);
OutPut_ChngSizeAll=numstats(dys(lt>0));
OutPut_ChngSize=exploratoryresults(intersect(FranesScreen,find(lt>0)),intersect(FranesStim,find(lt>0)),dys);
title('Changes in Pupil Size')
% Variance in slidgin Window
vs=varfilt(ys,ws);
OutPut_VarSignAll=numstats(vs(lt>0));
OutPut_VarSign=exploratoryresults(intersect(FranesScreen,find(lt>0)),intersect(FranesStim,find(lt>0)),vs);
title('Sliding Variance ')
% Blink Signal
OutPut_LIDdistAll=numstats(bs);
OutPut_LIDdist=exploratoryresults(FranesScreen,FranesStim,bs);
title('Lid distance')
% Trace of pupil Center
OutPut_CtrTraceAll=numstats(Ctrace(lt>0));
OutPut_CtrTrace=exploratoryresults(intersect(FranesScreen,find(lt>0)),intersect(FranesStim,find(lt>0)),Ctrace);
title('Pupil Trace')

% Peaks of Pupil Size
[Ampls,Times,~,Proms]=findpeaks(ys);
[PeaskatScreen,indxPScreen]=intersect(Times,intersect(FranesScreen,find(lt>0)));
[PeaskatStims,indxPStim]=intersect(Times,intersect(FranesStim,find(lt>0)));
OutPut_PksSizeAll=numstats(Proms);
OutPut_PksSize=exploratoryresults(indxPScreen,indxPStim,Proms);
title('PeakProminence@Pupil Size')


%% Linear Trend of Pupil Size during Stims & Final Plot 
% 
figure;
axi1=subplot(2,1,1);
ts=linspace(0,numel(ys)/fps/60,numel(ys));% Minutes
plot(ts,ys); grid on; hold on;
axi2=subplot(2,1,2);
% ts=linspace(0,numel(s_exp)/fps/60,numel(s_exp));% Minutes
plot(ts,s_exp); grid on;
linkaxes([axi1,axi2],'x');

MissFrames=find(LHvec(Nstart:Nend)<1);

% Linear Trending during stimuli
SlooPe=zeros(size(STIM_INTER,1),1);
QoW=zeros(size(STIM_INTER,1),1);
for i=1:size(STIM_INTER,1)
    at=STIM_INTER(i,1);
    bt=STIM_INTER(i,2);
    % Check likelihoods
    BadSamples=intersect([at:bt],MissFrames);
    % Quality of Window
    QoW(i)=100-100*(numel(BadSamples)/(bt-at+1));     
    % Linear trend of pupil size
    [p,S] = polyfit(ts(at:bt),ys(at:bt),1); % Linear Trend of Size during Stim
    ylin=polyval(p,ts(at:bt),S);
    SlooPe(i)=p(1);
    % plot
    
    plot(axi1,ts(at:bt),ys(at:bt),'-k','LineWidth',2);
    plot(axi1,ts(at:bt),ylin,'r','LineWidth',2);
%     axi1.XLim=[ts(at),ts(bt)];
%     pause;
end
axi1.YLim=[0,1];
Output_Slop=numstats(SlooPe(QoW>50));


%% OUTPUT
OutPut=[OutPut_SizeAll,OutPut_Size,OutPut_ChngSizeAll,OutPut_ChngSize,...
    OutPut_LIDdistAll,OutPut_LIDdist,OutPut_CtrTraceAll,OutPut_CtrTrace,...
    OutPut_PksSizeAll,OutPut_PksSize,Output_Slop];

T=array2table(OutPut);
T.Properties.VariableNames={'All_Size','Blank_Size','Stimu_Size',...
    'All_ChngSize','Blank_ChngSize','Stimu_ChngSize',...
    'All_LIDdist','Blank_LIDdist','Stimu_LIDdist',...
    'All_CtrTrace','Blank_CtrTrace','Stimu_CtrTrace',...
    'All_PksSize','Blank_PksSize','Stimu_PksSize',...
    'StimStats_TrendStim'};
T.Properties.RowNames={'Mean','Variance','Kurtosis','Skewness'};
%% OUTPUT CONSOLE
Tt=tabulate(LHvec);
fprintf("\n>Total PUPIL displacement: %2.2f %% of the corners distance",TotalDisplacement);
fprintf('\n>Exp. length: %2.2f min',(Nend-Nstart)/fps/60)
fprintf('\n>Missdetection %% frames: %2.2f',Tt(1,3))

%% Export CSV and MAT File

LimName=find( fileScrren=='_',1);
writetable(T,[selpathEye,fileScrren(1:LimName-1),'.csv'])
fprintf(' -> saved\n')
% save



%% OUTPUT MATLAB
% ID
% fileEye
% % Likelihood threshold
% lt
% % Pupil Size
% ys
% % Screen Signal
% s_exp
% % Blink Signal
% bs
% Pipul Center
PipilCenter=[CP_x,CP_y];
save([selpathEye,fileScrren(1:LimName-1),'.mat'],"fileEye","lt","ys",...
    "s_exp","bs","PipilCenter","SlooPe","STIM_INTER","QoW","fps","Nstart","Nend",...
    "t_daq","TreadMill");
fprintf('\nSaved\n')

fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See CSV & .mat files Here</a>\n',selpathEye);