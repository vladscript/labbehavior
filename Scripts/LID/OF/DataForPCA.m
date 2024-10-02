%% load data
% read csv from deeplabcut
clear; close all;
% aux=1;
[file,selpath]=uigetfile('*.csv','MultiSelect','on');
if ~iscell(file)
    F=file; clear file
    file{1}=F;
end

Xmovemente=[];
Xstatfeats=[];
LHthres=0.6; % Likelihood Threshold
Diameter=5*2; % [cm] MEASURED 5 cm radius/Paper AMAN |CLZ
for i=1:numel(file)
    f=file{i};
    X=readdlctableLID([selpath,f]);
    Frames=size(X,1);
    %% Checking Likelihood
    L=[X.UpL,X.DownL,X.LeftL,X.RightL,X.TailL,X.CenterL,X.NoseL,X.LeftBackL,X.LeftUpL,X.RightBackL, X.RightUpL];
    Lbin=zeros(size(L));
    Lbin(L>LHthres)=1;
    % 1:4 Cylinder  X.UpL,X.DownL,X.LeftL,X.RightL
    % 5:7 Axis:     X.TailL,X.CenterL,X.NoseL
    % 8:11 Limbs    X.LeftBackL,X.LeftUpL,X.RightBackL, X.RightUpL

    indxlim=strfind(f,'DLC_mobnet');
    FLHs=gcf;
    FLHs.Name=sprintf('%s',f(1:indxlim-1));
    
    
    %% Cylinder  and CM-PX convesion
    % Up
    UpX=mostlikelyvalue(X.UpX(Lbin(1,:)>0));
    UpY=mostlikelyvalue(X.UpY(Lbin(1,:)>0));
    % Down
    DownX=mostlikelyvalue(X.DownX(Lbin(2,:)>0));
    DownY=mostlikelyvalue(X.DownY(Lbin(2,:)>0));
    % Left
    LeftX=mostlikelyvalue(X.LeftX(Lbin(3,:)>0));
    LeftY=mostlikelyvalue(X.LeftY(Lbin(3,:)>0));
    % Right
    RightX=mostlikelyvalue(X.RightX(Lbin(4,:)>0));
    RightY=mostlikelyvalue(X.RightY(Lbin(4,:)>0));
    Dvertical=twopartsdistance([UpX,UpY],[DownX,DownY]);
    Dhorizon=twopartsdistance([LeftX,LeftY],[RightX,RightY]);
    Xpx2cm=Dhorizon/Diameter;
    Ypx2cm=Dvertical/Diameter;
    
    %% Read Body Parts Features 
    TailXY=[X.TailX/Xpx2cm,X.TailY/Ypx2cm];                 % [cm]
    CenterXY=[X.CenterX/Xpx2cm,X.CenterX/Ypx2cm];           % [cm]
    NoseXY=[X.NoseX/Xpx2cm,X.NoseX/Ypx2cm];                 % [cm]
    LeftBackXY=[X.LeftBackX/Xpx2cm,X.LeftBackY/Ypx2cm];     % [cm]
    LeftUpXY=[X.LeftUpX/Xpx2cm,X.LeftUpY/Ypx2cm];           % [cm]
    RightBackXY=[X.RightBackX/Xpx2cm,X.RightBackY/Ypx2cm];  % [cm]
    RightUpXY=[X.RightUpX/Xpx2cm,X.RightUpY/Ypx2cm];        % [cm]

    Cola=TailXY(Lbin(:,5)>0,:);
    Centro=CenterXY(Lbin(:,6)>0,:);
    Nariz=NoseXY(Lbin(:,7)>0,:);
    IzqPatTras=LeftBackXY(Lbin(:,8)>0,:);
    IzqPatSup=LeftUpXY(Lbin(:,9)>0,:);
    DerPatTras=RightBackXY(Lbin(:,10)>0,:);
    DerPatSup=RightUpXY(Lbin(:,11)>0,:);
    % STATS
    StaFeats=[numstats2(Cola(:,1)), ...
    numstats2(Centro(:,1)), ...
    numstats2(Nariz(:,1)), ...
    numstats2(IzqPatTras(:,1)), ...
    numstats2(IzqPatSup(:,1)), ...
    numstats2(DerPatTras(:,1)), ...
    numstats2(DerPatSup(:,1)), ...
    numstats2(Cola(:,2)), ...
    numstats2(Centro(:,2)), ...
    numstats2(Nariz(:,2)), ...
    numstats2(IzqPatTras(:,2)), ...
    numstats2(IzqPatSup(:,2)), ...
    numstats2(DerPatTras(:,2)), ...
    numstats2(DerPatSup(:,2))];
    
    Archivo=f(1:indxlim-1);
    GuionBajo=strfind(Archivo,'_');
    MG=strfind(Archivo,'mg');
    Minute=round(str2double( Archivo(GuionBajo(end-1)+1:GuionBajo(end)-1) ));
    Date=Archivo(GuionBajo(2)+1:GuionBajo(3)-1);
    Dates=datetime(Date, 'Format', 'dd-M-yyyy');
    Dosis=round(str2double(Archivo(GuionBajo(1)+1:MG(1)-1)));

    %% TABLES OUTPUTS
    if i==1
        T=[]; % creates output Table
    end
    t=table(Dates,Dosis,Minute,StaFeats);
    T=[T;t];
    disp(T)

end
%% 
fprintf('\n>>Writing table:')
IndexSep=strfind(selpath,filesep);
Carpeta=selpath(IndexSep(end-1)+1:IndexSep(end)-1);
writetable(T,[selpath(1:IndexSep(end-1)),Carpeta,'_STATFEATS_TABLE.csv'],'WriteRowNames',true)
fprintf('done.\n')