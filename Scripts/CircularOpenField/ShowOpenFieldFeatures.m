%% Open Field Features 
% Script
clc; clear;
% addpath(genpath([pwd,'\RainCloudPlots-mini']));
%% Read CSV Files
WindowTime=60; % SECONDS
NC = inputdlg('Number of Conditions: ',...
             'Open Field', [1 75]);
NC = str2double(NC{:});    
% Setup Conditions
Conditions_String='Condition_';
n_conditions=[1:NC]';
Conditions=[repmat(Conditions_String,NC,1),num2str(n_conditions)];
Cond_Names=cell(NC,1);
% Names=cell(NC,1);
for i=1:NC
    Cond_Names{i}=Conditions(i,:);
    Names_default{i}=['...'];
end
% 2nd Input Dialogue
name='Names';
numlines=[1 75];
Names_Conditions=inputdlg(Cond_Names,name,numlines,Names_default);
% Directory (default)
CurrentPathOK=pwd;
%% Condition LOOP
TableCondition=table;
for i=1:NC
    % Read Names
    [FileName,PathName] = uigetfile('*.mat',['Select MULTIPLE .mat files for: ',Names_Conditions{i}],...
    'MultiSelect', 'on',CurrentPathOK);
    % Loop to Features from read csv
    if iscell(FileName)
        [~,NR]=size(FileName);
    else
        NR=1;
        % FileName=FileName
        FileName=mat2cell(FileName,1);
    end
    Features=[];
    OF_Names=cell(NR,1);
    % FILES LOOP +++++++++++++++++++++++++++++++++++++++++++++++++
    fprintf('>>% s Data: ',Names_Conditions{i});
    % Init Columns
    VidNames=cell(NR,1); FP=zeros(NR,1); SnapsImg=cell(NR,1);
    SnapWidth=zeros(NR,1); SnapHeight=zeros(NR,1); Scale_Width=zeros(NR,1);
    Scale_Height=zeros(NR,1); CenterX=zeros(NR,1); CenterY=zeros(NR,1);
    avgspeed_cmpermin=zeros(NR,1); TotalDistance_cm=zeros(NR,1);
    X_ZSkurtosis=zeros(NR,1); Y_ZSkurtosis=zeros(NR,1);
    X_ZSskew=zeros(NR,1); Y_ZSskew=zeros(NR,1); Xmean=zeros(NR,1);
    Xvar=zeros(NR,1); Ymean=zeros(NR,1); Yvar=zeros(NR,1);
    VelAvg=zeros(NR,1); VelVar=zeros(NR,1); ConditionCol=cell(NR,1);
    for r=1:NR
        ConditionCol{r}=Names_Conditions{i};
        % Load Snapshot corrrepoind to that file
        IndexRes=strfind(FileName{r},'OpenFieldData');
        load([PathName,FileName{r}]);
        % READ FEATURES
        VidNames{r,1}=NameVideo;
        FP(r,1)=fps;
        SnapsImg{r,1}=Snapshot;
        SnapWidth(r,1)=Image_WH(1);
        SnapHeight(r,1)=Image_WH(2);
        Scale_Width(r,1)=Scale_WH(1);
        Scale_Height(r,1)=Scale_WH(2);
        CenterX(r,1)=Field_Centroid(1);
        CenterY(r,1)=Field_Centroid(2);
        % Distance Paramters:
        d=get_distance([XYcm(:,1),XYcm(:,2)]);
        avgspeed_cmpermin(r,1)=sum(d)/(numel(d)/fps/60); % cm/min
        Xzs=(XYcm(:,1)-mean(XYcm(:,1)))/std(XYcm(:,1));
        Yzs=(XYcm(:,2)-mean(XYcm(:,2)))/std(XYcm(:,2));
        v_rate=get_velocity_interval(d,WindowTime,fps);
        TotalDistance_cm(r,1)=sum(d);
        X_ZSkurtosis(r,1)=kurtosis(Xzs(:,1));
        Y_ZSkurtosis(r,1)=kurtosis(Yzs(:,1));
        X_ZSskew(r,1)=skewness(Xzs(:,1));
        Y_ZSskew(r,1)=skewness(Yzs(:,1));
        Xmean(r,1)=mean(XYcm(:,1));
        Xvar(r,1)=var(XYcm(:,1));
        Ymean(r,1)=mean(XYcm(:,2));
        Yvar(r,1)=var(XYcm(:,2));
        VelAvg(r,1)=mean(v_rate);
        VelVar(r,1)=var(v_rate);
        fprintf('*');
    end
    fprintf('|');
    TableCondition=[TableCondition;...
        table(VidNames,ConditionCol,FP,SnapsImg,SnapWidth,SnapHeight,...
        Scale_Width,Scale_Height,CenterX,CenterY,TotalDistance_cm,avgspeed_cmpermin,...
        Xmean,Ymean,Xvar,Yvar,X_ZSkurtosis,Y_ZSkurtosis,X_ZSskew,Y_ZSskew,...
        VelAvg,VelVar)];
    fprintf('|done.\n');
    CurrentPathOK=PathName;
end
%% SAVE AT HARDRIVE DATA
fprintf('>>Saving:')
DateID=datestr(datetime('now'));
DateID(DateID==':')='_';
DateID(DateID==' ')='-';
FileDirSave=pwd;
slashes=find(FileDirSave==filesep);
FileDirSave=fullfile(FileDirSave(1:slashes(end)),'Tables_OpenField',filesep);
if ~isdir([FileDirSave])
    fprintf('Folder [%s] created\n',FileDirSave)
    mkdir(FileDirSave);
end
writetable(TableCondition,[FileDirSave,'OpenFieldData_',DateID,'.csv'])
fprintf('done.\n')
% clear;
%% Show Data
Conditions=unique(TableCondition.ConditionCol);
[CM,ColorIndx]=Color_Selector(Conditions);
N=numel(Conditions);
Nmetadata=10;
Nfeatures=size(TableCondition,2)-Nmetadata; % 10 -> metadata
FeatureNames=TableCondition.Properties.VariableNames(Nmetadata+1:end);  % Feature Names
Y=categorical(table2array( TableCondition(:,2)) ); % Labels
for n=1:Nfeatures
    DataPlot=cell(1,N);
    for c=1:N
        DataPlot{c}=table2array( TableCondition(Y==Conditions(c),Nmetadata+n) );
    end
    figure
    pairedraincloud('unpaired',CM(ColorIndx,:),0,0,DataPlot);
    title(FeatureNames(n),'interpreter','none')
    pause
end
%% stAts    

% [p_kw,tbl,stats] = kruskalwallis([DataPlot{1};DataPlot{2};DataPlot{3}],[1*ones(size(DataPlot{1}));...
%     2*ones(size(DataPlot{2}));3*ones(size(DataPlot{3}))])
% c = multcompare(stats,'CType','lsd'); % Least Significant Difference