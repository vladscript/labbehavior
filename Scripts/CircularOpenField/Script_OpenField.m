%% Open Field:
% Scripts to plot for each analyzed video:
% Fig A:
%   Body Parts and Body Centroid Coordinates X & Y
% Fig B:
%   Subplot 1: Pixels distance
%   Subplot 2: Instant Velocyt
%% Setup
clc;
clear;
ansdlg=inputdlg('Number of videos:','DLC Analyzed Videos',[1 50]);
Nvid=str2num(ansdlg{1});
DISTANCES=cell(Nvid,1);
%% Time Window
ansdlg=inputdlg('Seconds window:','DLC Analyzed Videos',1,{'1'});
DistRate=str2num(ansdlg{1});
%% Read data
ActualDir=pwd;
for n=1:Nvid
    % Open Field Script
    [FN{n},PN{n}] = uigetfile('*.csv','Select SINGLE CSV file',...
        'MultiSelect','off',ActualDir);
    ActualDir=PN{n};
    disp(FN)
end
%% CALCULATIONS AND PLOTS
for n=1:Nvid
    FileName=FN{n};
    PathName=PN{n};
    X = importfileCSV([PathName,FileName]);
    % Load Matrix Data of CSVs  from DeepLabCut
    fs=29.98;
    H=600;
    W=540;
    % If W fits the diameter of the external cylinder
    % and that diameter is approx:
    Diam=45;
    t=X(:,1)/fs;        % seconds
    Nsamp=numel(t);
    %% Get Mean Coordinates
    [XmeanSmooth,YmeanSmooth]=get_body_parts(t,X,fs);
    clear X;
    %% Measure Distance in Pixels
    d_smooth=get_distance([XmeanSmooth,YmeanSmooth]);
    % Nsamples=round(1*fs);
    d_rate=get_velocity_interval(d_smooth,DistRate,fs);
    %% Plots
    figure;
    %    Plot Total Distance
    subplot(211)
    plot(linspace(0,length(d_smooth)/fs,length(d_smooth)),cumsum(d_smooth));
    % Plot Distance per Time
    subplot(212)
    bar(d_rate);
    Fig=gcf;
    LineIndx=find(FileName=='_');
    Fig.Name=FileName(1:LineIndx(1));
    %% SAVE DISTANCE
    DISTANCES{n}=d_smooth;
    %% ANIMATION TRAJECTORY PLOT
    answer = questdlg('Plot path animation?', ...
	'Path', ...
	'Yes','No','No');
    % Handle response
    switch answer
        case 'Yes'
            prompt={'Initial seconds:',...
                    'Final seconds:'};
            name='SECONDS';
            numlines=1;
            defaultanswer={'0','1'};
            answer=inputdlg(prompt,name,numlines,defaultanswer);
            answerrec = questdlg('Record animation?', ...
                    'Path','Yes','No','No');
            switch answerrec
                case 'Yes'
                    recpar=true;
                case 'No'
                    recpar=false;
            end
            plot_Trajecotry(str2double(answer{1}),str2double(answer{2}),[XmeanSmooth,YmeanSmooth],fs,H,W,recpar,FileName(1:LineIndx(1)));
        case 'No'
            disp([answer ' PATH plot.'])
    end
end


