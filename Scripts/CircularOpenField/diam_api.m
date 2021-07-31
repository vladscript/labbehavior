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
function [Diameters,CnstntConv,Centers]=diam_api(VidName,PNsnap,FNsnap)
global distance; % Measures from 'imdistline'
global point1;
global point2;
DiamNames={'Horizontal','Vertical'};
Diameters=[0,0];
CnstntConv=[0,0];
Centers=[];
MEASURES; % Load Diameter Mesures
point1=1; point2=1;
for i=1:2 % make it Twice
    distance=0;
    while distance==0
        % Show Image
        SnapFig= figure('Name',...
            sprintf(' Trace %s diameter from %s snapshot',DiamNames{i},VidName),'Toolbar',...
            'none','NumberTitle','off','Menubar','none');
        % AxImage=image(SnapShot);
        imshow([PNsnap,FNsnap]);
        % hSP = imscrollpanel(SnapFig,AxImage);
        h=imdistline(gca);
        api = iptgetapi(h);
        fcn = makeConstrainToRectFcn('imline',...
                              get(gca,'XLim'),get(gca,'YLim'));
        %api.setPositionConstraintFcn(fcn);
        api.setDragConstraintFcn(fcn); 
        % api.setMagnification(0.5) % 2X = 200%
        % imoverview(AxImage)
        fprintf('\n  1. Trace %s Diameter',DiamNames{i})
        fprintf('\n  2. Right click on line to export and overwrite the variables:');
        fprintf('\n<<distance>>\n<<point1>>\n<<point2>>');
        fprintf('\n  3. and CLOSE snapshot figure\n')
        %     D=h.getDistance
        uiwait(SnapFig)
        % Reminder
        if distance==0
            msgbox(sprintf('Use right clic on line to Export %s diameter to workspace',DiamNames{i}));
        else
            fprintf('%s diameter: %3.1f pixels\n',DiamNames{i},distance)
            % Save Line Points
            Centers=[Centers;point1;point2];
        end
       
       % Choose size of diameter
       choice = questdlg('Measured diameter?', ...
            'Kind of Diameter', ...
            'Big (red)','Small (purple)','cancel','cancel');
        % Handle response
        switch choice
            case 'Big (red)'
                disp([choice ' diameter.'])
                cmConverse = BigDiameter;
            case 'Small (purple)'
                disp([choice ' diameter.'])
                cmConverse = SmallDiameter;
            case 'cancel'
                disp('Check again.')
                distance = 0;
        end
    end
    Diameters(i)=distance;
    CnstntConv(i)=cmConverse;
end