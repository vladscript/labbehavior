%% load data
% read csv from deeplabcut
clear; close all;
% aux=1;
[file,selpath]=uigetfile('*.csv','MultiSelect','on');
if ~iscell(file)
    F=file; clear file
    file{1}=F;
end

for i=1:numel(file)
    f=file{i};
    X=readdlctableLID([selpath,f]);
    Frames=size(X,1);
    %% Checking Likelihood
    L=[X.UpL,X.DownL,X.LeftL,X.RightL,X.TailL,X.CenterL,X.NoseL,X.LeftBackL,X.LeftUpL,X.RightBackL, X.RightUpL];
    Nparts=size(L,2);
    figure;
    subplot(311)
    hold on;
    for n=1:4
        histogram(L(:,n));
    end
    grid on
    axis tight
    ylabel('#')
    xlabel('likelihood')
    title('Cilinder')
    legend(X.Properties.VariableNames(4:3:13))
    
    
    subplot(312)
    hold on;
    for n=5:7
        histogram(L(:,n));
    end
    grid on
    axis tight
    ylabel('#')
    xlabel('likelihood')
    title('Axis')
    legend(X.Properties.VariableNames(16:3:22))
    
    
    subplot(313)
    hold on;
    for n=8:Nparts
        histogram(L(:,n));
    end
    grid on
    axis tight
    ylabel('#')
    xlabel('likelihood')
    title('Limbs')
    legend(X.Properties.VariableNames(25:3:34))
    
    indxlim=strfind(f,'DLC_mobnet');
    FLHs=gcf;
    FLHs.Name=sprintf('%s',f(1:indxlim-1));
    
    LHthres=0.6; % Likelihood Threshold
    Lbin=zeros(size(L));
    Lbin(L>LHthres)=1;
    % 1:4 Cylinder  X.UpL,X.DownL,X.LeftL,X.RightL
    % 5:7 Axis:     X.TailL,X.CenterL,X.NoseL
    % 8:11 Limbs    X.LeftBackL,X.LeftUpL,X.RightBackL, X.RightUpL
    %% Cylinder  and CM-PX convesion
    % Data
    Diameter=5*2; % [cm] MEASURED 5 cm radius/Paper AMAN |CLZ
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
    NoseXY=[X.NoseX/Xpx2cm,X.NoseX/Ypx2cm];         % [cm]
    CenterXY=[X.CenterX/Xpx2cm,X.CenterX/Ypx2cm];   % [cm]
    TailXY=[X.TailX/Xpx2cm,X.TailY/Ypx2cm];  % [cm]
    AxisIndx=find(prod(Lbin(:,[5:7]),2));
    FraccAxis=100*numel(AxisIndx)/numel(NoseXY); %->OUTPUT
    fprintf('\n Part of simulataneous detectin of Axis: %3.2f%%\n',FraccAxis)
    
    
    % Make Conversion to cm
    V1=NoseXY(AxisIndx,:)-CenterXY(AxisIndx,:); % Vector From Center to Nose
    V2=TailXY(AxisIndx,:)-CenterXY(AxisIndx,:); % Vector From Center to Tail
    % Magnitudes:
    magV1=sqrt(sum(V1.^2,2));
    magV2=sqrt(sum(V2.^2,2));
    AxialLength=magV1+magV2;        % Axis Length 
    % Angle
    costheta=dot(V1,V2,2)./(magV1.*magV2);
    % DIR=sign(costheta);
    AxialTheta=acosd(costheta);     % Axis Angle
    TurnCross=sign( cross([V1,zeros(size(V1,1),1)],[V2,zeros(size(V2,1),1)]) );
    PercLeft=100*sum(TurnCross(:,3)>0)/numel(AxisIndx); % Left OUTPUT 
    PercRight=100*sum(TurnCross(:,3)<0)/numel(AxisIndx); % Right OUTPUT 
    AxialTheta=AxialTheta.*TurnCross(:,3);
    %% Tail- Nose Euclidean Distance
    PeakAxialTheta=mostlikelyvalue(AxialTheta);
    PeakAxialLength=mostlikelyvalue(AxialLength);
    ModeAxialTheta=mode(AxialTheta);
    ModeAxialLength=mode(AxialLength);
    VarAxialLength=var(AxialLength);
    VarAxialTheta=var(AxialTheta);
    %% 
    figure
    subplot(121)
    histogram(AxialLength)
    xlabel('cm')
    grid on
    subplot(122)
    histogram(AxialTheta)
    xlabel('° Theta')
    grid on
    % figure; scatter(AxialLength,AxialTheta,[],X.FRAME(AxisIndx));
    %% FRAMES LOOP
    % for n=1:Frames
    %     % Axial Length and Angle
    %     
    %     % Limbs Lengts and Inner Angles
    % end
    %% TABLE OUTPUT
    if i==1
        T=[]; % creates output Table
    end
    t=table({f(1:indxlim-1)},FraccAxis,PercLeft,PercRight,PeakAxialTheta,ModeAxialTheta,VarAxialTheta,PeakAxialLength,ModeAxialLength,VarAxialLength);
    T=[T;t];
    disp(T)

end
%% 
fprintf('\n>>Writing table:')
indxlim=strfind(f,'_OF');
writetable(T,[selpath,f(1:indxlim-1),'_FEATURE_TABLE.csv'],'WriteRowNames',true)
fprintf('done.\n')