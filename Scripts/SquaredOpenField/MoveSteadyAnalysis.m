%% Read Files
[FileNameANS,PathName] = uigetfile('*.mat','Select CSV files',...
'MultiSelect', 'on',pwd);

if isstr(FileNameANS)
    FNbuff=FileNameANS;
    FileNameANS={};
    FileNameANS{1}=FNbuff;
    fprintf('single file')
else
    fprintf('list of files')
end
%% LOOP FILES
pci=1;
pcj=2;

TABLA=table;
for ifiles=1:numel(FileNameANS)
    % Load pose coordinates
    FileName=FileNameANS{ifiles};
    load([PathName,FileName]);
    
    indxmove=find(Xparts(:,end)>0);
    indxsteady=find(Xparts(:,end)<1);
    Xsmove=Xsmoothpanza(indxmove);
    Xssteady=Xsmoothpanza(indxsteady);
    Ysmove=Ysmoothpanza(indxmove);
    Yssteady=Ysmoothpanza(indxsteady);

    Xmov=Xparts(indxmove,1:2*numel(PartsSave));
    Xste=Xparts(indxsteady,1:2*numel(PartsSave));

    % ALL PARTS
%     PoI={'nariz','cuello','oreja_d','oreja_i','base_cola','pata_frontal_d','pata_frontal_i','pata_inferior_d','pata_inferior_i','panza'};
    % NO BELLY
    % PoI={'nariz','cuello','oreja_d','oreja_i','base_cola','pata_frontal_d','pata_frontal_i','pata_inferior_d','pata_inferior_i'};
    % ONLY LIMBS
    % PoI={'pata_frontal_d','pata_frontal_i','pata_inferior_d','pata_inferior_i'};
    % ONLY HEAD
    PoI={'nariz','cuello','oreja_d','oreja_i'};
    % LIMBS and POSE
    % PoI={'cuello','base_cola','pata_frontal_d','pata_frontal_i','pata_inferior_d','pata_inferior_i','panza'};
    xindex=find(ismember(PoI,PartsSave));
    yindex=find(ismember(PoI,PartsSave))+1;
    filtidx=[xindex,yindex];

    % REMOVE TRAJECTORY
    % Xmov(:,xindex)=Xmov(:,xindex)-repmat(Xsmove,1,numel(xindex));
    % Xmov(:,yindex)=Xmov(:,yindex)-repmat(Ysmove,1,numel(yindex));
    % Xste(:,xindex)=Xste(:,xindex)-repmat(Xssteady,1,numel(xindex));
    % Xste(:,yindex)=Xste(:,yindex)-repmat(Yssteady,1,numel(yindex));

    
    subplot(121)
    NPCmov=explorpca(Xmov(:,filtidx),pci,pcj);
    subplot(122)
    NPCste=explorpca(Xste(:,filtidx),pci,pcj);
    gcf; colormap parula
    t=table({FileName},NPCmov,NPCste);
    TABLA=[TABLA;t];
    disp(TABLA)
    pause
    % plotXY(Xmov(:,filtidx),PoI)
    % plotXY(Xste(:,filtidx),PoI)
end

%% Distance to Smoothed Position
% 
% Dmov=distanceto(Xmov(:,filtidx),[Xsmove,Ysmove]);
% figure
% explorpca(Dmov,3,2)
% 
% Dste=distanceto(Xste(:,filtidx),[Xssteady,Yssteady]);
% figure
% explorpca(Dste,3,2)
% 
% figure
% explorpca([Dste;Dmov],1,2)