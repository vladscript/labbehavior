clc; clear; close all;
% Clean Excel files in single and useful sessions of GONOGO logs
%% SEE SCORES AND SESSIONS DATA
[F,D]=uigetfile('.xlsx');
fprintf('\n Reading:')
X=readtable([D,F],'NumHeaderLines',2);
H=readtable([D,F],'NumHeaderLines',1);
FN=H{1,18};                                         % Fecha de Nacimiento
PO=H{1,20};                                         % Peso Original
clear H;
H=readtable([D,F],'NumHeaderLines',0);
MouseID=H.Properties.VariableNames{10};             % Mouse ID
clear H;
fprintf('done.\n')
%% Data
% Set Axis
dts=X.Var1;                                         % Dates
tsl=X.Var3;                                         % Tiempo Sin aLimento
pesoi=X.Var10;                                      % Peso Inicial
pesof=X.Var14;                                      % Peso Inicial
VolJeringa=X.Var2;                                  % Minutos Sin Alimento (MSA)
MinSinAli=X.Var3;
Hits=X.Var11;                                       % Hits
Performance=X.Var12;                                % Performance
FA=Hits-Performance;                            % FA

EdadM=days(dts(1)-FN);                              % Edad en días

HoraInicio=datetime(X.Var15, "ConvertFrom", "excel",'Format','HH:mm');
HoraFinal=datetime(X.Var16, "ConvertFrom", "excel",'Format','HH:mm');
fprintf('\n%s\n>Edad: %i\n>Duración promedio de sesión %s',MouseID,EdadM,mean(HoraFinal-HoraInicio));
fprintf('\n>Duración total TASK %i días',days(dts(end)-dts(1)));

FechaInicio=datetime(year(dts),month(dts),day(dts),hour(HoraInicio),minute(HoraInicio),0,0);
FechaFin=datetime(year(dts),month(dts),day(dts),hour(HoraFinal),minute(HoraFinal),0,0);

InterSessionHours=hours(FechaInicio(2:end)-FechaFin(1:end-1)); % (ISH)
DeltaPerf=diff(Performance); % (DP)

[R_ISH_DP,P_ISH_DP]=corr(InterSessionHours,DeltaPerf);
% fprintf('\n>Correlación entre horas entre sesion y delta performace: %2.2f, P=%2.2f',R,P)
DeltaPeso=pesof-pesoi;

[R_MSA_P,P_MSA_P]=corr(MinSinAli,Performance);
% fprintf('\n>Correlación entre horas entre sesion y hits: %2.2f, P=%2.2f',R,P);

% [h,p]=ttest2(pesoi, pesof);
% [p,h]=signrank(pesoi,pesof,'tail','left')
[p_deltaPeso,h]=signrank(pesoi,pesof);
% fprintf('\n>Comparando peso inicial y final: p= %2.5f',p);

[ACR_Hits,L]=autocorr(Hits,numel(Hits)-1);
% fprintf('\n>Hits autocorrelation at L=1, R=%2.3f ',acc(2));
[ACR_P,L]=autocorr(Performance,numel(Performance)-1);
% fprintf('Performance autocorrelation at L=1, R=%2.3f',acc(2));
[ACR_Pi,L]=autocorr(pesoi,numel(pesoi)-1);
% fprintf('\n>Peso Inicial autocorrelation at L=1, R=%2.3f ',acc(2));
[ACR_Pf,L]=autocorr(pesof,numel(pesof)-1);
% fprintf('\n>Peso Final autocorrelation at L=1, R=%2.3f ',acc(2));

[ACR_DP,L]=autocorr(pesoi-pesof,numel(pesof)-1);
% fprintf('\n>Delta Peso autocorrelation at L=1, R=%2.3f \n',acc(2));

% histogram(Performance,[-100:5:100])
clear X;
%% Plots
figure;
% Hits, FA & Performance
subplot(211);
LinPerf=plot(dts,Performance); hold on;
LinHits=plot(dts,Hits); 
LinFA=plot(dts,FA); 
plot([dts(1),dts(end)],[75 75],'LineStyle','-.','LineWidth',2,'Color','red')
ylabel('%')
xlabel('dates')
hold off;
LinPerf.Marker='square';
LinPerf.LineWidth=2;
LinHits.Marker='square';
LinHits.LineWidth=2;
LinFA.Marker='square';
LinFA.Color='g';
LinFA.LineWidth=2;
grid on;
legend('Performance','Hits','FA','Location','east')
Ax=gca;
if numel(dts)>10
    Ax.XTick=dts([1,10:10:end]);
end
Ax.XTickLabelRotation=90;
Ax.YLim=[min([Performance;Hits;FA]),100];

ttl=title(sprintf('%s N sesiones: %i',MouseID,numel(dts)));
ttl.Interpreter='none';
% Ax.XTick=[];

% Weight
subplot(212);
yyaxis left
plot(dts,100*pesoi/PO,'Marker','o','LineWidth',2); hold on;
plot([dts(1),dts(end)],[80 80],'LineStyle','-.','LineWidth',2)
Ax=gca;
Ax.YLim=[50 100];
if numel(dts)>10
    % dtsTicks=[dts(1)-1,dts]
    Ax.XTick=dts([1,10:10:end]);
end
Ax.XTickLabelRotation=90;
ylabel(sprintf('%% of %2.2f g',PO))
yyaxis right
grid on;
plot(dts,pesof-pesoi,'Marker','o','LineWidth',2); hold on;
plot([dts(1),dts(end)],[0 0],'LineStyle','-.','LineWidth',2,'Color','red')
Ax=gca;
Ax.YLim=[-1.5 1.5];
ylabel('\Delta [g]')
% 
%% Export Data (.mat file)
Raton.ID=MouseID;   % ID
Raton.FN=FN;        % Birthday
Raton.PO=PO;        % grams
Raton.Edad=EdadM;   % days
DataRaton=table(FechaInicio,FechaFin,Hits,Performance,DeltaPeso,pesoi);
Correlations=[R_ISH_DP,P_ISH_DP;R_MSA_P,P_MSA_P];
% p_deltaPeso
AUTOC=[ACR_Hits(2),ACR_P(2),ACR_Pi(2),ACR_Pf(2),ACR_DP(2)];
fprintf('\n>Saving:')
save([D,MouseID,'.mat'],"Raton","DataRaton","Correlations","AUTOC","p_deltaPeso");
fprintf('done.\n')
fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See MAT file here</a>\n',D);
fprintf('\n After preview individual performances, run: >>GoNoGo_CurveGroup for group intel\n')