%% Load Several GoNoGopreviews of a Group
clc; clear; % close all;
[f,D]=uigetfile('MultiSelect','on','.mat');
for i=1:numel(f)
    % Load and alligne curves
    load([D,f{i}])
    Nsess(i)=size(DataRaton,1);
    P{i}=DataRaton.Performance;
    H{i}=DataRaton.Hits;
    M{i}=DataRaton.Hits-DataRaton.Performance;
    ID{i}=Raton.ID;
    % E(i)=Raton.Edad;
end
%%
PG=NaN*ones(numel(f),max(Nsess));
HG=PG;
MG=PG;

for i=1:numel(f)
    PG(i,1:numel(P{i}))=P{i};
    HG(i,1:numel(H{i}))=H{i};
    MG(i,1:numel(M{i}))=M{i};
end

%% Plots
% plot(mean(PG,'omitnan')); hold on
% plot(mean(HG,'omitnan')); 
% plot(mean(MG,'omitnan')); hold off
figure;
PGline=errorbar(mean(PG,'omitnan'),std(PG,'omitnan')./sqrt(numel(f))); hold on;
HGline=errorbar(mean(HG,'omitnan'),std(HG,'omitnan')./sqrt(numel(f))); 
MGline=errorbar(mean(MG,'omitnan'),std(MG,'omitnan')./sqrt(numel(f))); 
plot([0,max(Nsess)+1],[75 75],'LineStyle','-.')
hold off;

PGline.LineWidth=2;
PGline.Marker='o';
HGline.LineWidth=2;
HGline.Marker='o';
MGline.LineWidth=2;
MGline.Marker='o';

ylabel('%')
xlabel('Sessions')
grid on;
legend('Performance','Hits','FAs','Location','northwest')