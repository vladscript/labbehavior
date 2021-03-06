% clear; clc;
% global distance;
% global point1;
% global point2;
% 
% n=1
% VidNames{n}='IMG_0063rotOK.MOV';
% [FNsnap{n},PNsnap] = uigetfile('*.png',sprintf('Snapshot from %s video',VidNames{n}),...
%     'MultiSelect', 'off',pwd);
% VidName=VidNames{n};
% [Diameters,CnstntConv,Centers]=diam_api(VidName,PNsnap,FNsnap{n}); % distance

%%
% Shows iamge and use distance line API to get diameters of OpenField
% Input
%   VidName:    String: name of the video snapshot (Vid1_XXX.mp4)
%   PNsnap:     String Folder path directory (C:\...\)
%   FNsnap:     String File Name of the snaphot (IMAGE01.png)
% Output
%   Diameters:  Vector where:
%               Diameters(1): Horizontal Diameter
%               Diameters(2): Vertical Diameter
%   CnstntConv: Constante centimeter conversion
%               CnstntConv(1): For Width
%               CnstntConv(2): For Height
function [Lengths,Centers]=borders_api(VidName,PNsnap,FNsnap)
global distance; % Measures from 'imdistline'
global point1;
global point2;
BarNames={'Superior Border','Inferior Border'};
Lengths=[0,0];
% CnstntConv=[0,0];
Centers=[];
% BRIDGEMEASURE; % loads BridgeWidth var
point1=1; point2=1;
for i=1:2 % make it Twice
    distance=0;
    while distance==0
        % Show Image
        SnapFig= figure('Name',...
            sprintf(' Trace %s diameter from %s snapshot',BarNames{i},VidName),'Toolbar',...
            'none','NumberTitle','off','Menubar','none');
        % AxImage=image(SnapShot);
        imshow([PNsnap,FNsnap]);
        % hSP = imscrollpanel(SnapFig,AxImage);
        if i==1
            h=imdistline(gca);
        else
            h=imdistline(gca,[point1(1),point2(1)],[point1(2),point2(2)]);
        end
        api = iptgetapi(h);
        fcn = makeConstrainToRectFcn('imline',...
                              get(gca,'XLim'),get(gca,'YLim'));
        %api.setPositionConstraintFcn(fcn);
        api.setDragConstraintFcn(fcn); 
        % api.setMagnification(0.5) % 2X = 200%
        % imoverview(AxImage)
        fprintf('\n  1. Trace %s ',BarNames{i})
        fprintf('\n  2. Right click on line to export and overwrite the variables:');
        fprintf('\n<<distance>>\n<<point1>>\n<<point2>>');
        fprintf('\n  3. and CLOSE snapshot figure\n')
        %     D=h.getDistance
        uiwait(SnapFig)
        % Reminder
        if distance==0
            msgbox(sprintf('Use right clic on line to Export %s diameter to workspace',BarNames{i}));
        else
            fprintf('%s diameter: %3.1f pixels\n',BarNames{i},distance)
            % Save Line Points
            Centers=[Centers;point1;point2];
        end
    end
    Lengths(i)=distance;
%     CnstntConv(i)=cmConverse;
end