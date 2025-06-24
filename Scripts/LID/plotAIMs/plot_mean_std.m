% Plot Time Scores
% for N Inputs of AIMs Scores
% and Colors
function plot_mean_std(ColorsALL,Labels,bartype,varargin)
N=numel(varargin);
TimeAxis=[0:20:180];
% TimeAxis=[1:9];
AIMsTime=figure('Name',['Mean & ',bartype,' of AIMs Score'],'NumberTitle','off');
AIMsAxis=subplot(1,1,1);
Radius=0.5;
miniBar=0.5;
MaxAIM=0;
for n=1:N
    X=[zeros(size(varargin{n},1),1),varargin{n}];
    Nmice=size(X,1);
    Means=mean(X);
    STDs=std(X);
    SEM=STDs/sqrt(Nmice);
    LinesPlots(n)=plot(AIMsAxis,TimeAxis,Means,'Color','k','LineWidth',4,...
        'Color',ColorsALL(n,:));
    hold(AIMsAxis,'on')
    for t=1:10
        % Mean CIRCLES ******************************************
        Position=[TimeAxis(t)-Radius,Means(t)-Radius/2,2*Radius,Radius];
        rectangle('Position',Position,'Curvature',[1 1],...
            'FaceColor',ColorsALL(n,:),'LineWidth',2)
        % Error BARS ******************************
        switch bartype
            case 'SEM'
                plot([TimeAxis(t),TimeAxis(t)],[Means(t)-SEM(t),Means(t)+SEM(t)],...
                    'Color','k')
                % Mini Upper and Lower Bars
                plot([TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
                    [Means(t)+SEM(t),Means(t)+SEM(t)],'Color','k','LineWidth',1)
                plot([TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
                    [Means(t)-SEM(t),Means(t)-SEM(t)],'Color','k','LineWidth',1)
                if max(Means+SEM)>MaxAIM
                    MaxAIM=max(Means+SEM);
                end
            case 'STD'
                plot([TimeAxis(t),TimeAxis(t)],[Means(t)-STDs(t),Means(t)+STDs(t)],...
                    'Color','k')
                % Mini Upper and Lower Bars
                plot([TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
                    [Means(t)+STD(t),Means(t)+SEM(t)],'Color','k','LineWidth',1)
                plot([TimeAxis(t)-miniBar,TimeAxis(t)+miniBar],...
                    [Means(t)-STD(t),Means(t)-SEM(t)],'Color','k','LineWidth',1)
                if max(Means+STDs)>MaxAIM
                    MaxAIM=max(Means+STDs);
                end
        end
        
    end
end
legend(LinesPlots,Labels);
grid(AIMsAxis,'on');
AIMsAxis.YLim=[-Radius,10*ceil(MaxAIM/10)];
AIMsAxis.XLim=[-Radius,200];
AIMsAxis.XTickLabel=0:20:200;
disp('>>Ready')