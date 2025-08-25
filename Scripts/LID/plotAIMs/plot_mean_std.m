% Plot Time Scores
% for N Inputs of AIMs Scores
% and Colors
function plot_mean_std(DATAAIMs,Labels,bartype)
[N, ColorsALL]=ColorsAIMs(Labels);
TimeAxis=20:20:180;
% TimeAxis=[1:9];
AIMsTime=figure('Name',['Mean & ',bartype,' of AIMs Score'],'NumberTitle','off');
AIMsAxis=subplot(1,3,[1 2]);
TotalAIMsAxis=subplot(1,3,3);
SizeMarker=10;
Radius=0.5;
miniBar=2;
MaxAIM=0;
TotalAIMs=[];
AllLLbs={};
for n=1:N
    % X=[zeros(size(varargin{n},1),1),varargin{n}];
    X=table2array(DATAAIMs{n}(:,4:end));
    TotalVlaues=sum(X,2);
    TotalAIMs=[TotalAIMs;TotalVlaues];    
    Nmice=size(X,1);
    lbls=repmat({Labels{n}},Nmice,1);
    AllLLbs=[AllLLbs;lbls];
    Means=mean(X);
    
    
    COL(n,:)=ColorsALL{n};
    hold(AIMsAxis,'on')
    LinesPlots(n)=plot(AIMsAxis,TimeAxis,Means,'Color','k','LineWidth',2,...
        'Color',ColorsALL{n});
    for t=1:numel(TimeAxis)
        % Mean CIRCLES ******************************************
%         Position=[TimeAxis(t)-Radius,Means(t)-Radius/2,2*Radius,Radius];
%         rectangle('Position',Position,'Curvature',[1 1],...
%             'FaceColor',ColorsALL{n},'LineWidth',2)
        plot(AIMsAxis,TimeAxis(t),Means(t),'Marker','o','MarkerSize',SizeMarker,...
            'MarkerEdgeColor','k','MarkerFaceColor',ColorsALL{n})
        % Error BARS ******************************
        switch bartype
            case 'SEM'
                VARR=std(X)/sqrt(Nmice);
            case 'STD'
                VARR=std(X);
        end
        plot(AIMsAxis,[TimeAxis(t),TimeAxis(t)],[Means(t)-VARR(t),Means(t)+VARR(t)],...
            'Color',ColorsALL{n})
        % Mini Upper and Lower Bars
        plot(AIMsAxis,[TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
            [Means(t)+VARR(t),Means(t)+VARR(t)],'Color',ColorsALL{n},'LineWidth',1)
        plot(AIMsAxis,[TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
            [Means(t)-VARR(t),Means(t)-VARR(t)],'Color',ColorsALL{n},'LineWidth',1)
        if max(Means+VARR)>MaxAIM
            MaxAIM=max(Means+VARR);
        end
    end
    % Dotas at boxplots
    hold(TotalAIMsAxis,'on');
    for m=1:Nmice
        plot(TotalAIMsAxis,n,TotalVlaues(m),'Marker','o','MarkerSize',3,...
            'MarkerEdgeColor','k','MarkerFaceColor','k');
    end
    
end
legend(LinesPlots,Labels);
grid(AIMsAxis,'on');
AIMsAxis.YLim=[0,10*ceil(MaxAIM/10)];
AIMsAxis.XLim=[0,200];
% AIMsAxis.XTickLabel=0:20:200;

% Boxplots
boxplot(TotalAIMsAxis,TotalAIMs,AllLLbs,'Widths',0.5,"Colors",COL,'FullFactors','on');
grid(TotalAIMsAxis,'on');

AIMsAxis.XLabel.String='min';
AIMsAxis.YLabel.String='Global AIMs Score';
TotalAIMsAxis.YLabel.String='Sum of Global AIMs Score';
disp('>>Ready')