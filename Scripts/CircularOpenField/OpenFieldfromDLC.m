%% Setup
% Run this script for each Condition
% Read DeepLabCut Posture inferences body parts from mice:
% - Snout
% - Left Ear
% - Right Ear
% - Back
% - Tailbase
% Reads snaphosts and fps to convert to centimeters using API
% Gets body centroid and smooths path, velocity
% Saves results for each file
%% Read Data
clear; clc;
global distance;
global point1;
global point2;
% Velocuty Histogram
ansdlg=inputdlg('Seconds window:','DLC Analyzed Videos',1,{'60'});
WindowTime=round(str2double(ansdlg{1})); % seconds
Dirpwd=pwd;
slashesindx=find(Dirpwd=='\');
CurrentPathOK=[Dirpwd(1:slashesindx(end)),'OpenFieldData'];
% Load Files Multiselection (files in the same folder)
[FN,PNcsv] = uigetfile('*.csv','Select MULTIPLE Postures from DLC: ',...
    'MultiSelect', 'on',CurrentPathOK);
CurrentPathOK=PNcsv;
if isstr(FN)
    N=1;
    FNaux{1}=FN;
    clear FN;
    FN=FNaux;
end
if iscell(FN)
    N=numel(FN);
end

%% LOAD SNAPSHOTS AND VIDEO FEATURES
FPS=zeros(1,N); % Sampling frequency
% VidNames=cell(N,1)
for n=1:N
    FileName=FN{n};
    % Load Snapshot corrrepoind to that file
    IndexRes=strfind(FileName,'res');
    VidNames{n} = FileName(1:IndexRes(1)-1);
    [FNsnap{n},PNsnap] = uigetfile('*.png',sprintf('Snapshot from %s video',VidNames{n}),...
    'MultiSelect', 'off',CurrentPathOK);
    CurrentPathOK=PNsnap;
    fs=NaN; % To read fs to get into the following loop:
    while isnan(fs) % Interface error user reading fs
        fs = inputdlg(sprintf('%s [fps] : ',VidNames{n}),...
                     'Sampling frequency or', [1 75]);
        fs = str2double(fs{:});
    end
    FPS(n) = fs;
end
%% LOAD IMAGES AND READ DIAMETERS TO MAKE [pixel -> cm]
% Previo actual measures
preFig=figure('Name','Measures','NumberTitle','off','Toolbar','none',...
    'Menubar','none');
ImgCM=imshow('Figures/OF_Measures.png');
% uiwait(preFig); % left plotted image

disp('>>Show snaphsots:')
SIZES=zeros(N,2);   % Snapshot Size                      [Width x Height]
PixDiam=zeros(N,2); % Diameter in Pixles          [Horizontal & Vertical]
ConverterCM=zeros(N,2); % Scale constante to centimeters [Width & Height]
FieldCenter=zeros(N,2);  % Coordinates of the Field Center     [Xpix,Ypix]
for n=1:N
    % Corresponding Video
    FileName=FN{n};
    VidName=VidNames{n};
    % Load Snapshot corrrepoind to that file
    SnapShot=imread([PNsnap,FNsnap{n}]);
    [H,W,~]=size(SnapShot); % Image Sie: Height and Width
    SIZES(n,:)=[W,H];
    % API to measure Horizontal & Vertical Diameters
    [Diameters,CnstntConv,Centers]=diam_api(VidName,PNsnap,FNsnap{n}); % distance
    % Save Results
    PixDiam(n,:)=Diameters;         % pixels
    ConverterCM(n,:)=CnstntConv;    % pixels
    FieldCenter(n,:)=mean(Centers); % pixels
end
clear SnapShot; close(preFig)
%% LOAD CSV DATA [and get trajectories]
for n=1:N    
    fprintf('>>Loading raw data from %s: ',VidNames{n})
    % Read raw data from DLC inferences
    X = importfileCSV([PNcsv,FN{n}]);
    % Xtable = readtable([PNcsv,FN{n}]);
    % Read paramters
    fps=FPS(n);     % frames per second
    H=SIZES(n,2);    % image height
    W=SIZES(n,1);    % image width
    % pixel*Scale = cm
    HortScale=ConverterCM(n,1)/PixDiam(n,1);
    VertScale=ConverterCM(n,2)/PixDiam(n,2);
    t=X(:,1)/fps;   % vector time in seconds
    Nsamp=numel(t);
    fprintf('done.\n')
    % Get Body Centroid Coordinates
    fprintf('>>Body Mass Centroid: ')
    [XmeanSmooth,YmeanSmooth]=get_body_parts(t,X,fps);
    title(gca,sprintf('OpenField of %s',VidNames{n}),'Interpreter','none')
    clear X;
    PATHS{n}=[XmeanSmooth*HortScale,YmeanSmooth*VertScale]; % cm
    fprintf('estimated.\n')
    % Measure Distance in Pixels
    fprintf('>>Instant Distance [cm] and Velocity [cm/s] \n  & Velocity Histogram %i[s]:',WindowTime)
    % Instantaneuous Distance
    d_smooth=get_distance([XmeanSmooth*HortScale,YmeanSmooth*VertScale]);
    % Histogram Velocity
    d_rate=get_velocity_interval(d_smooth,WindowTime,fps);
    DISTANCES{n}=d_smooth;
    VELOCHIST{n}=d_rate;
    fprintf('obtained.\n');
end
%% Plots OPENFIELD PATH, INSTANT DISTANCE, VELOCUTY AND VELOCITY HISTOGRAM
MEASURES;
for n=1:N
    % Retrieve Data
    W=SIZES(n,1); % Width
    H=SIZES(n,2); % Width
    HortScale=ConverterCM(n,1)/PixDiam(n,1);
    VertScale=ConverterCM(n,2)/PixDiam(n,2);
    d_smooth=DISTANCES{n};
    fps=FPS(n);
    velocity=diff(d_smooth)*fps;
    d_rate=VELOCHIST{n};
    % Field Center
    Cx=FieldCenter(n,1)*HortScale; Cy=FieldCenter(n,2)*VertScale; % cm
    % Radius
    Dx=ConverterCM(n,1); % [Horizontal]
    Dy=ConverterCM(n,2); % [Vertical]
    XYcm=PATHS{n}; % cm
    %       Open Field
    figure; % Show Path and Circular Surface (center,radiosX,radiusY)
    avgspeed=sum(d_smooth)/(numel(d_smooth)/fps/60);
    plot(Cx,Cy,'Marker','+','MarkerSize',15); hold on
    rectangle('Position',[Cx-SmallDiameter/2,Cy-SmallDiameter/2,SmallDiameter,SmallDiameter],'Curvature',[1,1])
    % rectangle('Position',[Cx-Dx/2,Cy-Dy/2,Dx,Dy],'Curvature',[1,1])
    plot(XYcm(:,1),XYcm(:,2)); grid on;
    axis([0,HortScale*W,0,VertScale*H]);
    daspect([1,1,1]);
    title(gca,sprintf('Open Field of %s Total:%3.2f[cm] @ %3.2f[cm/min]',VidNames{n},...
        sum(d_smooth),avgspeed),'Interpreter','none')
    xlabel('[cm]'); ylabel('[cm]');
    %       Distance,Velocity & Histogram Velocity
    figure    
    subplot(211)
    [hAx,~,~]=plotyy(linspace(0,numel(d_smooth)/fps,numel(d_smooth)),d_smooth,...
        linspace(0,numel(velocity)/fps,numel(velocity)),velocity);
    title(gca,sprintf('Instant Values of %s',...
        VidNames{n}),'Interpreter','none')
    xlabel('Time (sec)')
    ylabel(hAx(1),'Distance [cm]') % left y-axis
    ylabel(hAx(2),'Velocity [cm/s]') % right y-axis
    % Plot Distance per Time
    subplot(212)
    barax=bar(d_rate);
    barax.XData=barax.XData*WindowTime;
    barax.BarWidth=1;
    title(gca,sprintf('Velocity Histogram of %s',VidNames{n}),'Interpreter','none')
    ylabel(sprintf('[cm/s]'));
    xlabel('Time (sec)')
    axis tight
    pause
end
%% EXPORT RESULTS
fprintf('>>Saving:\n')
DateID=datestr(datetime('now'));
DateID(DateID==':')='_';
DateID(DateID==' ')='-';
for n=1:N
    NameVideo=FN{n};
    fprintf('%s\n',VidNames{n})
    Snapshot=FNsnap{n};
    XYcm=PATHS{n};
    Image_WH=SIZES(n,:);
    DiametersPix=PixDiam(n,:);
    Scale_WH=ConverterCM(n,:);
    Field_Centroid=FieldCenter(n,:);
    fps=FPS(n);
    FileDirSave=pwd;
    slashes=find(FileDirSave==filesep);
    FileDirSave=fullfile(FileDirSave(1:slashes(end)),'Processed_OpenField',filesep);
    if ~isdir([FileDirSave])
        fprintf('Folder [%s] created\n',FileDirSave)
        mkdir(FileDirSave);
    end
    % Saves data (and the day)
    save([FileDirSave,VidNames{n},'OpenFieldData_',DateID,'.mat'],...
        'NameVideo','Snapshot','XYcm','Image_WH','DiametersPix',...
        'Scale_WH','Field_Centroid','fps');
end
fprintf('done.\n')