%% Load Several GoNoGopreviews of a Group
clc; clear; % close all;
[f,D]=uigetfile('MultiSelect','on','.mat');
%% Merge Data
Tfeatures=table;
DR=table; % Data Raton ALL
for i=1:numel(f)
    % Load and alligne curves
    load([D,f{i}])
    Nsess(i)=size(DataRaton,1);
    DR=[DR;[repmat({Raton.ID},Nsess(i),1),table([1:Nsess(i)]'),DataRaton]];
    P{i}=DataRaton.Performance;
    [maxP,maxS]=max(DataRaton.Performance);
    H{i}=DataRaton.Hits;
    M{i}=DataRaton.Hits-DataRaton.Performance;
    % ID{i}=Raton.ID;
    Pinit{i}=100*DataRaton.pesoi/Raton.PO;
    DP{i}=DataRaton.DeltaPeso;
    t=table({Raton.ID},Raton.Edad,Raton.PO,maxP,maxS,mean(DataRaton.pesoi),mean(DataRaton.DeltaPeso),...
        Correlations(1,1),Correlations(1,2),Correlations(2,1),Correlations(2,2),...
        AUTOC(1),AUTOC(2),AUTOC(3),AUTOC(4),AUTOC(5),p_deltaPeso);
    Tfeatures=[Tfeatures;t];
end

FNames={'ID','Age_days','OrigWeight_g','Max_Per','Max_Per_Sess','AVG_Pi','AVG_DP'...
    'Corr_ISH_SP','p_val1','Corr_MSA_Pi','p_val2',...
    'AC_Hits','AC_Per','AC_Pi','AC_Pf','AC_DP','PVAL_DP'};
Tfeatures.Properties.VariableNames=FNames;
%% Numerical treatments
PG=NaN*ones(numel(f),max(Nsess));
HG=PG;
MG=PG;
Peso=PG;
DeltaPeso=PG;

for i=1:numel(f)
    PG(i,1:numel(P{i}))=P{i};
    HG(i,1:numel(H{i}))=H{i};
    MG(i,1:numel(M{i}))=M{i};
    Peso(i,1:numel(Pinit{i}))=Pinit{i};
    DeltaPeso(i,1:numel(DP{i}))=DP{i};
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
legend('Performance','Hits','FAs','Location','east')

figure;
% Initial Weight
PGline=errorbar(mean(Peso,'omitnan'),std(Peso,'omitnan')./sqrt(numel(f)));
hold on;
plot([0,max(Nsess)+1],[75 75],'LineStyle','-.')
PGline.LineWidth=2;
PGline.Marker='o';
ylabel(sprintf('%% of Original Weight'))
Ax=gca;
Ax.YLim=[0 100];
% Delta Weight
yyaxis right
HGline=errorbar(mean(DeltaPeso,'omitnan'),std(DeltaPeso,'omitnan')./sqrt(numel(f))); 
hold on;
plot([0,max(Nsess)+1],[mean(DeltaPeso(:)) mean(DeltaPeso(:))],'LineStyle','-.')
HGline.LineWidth=2;
HGline.Marker='o';
ylabel('g')
xlabel('Sessions')
Ax=gca;
Ax.YLim=[-1.5 1.5];
grid on
title('Weight')
%% Export CSVs
fprintf('\n>Saving table:')
writetable(Tfeatures,[D,filesep,'GroupTable_features','.csv'])
writetable(DR,[D,filesep,'GroupTable_DATA','.csv'])
fprintf('done.\n')
%% CORRELATIONS GROUPS
fprintf('\n Group Correlations;')

% ISH       vs  DeltaPerformance/DeltaHits

InterSessionHours=hours(DR.FechaInicio(2:end)-DR.FechaFin(1:end-1)); % (ISH)
ModeISH=mode(InterSessionHours(InterSessionHours>0));
MaxISH=max(InterSessionHours(InterSessionHours>0));
DPer=diff(DR.Performance);
Dhit=diff(DR.Hits);
indxOK=find(InterSessionHours>0); % Ignore inter mice intervals
[R_1,P_1]=corr(InterSessionHours(indxOK),DPer(indxOK));
[R_2,P_2]=corr(InterSessionHours(indxOK),Dhit(indxOK));

% Texts
fprintf('\n>Inter Sessions Hours: mode: %2.2f and max: %2.2f: vs ',ModeISH,MaxISH);
fprintf('\n %%Delta Performance: R=%2.2f P=%2.2f',R_1,P_1)
fprintf('\n %%Delta Hits : R=%2.2f P=%2.2f',R_2,P_2)

% DeltaPeso vs  Performance/Hits
[R_3,P_3]=corr(DR.DeltaPeso,DR.Performance);
[R_4,P_4]=corr(DR.DeltaPeso,DR.Hits);

% Texts
ModeDP=mode(DR.DeltaPeso);
MaxDP=max(DR.DeltaPeso);
fprintf('\n>Weight [g] change in session : mode: %2.2f and max: %2.2f: vs ',ModeDP,MaxDP);
fprintf('\n %% Performance: R=%2.2f P=%2.2f',R_3,P_3)
fprintf('\n %% Hits : R=%2.2f P=%2.2f\n',R_4,P_4)

figure
subplot(221);
scatter(InterSessionHours(indxOK),DPer(indxOK),[],DR.Var1(indxOK),'filled')
grid on;
xlabel('\Delta Hours Inter Sessions')
ylabel('\Delta % Performance')
cb=colorbar;
cb.Label.String='Sesiones';
% Ax=gca;

subplot(222);
scatter(InterSessionHours(indxOK),Dhit(indxOK),[],DR.Var1(indxOK),'filled')
grid on;
xlabel('\Delta Hours Inter Sessions')
ylabel('\Delta % Hits')
cb=colorbar;
cb.Label.String='Sesiones';
% Ax=gca;

subplot(223);
scatter(DR.DeltaPeso,DR.Performance,[],DR.Var1,'filled')
grid on;
xlabel('Session \Delta [g]')
ylabel('% Performance')
cb=colorbar;
cb.Label.String='Sesiones';

subplot(224);
scatter(DR.DeltaPeso,DR.Hits,[],DR.Var1,'filled')
grid on;
xlabel('Session \Delta [g]')
ylabel('% Hits')
cb=colorbar;
cb.Label.String='Sesiones';
%% 
fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See MAT file here</a>\n',D);
fprintf('\n See individual sessions per animal, run: >>GETRASTER\n')