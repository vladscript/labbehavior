%% Read Video

% Files
CurrentPathOK=pwd;
[FN,DirVids] = uigetfile('*.mp4','Select Cropped VIDEO containing visual stimulus: ',...
    'MultiSelect', 'on',CurrentPathOK);
if iscell(FN)
    N=numel(FN);
    singlevid=false;
else
    N=1;
    singlevid=true;
end

%% Processing
for n=1:N
    fprintf('\n########## VIDEO %i ################',n)
    if singlevid
        FileVid=FN;
    else
        FileVid=FN{n};
    end
    v = VideoReader([DirVids,FileVid]);
    Index=TypeStim(v);
    % Output
    FileVideoOut=[FileVid(1:end-4),'_STIMS_vector'];
    save(FileVideoOut,'Index');
    fprintf('\n[saved]\n')

    %% Save
    fprintf('\n>Sav')
    save([DirVids,FileVid(1:end-4),'_SCREEN_'],'Index');
    fprintf('ed\n')
end
