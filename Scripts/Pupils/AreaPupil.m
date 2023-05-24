%% AREAPUPIL
[file,selpath]=uigetfile('*.csv')
dataXY = importxypupil([selpath,file]);
LkTh=.6;
%% Checkin Eye Likelihood
l1l=dataXY.pupil_top_L;
l2l=dataXY.pupil_bot_L;
l3l=dataXY.pupil_left_L;
l4l=dataXY.pupil_right_L;
figure; 
ksdensity(l1l); hold on;
ksdensity(l2l);
ksdensity(l3l);
ksdensity(l4l);  hold off;
grid on;
title('Detection likelihood pupil')
pause(2)
close gcf

%% Chosing Area Proxy
N=dataXY.frames(end)+1;
% Frames for Square
sQRl=[l1l>LkTh,l2l>LkTh,l3l>LkTh,l4l>LkTh];
SqrFrames=find(sum(sQRl,2)==4);
% Frames for Triangle
tRl=[l2l>LkTh,l3l>LkTh,l4l>LkTh];
TrFrames=find(sum(tRl,2)==3);

fprintf('\n>Detected Frames %3.2f%% []\n',100*numel(SqrFrames)/N)
fprintf('\n>Detected Frames %3.2f%% |>\n',100*numel(TrFrames)/N)

%% LOOP
fprintf('\n>Measuring Area:')
NframesOK=numel(TrFrames);
for n=1:NframesOK
    i=TrFrames(n);
    f(n)=dataXY.frames(i)+1; % starts @ 0
    P=polyshape([dataXY.pupil_top_X(i),dataXY.pupil_left_X(i),dataXY.pupil_right_X(i)],[[dataXY.pupil_top_Y(i),dataXY.pupil_left_Y(i),dataXY.pupil_right_Y(i)]]);
    A(n)=P.area;
end
fprintf(' complete.\n')
%% Save
fprintf('\n>Sav')
ednindx=strfind(file,'mobnet');
save([selpath,file(1:ednindx-1),'AREA_PUPIL'],'A','f');
fprintf('ed\n')