%% MAKE VOCAL - RASTERs
% 
% IT WORKS AT 2 MODES:
%   > Single File:    rows: intervals (user-defined "trials")
%   > Multiple Files: rows: files
% 
% Solved Issue: vocals are way too short so raster columns are
% bins of time and whose values are counts of vocalization (binary) and how long (color)
% 
% Input
%   Output files from DeepSqueck (xlsx)
%   User Interface:
%     Audio Sampling Frequency
%     Length of Audio in s
% Output (\outputCSVs)
%   Audio Times of volcalizations (CSV)
%   Binary Binned Raster Matrix (CSV)
%   Length Binned Raster Matrix (CSV)
% 
clear; clc;
% Read multiple file in a folder
[A,C]=uigetfile('*.xlsx','MultiSelect','on');
if ischar(A)
    N=1;
    Archs{1}=A;
    fprintf('\n>Single File Mode\n')
else
    N=numel(A);
    Archs=A;
    fprintf('\n>Multiple File Mode N=%i\n',N);
end
%% User Input
% Sampling [Hz]
prompt = {'Sampling Frequency [kHz]'};
dlgtitle = 'fs';
dims = [1 30];
definput = {'340'};
fsinput = inputdlg(prompt,dlgtitle,dims,definput);
fs=str2double(fsinput)*1000;
% Length Recording [s]
prompt = {'Length recording [minutes]'};
dlgtitle = 'min';
dims = [1 35];
definput = {'5'};
Linput = inputdlg(prompt,dlgtitle,dims,definput);
L=str2double(Linput)*60;
if N==1
    % Multiple Records Raster Width [secs]
    prompt = {'Raster  Trials/Segments [seconds]'};
    dlgtitle = 's';
    dims = [1 40];
    definput = {'60'};
    COLNUMinput = inputdlg(prompt,dlgtitle,dims,definput);
    rownum=round(L/str2double(COLNUMinput{1}));
end
% Window Raster [samples]
prompt = {'Raster bin length [s]'};
dlgtitle = 's';
dims = [1 45];
definput = {'0.5'};
COLNUMinput = inputdlg(prompt,dlgtitle,dims,definput);
w=str2double(COLNUMinput)*fs;
% w=Ns*fs;

%% Main Loop
if N>1
    Vall=zeros(N,L*fs/w);
    Nall=zeros(N,L*fs/w);
    Lall=zeros(N,L*fs/w);
end
for n=1:N
    fprintf('\n>Loading %s, ',Archs{n})
    DATA=readtable([C,Archs{n}]);
    fprintf('done.\n, ')
    % Use Begin & End Times
    Ta=DATA.BeginTime_s_;
    Tb=DATA.EndTime_s_;
    % Creat zero vectors 
    Dbin=zeros(1,L*fs/w); % Length of vocalization(s)
    Vbin=zeros(1,L*fs/w); % Binary (there was or not vocalizations)
    Nbin=zeros(1,L*fs/w); % Number of vocalizations
    % Vocalizations Loop
    for m=1:numel(Ta)
        fprintf('\n>Vocal #%i',m)
        a=round(Ta(m)*fs);
        b=round(Tb(m)*fs);
        l=DATA.CallLength_s_(m);        % length
        % V(a:b)=1;
        inicio=ceil(a/w);
        fin=ceil(b/w);
        if fin>L*fs/w
            fin=round(L*fs/w);
        end
        Vbin(inicio:fin)=1;              % If vocalization(s)
        Nbin(inicio:fin)=Nbin(inicio:fin)+1;  % N vocs
        Dbin(inicio:fin)=Dbin(inicio:fin)+l;  % Length
    end
    if N>1
        Vall(n,:)=Vbin;
        Nall(n,:)=Nbin;
        Lall(n,:)=Dbin;
    end
end
%% Outputs
if N==1
    Ncols=L/(w/fs)/rownum;
    Vraster=reshape(Vbin,Ncols,rownum)';
    Draster=reshape(Dbin,Ncols,rownum)';
    Nraster=reshape(Nbin,Ncols,rownum)';
    Plot_Raster(Vraster,w/fs);
    Plot_Raster(Draster,w/fs);
    Plot_Raster(Nraster,w/fs);
else
    Plot_Raster(Vall,w/fs);
    Plot_Raster(Lall,w/fs);
    Plot_Raster(Nall,w/fs);
    disp(table([1:N]',Archs','VariableNames',{'Rows','File Names'}));
end