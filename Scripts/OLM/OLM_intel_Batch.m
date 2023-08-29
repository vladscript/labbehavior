%% To do
% 1) Make colormap only for neighbouhood of the objects
% FILES BACTH ANLAYSIS
% Trajectory
% Conditons of rejected/accepted explorations

%% load data
% read csv from deeplabcut
clear;
[file,selpath]=uigetfile('*.csv','MultiSelect','on');
if ~iscell(file)
    F=file; clear file
    file{1}=F;
end

% INSERT CONDITION ????

%% SETUP 
% DEFAULT VALUES
% Minimum distance to objects to consider an interaction:
Dclose=1.3262;                  % cm
prompt={'cm:'};
name='Interaction Threshold:';
numlines=[1 50];
defaultanswer={num2str(Dclose)};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
Dclose= str2double(answer{1});

% Likelihood Threshold for DLC detections
LikeliTh=0.9;
% Seconds to measure velocity
ws=1;           % s
% Size of the neighbourhood of the objects:
Nsize=6;

% Acquisition rate
fps=30;                 % Hz: default frames per second (user input)
prompt={'fps:'};
name='Rate:';
numlines=[1 50];
defaultanswer={num2str(fps)};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
fps= str2double(answer{1});

% Acquisition rate

prompt={'Condition:'};
name='Condition:';
numlines=[1 50];
defaultanswer={'condition'};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end
Condition = answer{1};

% Size of the Field (FIXED)
VerticalLenght=30;      % cm
HorizontalLenght=30;    % cm

%% MAIN LOOP
for i=1:numel(file)
    f=file{i};
    fprintf('>Loading %s',f)
    X=readdlctableOLM([selpath,f]); % READ DATA
    [ta,tb]=findframes(X,LikeliTh,fps);
    X=X(ta:tb,:);
    fprintf('\n')
    [TotalFrames,COLS]=size(X);
    
    Nparts=round((COLS-1)/3);
    OkIndx= find(X.nosel>=LikeliTh);
    nookinde=setdiff(1:size(X,1),OkIndx);
    DiscarFrames=TotalFrames -   numel(OkIndx);
    PrcDiscFrames=100*(DiscarFrames/TotalFrames);
    fprintf('>%s  \n>Nose likelihood threshold: %3.3f \n> %i interpolated frames: %3.1f %% of the video.',f,LikeliTh,DiscarFrames,PrcDiscFrames)
    %% Nose & Body Coordinates
    fprintf('\n>Reading all nose/body coordinates:')
    tnose=X.FRAME;
    Xnose=X.nosex;
    Ynose=X.nosey;
    Xnose=interbadpoint(Xnose,nookinde,10);
    Ynose=interbadpoint(Ynose,nookinde,10);

    Xlatleft=X.lateralleftx;
    Ylatleft=X.laterallefty;
    indx2inter=find(X.lateralleftl<LikeliTh);
    Xlatleft=interbadpoint(Xlatleft,indx2inter,10);
    Ylatleft=interbadpoint(Ylatleft,indx2inter,10);

    Xlatright=X.lateralrightx;
    Ylatright=X.lateralrighty;
    indx2inter=find(X.lateralrightl<LikeliTh);
    Xlatright=interbadpoint(Xlatright,indx2inter,10);
    Ylatright=interbadpoint(Ylatright,indx2inter,10);

    Xcenter=X.centerx;
    Ycenter=X.centery;
    indx2inter=find(X.centerl<LikeliTh);
    Xcenter=interbadpoint(Xcenter,indx2inter,10);
    Ycenter=interbadpoint(Ycenter,indx2inter,10);

    fprintf(' ready.\n')
    %% Field Area:
    
    % Get the most likely coordinates
    xtop=X.topx(X.topl>LikeliTh);
    Xtop=mostlikelyvalue(xtop);
    ytop=X.topy(X.topl>LikeliTh);
    Ytop=mostlikelyvalue(ytop);
    
    xrig=X.rightx(X.rightl>LikeliTh);
    Xrig=mostlikelyvalue(xrig);
    yrig=X.righty(X.rightl>LikeliTh);
    Yrig=mostlikelyvalue(yrig);
    
    xlef=X.leftx(X.leftl>LikeliTh);
    Xlef=mostlikelyvalue(xlef);
    ylef=X.lefty(X.leftl>LikeliTh);
    Ylef=mostlikelyvalue(ylef);
    
    xdow=X.downx(X.downl>LikeliTh);
    Xdow=mostlikelyvalue(xdow);
    ydow=X.downy(X.downl>LikeliTh);
    Ydow=mostlikelyvalue(ydow);
    
    % Horizontal
    leftLim=[Xlef,Ylef];
    rightLim=[Xrig,Yrig];
    % Vertical
    topLim=[Xtop,Ytop];
    bottomLim=[Xdow,Ydow];
    
    AreaDs=get_distance([bottomLim;topLim;leftLim;rightLim]);
    VertDistance=AreaDs(2);
    HorrtDistance=AreaDs(4);
    
    fprintf('>>Area diameters: of:\n>Vertical: %3.2f px \n>Horizontal: %3.2f px\n',VertDistance,HorrtDistance);
    % Constants to convert to cm ###########################################
    yratio=VerticalLenght/VertDistance; % [cm/px]
    xratio=HorizontalLenght/HorrtDistance; % [cm/px]
    %% OBJECTS A & B
    CenterArea=mean([leftLim;rightLim; topLim;bottomLim]);
    Cx=CenterArea(1);
    
    fprintf('\n Searching Object A [left]')
    okL=find(sum([X.oa1l>LikeliTh, X.oa2l>LikeliTh,X.oa3l>LikeliTh,X.oa4l>LikeliTh],2)==4);
    okCx=find(sum([X.oa1x<Cx, X.oa2x<Cx, X.oa3x<Cx, X.oa4x<Cx],2)==4);
    okA=intersect(okL, okCx);
    xoa1=X.oa1x(okA);
    yoa1=X.oa1y(okA);
    xoa2=X.oa2x(okA);
    yoa2=X.oa2y(okA);
    xoa3=X.oa3x(okA);
    yoa3=X.oa3y(okA);
    xoa4=X.oa4x(okA);
    yoa4=X.oa4y(okA);
    pgonA=rectangleobject(xoa1,yoa1,xoa2,yoa2,xoa3,yoa3,xoa4,yoa4);
    fprintf('\n')
    fprintf('\nSearching Object B [right]')
    okL=find(sum([X.ob1l>LikeliTh, X.ob2l>LikeliTh,X.ob3l>LikeliTh,X.ob4l>LikeliTh],2)==4);
    okCx=find(sum([X.ob1x>Cx, X.ob2x>Cx, X.ob3x>Cx, X.ob4x>Cx],2)==4);
    okB=intersect(okL, okCx);
    xob1=X.ob1x(okB);
    yob1=X.ob1y(okB);
    xob2=X.ob2x(okB);
    yob2=X.ob2y(okB);
    xob3=X.ob3x(okB);
    yob3=X.ob3y(okB);
    xob4=X.ob4x(okB);
    yob4=X.ob4y(okB);
    pgonB=rectangleobject(xob1,yob1,xob2,yob2,xob3,yob3,xob4,yob4);
    fprintf('\n')
    
    PA=polygonperimeter(pgonA,xratio,yratio);
    PB=polygonperimeter(pgonB,xratio,yratio);

    fprintf('>>Perimeters: of:\n>Object A: %3.2f px -> %3.2f cm \n>Object B: %3.2f px -> %3.2f cm \n',pgonA.perimeter,PA,pgonB.perimeter,PB);
    %% Distance from Nose/Other Parts to Objects
    Npoints=numel(Xnose);
    fprintf('\n>Measuring distances: .')
    for i=1:Npoints
        x=Xnose(i)*xratio; y=Ynose(i)*yratio;
        [dA(i),x_polyA(i),y_polyA(i)] = p_poly_dist(x, y, pgonA.Vertices(:,1)*xratio, pgonA.Vertices(:,2)*yratio);
        [dB(i),x_polyB(i),y_polyB(i)] = p_poly_dist(x, y, pgonB.Vertices(:,1)*xratio, pgonB.Vertices(:,2)*yratio);
        %plot(x,y,'ko')
        % LEFT PART OF THE MOUSE
        xl=Xlatleft(i)*xratio; yl=Ylatleft(i)*yratio;
        [dlA(i),~,~] = p_poly_dist(xl, yl, pgonA.Vertices(:,1)*xratio, pgonA.Vertices(:,2)*yratio);
        [dlB(i),~,~] = p_poly_dist(xl, yl, pgonB.Vertices(:,1)*xratio, pgonB.Vertices(:,2)*yratio);
        
        % RIGHT PART OF THE MOUSE
        xr=Xlatright(i)*xratio; yr=Ylatright(i)*yratio;
        [drA(i),~,~] = p_poly_dist(xr, yr, pgonA.Vertices(:,1)*xratio, pgonA.Vertices(:,2)*yratio);
        [drB(i),~,~] = p_poly_dist(xr, yr, pgonB.Vertices(:,1)*xratio, pgonB.Vertices(:,2)*yratio);

    end
    fprintf('.. done.')
    fprintf('~Negative distance means overlapping -> discarding frames:\n');
    % Nose
    OLa=overlapobjectframes(dA,Dclose);
    OLb=overlapobjectframes(dB,Dclose);

    % Left part
    OLla=overlapobjectframes(dlA,Dclose);
    OLlb=overlapobjectframes(dlB,Dclose);

    % Right part
    OLra=overlapobjectframes(dlA,Dclose);
    OLrb=overlapobjectframes(dlB,Dclose);
    
    NoverA=size([OLa;OLla;OLra],1);
    NoverB=size([OLb;OLlb;OLrb],1);
    
    
    % Discarded overlapping frames
    disA=[]; tdisA=0;
    if NoverA>0
        for n=1:NoverA
            disA=[disA,OLa(n,1):OLa(n,2)];
            tdisA=tdisA+OLa(n,3);
        end
    end
    
    disB=[]; tdisB=0;
    if NoverB>0
        for n=1:NoverB
            disB=[disB,OLb(n,1):OLb(n,2)];
            tdisB=tdisB+OLb(n,3);
        end
    end
    
    
    % N Interactions
    % Continuous intervasl under threshold:
    IA=interactobjectframes(dA,Dclose);
    IB=interactobjectframes(dB,Dclose);
    
    NinterA=size(IA,1)-NoverA;
    NinterB=size(IB,1)-NoverB;
    
    %  CALCULATIONS **************************
    interA=setdiff(find(dA<Dclose),disA);
    interB=setdiff(find(dB<Dclose),disB);
    TotalInter=numel(interA)+numel(interB);
    
    prefA=numel(interA)/(TotalInter)*100;
    prefB=numel(interB)/(TotalInter)*100;
    fprintf('>Total Interaction (<%2.1f cm)with A and B objects: %3.2f seconds',Dclose,TotalInter/fps);
    fprintf('\n>A object: %3.2f %%',prefA);
    fprintf('\n>B object: %3.2f %%\n',prefB);
    fprintf('\n>Minimum interaction-distance to Object A: %3.2f cm\n',min(dA(interA)));
    fprintf('>Minimum interaction-distance to Object B: %3.2f cm\n',min(dB(interB)));

    %% Motor stuff
    
    % velthres=20;    % cm/s
    
    % Total Distance %statistics: mean, 
    t=X.FRAME*(1/fps); % TIME IN SECONDS
    [Xsmoothnose,Ysmoothnose]=smoothpath(t,Xnose,Ynose);
    d=get_distance([Xsmoothnose*xratio,Ysmoothnose*yratio]);
    TotalDistance=sum(d(2:end)); % [cm]
    
    % Rate of movement
    drate=get_velocity_interval(d,ws,fps);
    velthres=median(drate); % cm/s
    tvel=[0:numel(drate)-1]*ws; % [s]
    
    [AMP,TIMES]=boufinder(drate,tvel,velthres);
    

    %% Generate OUTPUT

    fprintf('\n>Saving table: ')
    FileOutput=selpath;
    indxmark=strfind(f,'DLC');
    if isempty(indxmark)
        indxmark=strfind(f,'resnet');
    end
    VidID{1}=f(1:indxmark-1);
    Name=[f(1:indxmark-1),'_OLMintel.csv'];
    
    fprintf('%s',Name);
    
    Rtable=table(VidID,{Condition},Dclose,ta,tb, ...
        TotalInter/fps,prefA,prefB, ...
        NinterA,NinterB,numel(disA)/fps,numel(disB)/fps,NoverA,NoverB,...
        TotalDistance,ws,...
        median(drate),numel(TIMES),median(AMP),TotalFrames/fps,...
        yratio,xratio,PA,PB,PrcDiscFrames);
    
    Rtable.Properties.VariableNames={'Video_ID','Condition','Threshold_cm','Frame_A','Frame_B'...
            'TotaTimeInter_s','A_percent','B_percent',...
            'N_inter_A','N_inter_B','OverlapA_s','OverlapB_s','N_over_A','N_over_B',...
            'TotalDistance_cm','WindowTime_s','MedianVelWin_cm_s','N_Bouts','MedianVelBout_cm_s','VideoLength_s',...
            'yratio_cm_px','xratio_cmp_px','A_perimeter_cm','B_perimeter_cm','Frames_Interpolated_percent'};
    
    fprintf('\n@ %s\n',FileOutput);
    writetable(Rtable,[FileOutput,Name])
    disp(Rtable);

    %% OUPUT FIG

    plotdots()

end
fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See CSV files Here</a>\n',selpath);
%% END