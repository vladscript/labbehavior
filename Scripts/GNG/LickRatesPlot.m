%% Load Folder analized by Gamas Software
% SETUP
% Mouse Folder must be contain Sessions Folders
clear;
checkFolders=true;
Tall=table;
GNGfolder=uigetdir(pwd,'Mouse Sessions Folder');
list=dir(GNGfolder);
OKdir=[];
ListNames={};
aux=1;
for i=1:numel(list)
    if list(i).isdir  && (~or(strcmp('.',list(i).name),strcmp('..',list(i).name)))
        OKdir=[OKdir;i];
        ListNames{aux}=list(i).name;
        ListDirs{aux}=list(i).folder;
        aux=aux+1;
    else
        fprintf('*')
    end
end
fprintf('\n')
[foldsess,ok]=listdlg('PromptString',{'Select Folder Sessions',...
        'Sessions Data',''},...
        'SelectionMode','multiple','ListString',ListNames);
FolderNameSessions=ListNames(foldsess);
FolderSessions=ListDirs(foldsess);
%% Do 2 cd  to _SessionXXXX
for i=1:numel(FolderSessions)
    CurrDir=FolderSessions{i};
    CarpetsIndx=strfind(CurrDir,filesep);
    ID_Mouse=CurrDir(CarpetsIndx(end)+1:end);
    % Get Session Variable
    load([CurrDir,filesep,FolderNameSessions{i},...
        filesep,sprintf('%s_Sess_An',FolderNameSessions{i}),filesep,...
        sprintf('Session_%s.mat',FolderNameSessions{i})]);
    t=table({ID_Mouse},i,Session.performance,Session.Hits,Session.FA,...
        array2table(Session.Go_Rates),array2table(Session.Nogo_Rates));
    Tall=[Tall;t];
    disp(Tall)
end
%% Final Plot
figure
plot(Tall.i,Tall.Var6.Var1,'Color',[0,0.9,0],'LineWidth',3); hold on;
plot(Tall.i,Tall.Var6.Var2,'Color',[0,0.5,0],'LineWidth',2); 
plot(Tall.i,Tall.Var6.Var3,'Color',[0,0.2,0],'LineWidth',1); 

plot(Tall.i,Tall.Var7.Var1,'Color',[0.9,0,0],'LineWidth',3); 
plot(Tall.i,Tall.Var7.Var2,'Color',[0.5,0,0],'LineWidth',2); 
plot(Tall.i,Tall.Var7.Var3,'Color',[0.2,0,0],'LineWidth',1); hold off;

legend('GOstart','AnticipatoryGO','postGO','NOGOstart','AnticipatoryNOGO','postNOGO')
ylabel('Lick rate (Hz)')
xlabel('Sessions')
grid on
t=title(ID_Mouse);
t.Interpreter="none";
%% Save Table / 
fprintf('\n>Saving table:')
writetable(splitvars(Tall),[CurrDir,filesep,'LickRates_',ID_Mouse,'.csv']);
fprintf('done.\n')
