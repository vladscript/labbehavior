%% settings
%  is ffmpeg installed
disp('>Necessary MATLAB R2018b at least & FFMPEG installed')
%% Read directory folder of videos
% fsep=filesep;
VidDir=uigetdir(pwd);
%% Load Snaphotps
% Select .extension of files
list = {'.avi','.mp4','.mkv','.mov'};
[indx,tf] = listdlg('PromptString',{'Select  video extension(s).',...
    'from all videos in the directory.',''},...
    'ListString',list);
if tf
    vidext=list(indx);
    stopflag=false;
else
    fprintf('>No video extension selected')
    stopflag=true;
end
if ~stopflag
    % GET VIDEO FILE NAMES
    AllFiles=dir(VidDir);
    NamesVideos={};
    aux=1;
    for n=1:numel(AllFiles)
        for i=1:numel(vidext)
            findxx=strfind(AllFiles(n).name,vidext(i));
            if ~isempty(findxx)
                NamesVideos(aux)=cellstr( AllFiles(n).name);
                fprintf('.')
                aux=aux+1;
            end
        end
    end
    fprintf('\n')
    %% Loop 2 show frames and read Rectangle areas
    POS=zeros(numel(NamesVideos),4);
    for n=1:numel(NamesVideos)
        v = VideoReader([VidDir,filesep,NamesVideos{n}]);
        Nframes=v.NumFrames;
        fprintf('Video %i of %i\n',n,numel(NamesVideos))
        % H=v.Height;
        % W=v.Width;
        f=round(1 + (Nframes-1).*rand(1,1));
        frame = read(v,f);
        imshow(frame)
        title(sprintf('File: %s f=%i',NamesVideos{n},f))
        rectangulo=drawrectangle(gca,'Color',[0.900 0.447 0.741],'FaceAlpha',0.1);
        P=rectangulo.Position;
        fprintf('[1]> Draw rectangular ROI\n[2]> Delete Rectangle Object:\n Right-click on rectangle:Delete Recatngle\n')
        waitfor(rectangulo);
        POS(n,:)=round(P);
%         pause
    end
    close(gcf);
    clear v; clear frame; % free memory
    %% Apply FFMPEG
    fprintf('\n>Preparing FFMPEG crop magic\n:')
    pause(1); clc
    for n=1:numel(NamesVideos)
        A = ['"',VidDir,filesep,NamesVideos{n},'"'];
        DotIndx=strfind(NamesVideos{n},'.');
        VideoOut=[NamesVideos{n}(1:DotIndx-1 ),'_CROPPED',NamesVideos{n}(DotIndx:end)];
        B = ['"',VidDir,filesep,VideoOut,'"'];
        % ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4
        eval(sprintf('!ffmpeg -i %s -filter:v "crop=%i:%i:%i:%i" %s',char(A),...
            POS(n,3),POS(n,4),POS(n,1),POS(n,2),char(B)))
        % eval(sprintf('!ffplay %s',char(A)))
    end
    % RUN FFMPEG from matlab
    % A="recording1.avi";
    % 
    % eval(sprintf('!ffplay %s',char(A)))
    fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">Cropped Videos Here</a>\n',VidDir)
else
    fprintf('>\n Trasnform videos to %s',cell2mat(list))
end
fprintf('\nEND\n')