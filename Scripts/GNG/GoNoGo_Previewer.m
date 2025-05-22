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
VolJeringa=X.Var2;
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

InterSessionHours=hours(FechaInicio(2:end)-FechaFin(1:end-1)); % Horas Entre Sesiones
DeltaPerf=diff(Performance);

[R,P]=corr(InterSessionHours,DeltaPerf);
fprintf('\n>Correlación entre horas entre sesion y delta performace: %2.2f, P=%2.2f',R,P)
DeltaPeso=pesof-pesoi;

[R,P]=corr(MinSinAli,Performance);
fprintf('\n>Correlación entre horas entre sesion y hits: %2.2f, P=%2.2f',R,P);

% [h,p]=ttest2(pesoi, pesof);
% [p,h]=signrank(pesoi,pesof,'tail','left')
[p,h]=signrank(pesoi,pesof);
fprintf('\n>Comparando peso inicial y final: p= %2.5f',p);

[acc,L]=autocorr(Hits,numel(Hits)-1);
fprintf('\n>Hits autocorrelation at L=1, R=%2.3f ',acc(2));
[acc,L]=autocorr(Performance,numel(Performance)-1);
fprintf('Performance autocorrelation at L=1, R=%2.3f',acc(2));
[acc,L]=autocorr(pesoi,numel(pesoi)-1);
fprintf('\n>Peso Inicial autocorrelation at L=1, R=%2.3f ',acc(2));
[acc,L]=autocorr(pesof,numel(pesof)-1);
fprintf('\n>Peso Final autocorrelation at L=1, R=%2.3f ',acc(2));

[acc,L]=autocorr(pesoi-pesof,numel(pesof)-1);
fprintf('\n>Delta Peso autocorrelation at L=1, R=%2.3f \n',acc(2));

% histogram(Performance,[-100:5:100])
clear X;
%% Plots
figure;
% Hits, FA & Performance
subplot(221);
LinPerf=plot(dts,Performance); hold on;
LinHits=plot(dts,Hits); 
LinFA=plot(dts,FA); 
plot([dts(1),dts(end)],[75 75],'LineStyle','-.')
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
legend('Performance','Hits','FA','Location','northwest')
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
subplot(223);
yyaxis left
plot(dts,100*pesoi/PO,'Marker','o','LineWidth',2); hold on;
plot([dts(1),dts(end)],[80 80],'LineStyle','-.')
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
plot([dts(1),dts(end)],[0 0],'LineStyle','-.')
ylabel('\Delta [g]')

% Performance vs Delta Weight
[R,P]=corr(Performance,pesof-pesoi);
fprintf('>Correlation between Delta Weight & Performace R=%5.2f P=%1.5f',R,P);

[R,P]=corr(Hits,pesof-pesoi);
fprintf('\n>Correlation between Delta Weight & Hits R=%5.2f P=%1.5f',R,P);

subplot(222);
scatter(Performance,pesof-pesoi,[],1:numel(dts),'filled')
grid on;
xlabel('Performance')
ylabel('\Delta Weight')
cb=colorbar;
cb.Label.String='Sesiones';
Ax=gca;
% Ax.XTick=[];
% Performance vs Dia Sin Alimento
subplot(224);
scatter(Hits,pesof-pesoi,[],1:numel(dts),'filled')
grid on;
xlabel('Hits')
ylabel('\Delta Weight')
cb=colorbar;
cb.Label.String='Sesiones';

%% Export Data (to make global data base)
Raton.ID=MouseID;
Raton.FN=FN;        % Birthday
Raton.FN=PO;        % grams
Raton.Edad=EdadM;   % days
DataRaton=table(FechaInicio,FechaFin,Hits,Performance,DeltaPeso);
fprintf('\n>Saving:')
save([D,MouseID,'.mat'],"Raton","DataRaton");
fprintf('done.\n')
fprintf('<a href="matlab:dos(''explorer.exe /e, %s, &'')">See MAT file here</a>\n',D);
