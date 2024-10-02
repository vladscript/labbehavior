function task = getdatagng(GNGfolder)
fprintf('\n>Loading: .')
D1=csvread([GNGfolder,filesep,'data_1.csv']);
D2=csvread([GNGfolder,filesep,'data_2.csv']);
D3=csvread([GNGfolder,filesep,'data_3.csv']);
fprintf('.')
D4=csvread([GNGfolder,filesep,'data_4.csv']);
D5=csvread([GNGfolder,filesep,'data_5.csv']);
D6=csvread([GNGfolder,filesep,'data_6.csv']);
fprintf('. complete.\n')
task=zeros(max([length(D1) length(D2) length(D3) length(D4) length(D5) length(D6)]),6);
task(1:length(D1),1)=D1;
task(1:length(D1),2)=D2;
task(1:length(D1),3)=D3;
task(1:length(D1),4)=D4;
task(1:length(D1),5)=D5;
task(1:length(D1),6)=D6;