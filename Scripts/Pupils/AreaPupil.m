%% TO DO

% 2) Plots of A and save Threshold and Likelihoods
% 3) decide if Area or  Length between lines among the eye
% 4) Eyes Size; Blinks; Eye Movement

%% READ CSV DATA (Multiple Files)
% Likelihood input:
LxThres=inputdlg({'DLC likelihood threshold'},'Set',[1 35],{'0.6'});
LkTh=str2double(LxThres{1});
% FILE NAMES: until user gets thems
indx=0;
while indx==0
    [file,selpath,indx]=uigetfile('*.csv','MultiSelect','on');
end

if ~iscell(file)==1
    fileBuff=file;
    clear file;
    file{1}=fileBuff;
    clear fileBuff;
end
Nfiles=numel(file);
fprintf('\n>Reading %i DLC files and filtering detections with Likelihood=%1.1f',Nfiles,LkTh);
%% MAIN LOOP
PupilDots={'top','bottom','left','right'};
ColNumX=[2,5,11,8];
ColNumY=ColNumX+1;
for n=1:Nfiles
    f=file{n};
    fprintf('\n >Loading file: %s',f);
    dataXY = importxypupil([selpath,f]);
    fprintf('\n loaded.');
    %% Checkin Eye Likelihood
    l1l=dataXY.pupil_top_L;
    l2l=dataXY.pupil_bot_L;
    l3l=dataXY.pupil_left_L;
    l4l=dataXY.pupil_right_L;
    figure; 
    ax1=subplot(1,1,1);
    histogram(l1l,10); hold on;
    histogram(l2l,10);
    histogram(l3l,10);
    histogram(l4l,10); hold off;
    grid on;
    title('Detection of pupils')
    ylabel('# frames')
    xlabel('likelihood')
    ax1.YScale='log';
    ax1.XLim=[0 1];
    legend(PupilDots);
    %% Chosing Area/Axis as Proxy of Pupil Size
    N=dataXY.frames(end)+1;
    % Binary MAtrix of Pupil Detection above likelihood threshold
    sQRl=[l1l>LkTh,l2l>LkTh,l3l>LkTh,l4l>LkTh];
    [DotsCombs,PctFrames]=percetnframesok(sQRl);
    [~,inx]=max(100*PctFrames); % BEST==More Frames
    for i=1:numel(DotsCombs)
        fprintf('\n Dots: ')
        for j=1:numel(DotsCombs{i})
            fprintf('%s ',PupilDots{DotsCombs{i}(j)});
        end
        fprintf('%% frames detected: %3.2f',100*PctFrames(i));
        if i==inx
            fprintf('            ***');
        end
    end
    % Chosing best:
    Dots=DotsCombs{inx};
    TrFrames=find(sum(sQRl(:,Dots),2)==2);
    %% LOOP
    Ndots=numel(Dots);
    if Ndots>2
        fprintf('\n>Measuring Area:')
    else
        fprintf('\n>Measuring stuff:')
    end
    % NframesOK=numel(TrFrames);
    EYE_X=[];
    EYE_Y=[];
    h = waitbar(0,'Getting pupil metrics...');
    for m=1:N
        % PUPIL Size
        xpoints=table2array(dataXY(m,ColNumX(Dots)));
        ypoints=table2array(dataXY(m,ColNumY(Dots)));
        if Ndots==4
            indxsorting=[1,3,2,4]; % to prevente uplicate vertices, intersections, or other inconsistencies 
            P=polyshape(xpoints(indxsorting),ypoints(indxsorting));
        elseif Ndots==3
            P=polyshape(xpoints,ypoints); % TRIANGLES
            A(m)=P.area;
        else % AXIS
            A(m)=twopartsdistance([xpoints(1),ypoints(1)],[xpoints(2),ypoints(2)]);
        end
        % EYE Size
        Xeye=[dataXY.lid_top_X(m),dataXY.corner_left_X(m),dataXY.lid_bot_X(m),dataXY.corner_right_X(m)];
        Yeye=[dataXY.lid_top_Y(m),dataXY.corner_left_Y(m),dataXY.lid_bot_Y(m),dataXY.corner_right_Y(m)];
        EYE_X=[EYE_X;Xeye ];
        EYE_Y=[EYE_Y;Yeye ];
        EYE_center(m,:)=[mean(Xeye,2),mean(Yeye)];
        % Check Likelihoods!!!
        
        if and(and(dataXY.lid_top_L(m)>=LkTh,dataXY.corner_right_L(m)>=LkTh),and(dataXY.lid_bot_L(m)>=LkTh,dataXY.corner_left_L(m)>=LkTh))
%             Peye(m)=polyshape([dataXY.lid_top_X(m),dataXY.corner_left_X(m),dataXY.lid_bot_X(m),dataXY.corner_right_X(m)],...
%                 [dataXY.lid_top_Y(m),dataXY.corner_left_Y(m),dataXY.lid_bot_Y(m),dataXY.corner_right_Y(m)]);
            Peye(m)=polyshape(Xeye,Yeye);
            Peyearea(m)=Peye(m).area;
        else
            Peyearea(m)=NaN;
        end
        % Distance between lid and bot
        if and(dataXY.lid_top_L(m)>=LkTh,dataXY.lid_bot_L(m)>=LkTh)
            Blink(m)=twopartsdistance([dataXY.lid_top_X(m),dataXY.lid_top_Y(m)],[dataXY.lid_bot_X(m),dataXY.lid_bot_Y(m)]);
        else
            Blink(m)=NaN;
        end
        % fprintf('\n%3.2f',100*m/N);

        % Centroids Pupil Eye
        Centers_Pupil(m,:)=[mean(table2array(dataXY(m,[ColNumX]))),mean(table2array(dataXY(m,[ColNumY])))];
        
        % Eye Polygon



        waitbar(m/N,h);
    end
    EYE_AVGPOSITION=[mean(EYE_X,"omitnan"),mean(EYE_Y,"omitnan")];
    EYE_STDPOSITION=[std(EYE_X,"omitnan"),std(EYE_Y,"omitnan")];
    close(h);
    FramesOK=dataXY.frames(TrFrames)+1;
    fprintf(' complete.\n')
    %% Save
    fprintf('\n>Sav')
    DotsName=PupilDots(Dots);
    LHvec=prod(sQRl(:,Dots),2);
    ednindx=strfind(f,'mobnet');
    save([selpath,f(1:ednindx-1),'AREA_PUPIL'],'A','FramesOK','Ndots','LkTh',...
        'LHvec','Peyearea','Blink','DotsName','Centers_Pupil','EYE_center',...
        'EYE_AVGPOSITION','EYE_STDPOSITION');
    fprintf('ed\n')
end
%% END ###################################################################