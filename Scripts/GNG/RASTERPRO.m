%% Read Table from GET RASTER
clear;
clc;
% close all;
%% cSV files
[fileS,path] = uigetfile({'*.csv'},'File Selector','MultiSelect', 'on');
if ischar(fileS)
    F=fileS;
    fileS={}
    fileS{1}=F;
end
%% FILES LOOP
A=[];
B=[];
C=[];
D=[];
% FATRANtrend=[];
Ns=11;
for i=1:numel(fileS)
    
    X=readtable([path,fileS{i}]);
    XcellsCTRL{i}=table2array(X(:,4:end));
    if i==1
        Names=X.Properties.VariableNames;
    end
    a=X.P(end:-1:1);
    b=X.BestPerfo(end:-1:1);
%     a=X.MISSpercTRAN(end:-1:1);
%     b=X.FAperTRAN(end:-1:1);
    c=X.BestTrial;
    d=X.FAperTRAN;
    if i>1
        if size(a,1)<size(A,1)
            A=[A,[a;nan*ones(size(A,1)-size(a,1),1)]];
            B=[B,[b;nan*ones(size(A,1)-size(a,1),1)]];
            C=[C,[c;nan*ones(size(A,1)-size(a,1),1)]];
            D=[D,[d;nan*ones(size(A,1)-size(a,1),1)]];
        elseif size(a,1)>size(A,1)
            % disp('stop')
            A=[[A;nan*ones(size(a,1)-size(A,1),size(A,2))],a];
            B=[[B;nan*ones(size(b,1)-size(B,1),size(B,2))],b];
            C=[[C;nan*ones(size(c,1)-size(C,1),size(C,2))],c];
            D=[[D;nan*ones(size(d,1)-size(D,1),size(D,2))],d];
        else
            A=[A,a];
            B=[B,b];
            C=[C,c];
            D=[D,d];
        end
    else
        A=[A,a];
        B=[B,b];
        D=[D,d];
    end
    
    
    figure;
    subplot(121)
    bar([X.FAperTRAN(end:-1:1)'; X.FAperREP(end:-1:1)']','stacked');
    legend('Transición','Repetición')
    ylabel('% of False Alarms')
    xlabel('session')
    grid on;
    t=title(X.ID{1});
    t.Interpreter='none';
    subplot(122)
    bar([X.MISSpercTRAN(end:-1:1)'; X.MISSpercREP(end:-1:1)']','stacked');
    legend('Transición','Repetición')
    ylabel('% of Misses')
    xlabel('session')
    grid on;

%     FATRANtrend=[FATRANtrend;X.FAperTRAN(end:-1:end-Ns+1)'];

%     pause
end

%%
figure;
bar(mean(D,2,'omitnan'))
axis tight; grid on;
ylabel('% of FA when transition')
hold on
xlabel('session')
plot(mean(D,2,'omitnan'),'LineWidth',2)
plot(D,'Color',[0.9,0.9,0.9])
%% Session Loop 
for i=1:size(A,1)
    a=A(i,:);
    b=B(i,:);
    % [h(i),p(i)]=signtest(a,b);
    [pf(i),hf(i)]=signrank(a,b,'tail','left')
%     columns2boxplot(a,b,{'total','best'})
%     pause
end

fprintf('done\n')

%% Plots
figure
errorbar(1:size(A,1),mean(A','omitnan'),std(A','omitnan'))
hold on
errorbar(1:size(A,1),mean(B','omitnan'),std(B','omitnan'))
grid on 
figure; 
histogram(C(:))
grid on
ylabel('Counts')
xlabel('# Trial')
title('Trial con el mejor performance')
%% PARAMETERS LOOP

% figure
% for i=1:size(Xcells6OHDA{1},2)
% 
% end

% %% OTHER
% [fileS,path] = uigetfile({'*.csv'},'File Selector','MultiSelect', 'on');
% 
% 
% % FILES LOOP
% NsessMax6OHDA=0;
% for i=1:numel(fileS)
%     X=readtable([path,fileS{i}]);
%     Xcells6OHDA{i}=table2array(X(:,4:end));
%     if i==1
%         Names=X.Properties.VariableNames;
%     end
%     if size(X,1)>NsessMax6OHDA
%         NsessMax6OHDA=size(X,1);
%     end
% end
% 
% 
% Names=Names(4:end);
% %% PARAMETERS LOOP
% 
% figure
% for i=1:size(Xcells6OHDA{1},2)
%     DATA_c=nan*ones(NsessMaxCTRL,numel(fileS));
%     DATA_6=nan*ones(NsessMaxCTRL,numel(fileS));
%     for j=1:numel(fileS)
%         xc=XcellsCTRL{j}(:,i);
%         x6=Xcells6OHDA{j}(:,i);
%         DATA_c(1:size(xc,1),j)=xc(end:-1:1);
%         DATA_6(1:size(x6,1),j)=x6(end:-1:1);
%         plot(xc(end:-1:1),'Color',[0.0,0.0,0.5],'LineWidth',0.5); hold on;
%         plot(x6(end:-1:1),'Color',[0.0,0.5,0.0],'LineWidth',0.5);
%         
%     end
%     plot(median(DATA_c,2,'omitnan'),'Color','blue','LineWidth',2); hold on;
%     plot(median(DATA_6,2,'omitnan'),'Color','green','LineWidth',2)
%     title(Names(i));
%     hold off;
%     pause
% end
% 
% %% Sessions Loop
% XC=[];
% X6=[];
% % for i=1:numel(XcellsCTRL) % loop
% %     for j=1:min(NsessMax6OHDA,NsessMaxCTRL)
% %     XcellsCTRL{i}()
% % 
% %     
% % end
% 
% % for i=1:min(NsessMax6OHDA,NsessMaxCTRL)
% %     end
% % end
% 
% 
% 
% 

