%  REVIEW VIDEO

% READ VIDEO

% VidName='W-OLM.Rubi-duringTraining_W-OLM.Rubi-duringTrainingII_LTM_R2DLC_mobnet_100_OLM07062023Jun7shuffle1_200000_labeled.mp4';
FileOutput='C:\Users\vladi\OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO\WORK\Data Analysis\Datos\Conducta\OLM\VIDEOS\S-OLM.3\';
VidName='Updating R1.mp4';
Vdir=[FileOutput,VidName];
vidObj = VideoReader(Vdir);

%  READ LOG

X=Zexort(1:end-1,:);
tA=Zexort{end,1}; % TIME OFFSET (TRIMED)
tB=Zexort{end,2};
fps_cell= Zexort{end,3};
fps= str2double( fps_cell{1} );

%% Main loop
Nevents=size(X,1);
F=figure;
for n=1:Nevents
    fa=X.Frame_A(n)+tA;
    fb=X.Frame_B(n)+tA;
    if ~strcmp(X.Action{n},'Bout')
        for f=fa:fb
            frame = read(vidObj,f);
            imshow(frame);
            title(sprintf('%i/%i: %s',n,Nevents,X.Action{n}));
            pause(2/vidObj.FrameRate)
        end
    end
    pause(0.01)
end

