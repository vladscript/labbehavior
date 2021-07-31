% Call Directories where ALL scripts are
%% ADDING ALLSCRIPTS
fprintf('\n>>Loading Scripts for Behavior: ')
if exist('get_distance.m','file')
    fprintf('already ')
else
    ActualDir=pwd;
    addpath(genpath([ActualDir,'\Scripts']))
end
fprintf('done.\n\n')