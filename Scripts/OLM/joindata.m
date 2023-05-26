%% Joint tables

clear; clc;
runs=1;             % Runs Counter
auxc=1;             % Auxiliar Conditions
EXPS={};            % List Of Experiments

% Directory:
Dirpwd=pwd;
slashesindx=find(Dirpwd=='\');
CurrentPathOK=[Dirpwd(1:slashesindx(end)),'OLM Results Tables'];
% Load File 
[FileName,PathName,MoreFiles] = uigetfile('*.csv',['Select .csv file, ONE by ONE'],...
    'MultiSelect', 'off',CurrentPathOK);

TableActive=table;
%% Loop to keep loading files
fprintf('\nPress Cancel to stop Selecting.\n')
while MoreFiles
    x=readtable([PathName,FileName]);
    TableActive=[TableActive;x];
    EXPS{runs,1}=FileName
    CurrentPathOK=PathName;
    runs=runs+1;
    [FileName,PathName,MoreFiles] = uigetfile('*.csv',['Select .csv file, ONE by ONE'],...
    'MultiSelect', 'off',CurrentPathOK);
end
disp('>>end.')

%% SAVE

prompt={'Name of the condition:'};
name='SAVE TABLE AS:';
numlines=[1 50];
defaultanswer={'Group_'};
answer={};
while isempty(answer)
    answer=inputdlg(prompt,name,numlines,defaultanswer);
end

fprintf('\n>Saving table: ')
FileOutput=getDir2Save();

fprintf('\n@ %s\n',answer{1});
writetable(TableActive,[FileOutput,answer{1},'.csv'])
disp(TableActive);
