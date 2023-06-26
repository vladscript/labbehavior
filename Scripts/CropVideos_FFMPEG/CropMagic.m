%% settings
%  is ffmpeg installed

%% Read directory folder of videos
% fsep=filesep;
VidDir=uigetdir(pwd);
%% Load Snaphotps
% Select .extension of files
list = {'.avi','.mp4','.mkv'};
[indx,tf] = listdlg('PromptString',{'Select  vidoe extension.',...
    'Only one extension can be selected at a time.',''},...
    'ListString',list,'SelectionMode','single');
if tf
    vidext=list{indx};
    stopflag=false;
else
    fprintf('>No extesnion selected')
    stopflag=true;
end
if ~stopflag
    AllFiles=dir(VidDir);
    for n=1:numel(AllFiles)
        strfind(vidext,AllFiles(n).name)
    end
    
    %% Loop 2 show frames and read Rectangel areas
    
    %% Apply FFMPEG

    % RUN FFMPEG from matlab

% A="recording1.avi";
% 
% eval(sprintf('!ffplay %s',char(A)))
else
    fprintf('>\n Trasnform videos')
end