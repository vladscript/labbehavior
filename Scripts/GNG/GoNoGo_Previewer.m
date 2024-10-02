clc; clear; close all;
%% SEE SCORES AND SESSIONS DATA
[F,D]=uigetfile(pwd);
X=readtable([D,F],'NumHeaderLines',2);
H=readtable([D,F],'NumHeaderLines',1);
MouseID=H.Properties.VariableNames{10};
FN=H{1,18};
PO=H{1,20};
clear H;
%% Data
% Set Axis
dts=X.Var1; % Dates
tsl=X.Var3; % Tiempo Sin aLimento
pesoi=X.Var10; % Peso Inicial
pesof=X.Var14; % Peso Inicial
Hits=X.Var11;
Performance=X.Var12;
EdadM=days(dts(1)-FN);
clear X;
%% Plots
figure;
% Hits & Performance
[ax1,lin1, lin2]=plotyy(dts,Hits,dts,Performance);
lin1.Marker='square';
lin2.Marker='square';
lin1.LineWidth=2;
lin2.LineWidth=2;
grid on;
ax1(1).XTickLabelRotation=90;
ax1(1).YLabel.String='Hits';
ax1(2).YLabel.String='Performance';
ax1(1).YLim=[min(Performance),100];
ax1(2).YLim=[min(Performance),100];
ttl=title(sprintf('%s N sesiones: %i',MouseID,numel(dts)));
ttl.Interpreter='none';
%% Weight
figure; 
[ax1,lin1, lin2]=plotyy(dts,100*pesoi/PO,dts,pesof-pesoi);
lin1.Marker='square';
lin2.Marker='square';
lin1.LineWidth=2;
lin2.LineWidth=2;
grid on;
ax1(1).XTickLabelRotation=90;
ax1(1).YLabel.String='% Peso inicial';
ax1(2).YLabel.String='/Delta Peso';

ax1(1).YLim=[0,100];
% ax1(2).YLim=[min(Performance),100];
ttl=title(sprintf('%s N sesiones: %i',MouseID,numel(dts)));
ttl.Interpreter='none';
%% Export Data (to make global data base)