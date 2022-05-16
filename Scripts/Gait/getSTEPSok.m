function STPS=getSTEPSok(STePS_LR,STePS_RL)
%%
Nlr=numel(STePS_LR);
Nrl=numel(STePS_RL);
DLL=zeros(Nlr,Nrl);
DRR=zeros(Nlr,Nrl);
RighLimbStep=[];
LeftLimbStep=[];
MinInterLeftLim=[];
MinInterRightLim=[];
UpLeftLimb=[];
UpRightLimb=[];
LowLeftLimb=[];
LowRightLimb=[];
% figure
for i=1:Nlr
    xxyyLR=STePS_LR{i};
    for j=1:Nrl
        xxyyRL=STePS_RL{j};
        ll=get_distance([xxyyLR(1:2);xxyyRL(3:4)]);
        rr=get_distance([xxyyLR(3:4);xxyyRL(1:2)]);
        % Distances inter same-sided limbs at detected instances:
        DLL(i,j)=ll(2);  
        DRR(i,j)=rr(2);
        
        plot([xxyyLR(1),xxyyLR(3)],[xxyyLR(2),xxyyLR(4)],'m--','LineWidth',2);
        hold on;
        plot([xxyyRL(1),xxyyRL(3)],[xxyyRL(2),xxyyRL(4)],'k--','LineWidth',2);
%         plot([xxyyLR(1),xxyyRL(3)],[xxyyLR(2),xxyyRL(4)],'b-','LineWidth',2);
%         plot([xxyyLR(3),xxyyRL(1)],[xxyyLR(4),xxyyRL(2)],'g-','LineWidth',2);

        hold on;
        if i>1
            LS=get_distance([prexxyyLR(1:2);xxyyLR(1:2)]);
            RS=get_distance([prexxyyLR(3:4);xxyyLR(3:4)]);
%             fprintf('\n Up Left: %3.2f Low Right: %3.2f\n',LS(2),RS(2))
            plot([prexxyyLR(1),xxyyLR(1)],[prexxyyLR(2),xxyyLR(2)],'g-*')
            plot([prexxyyLR(3),xxyyLR(3)],[prexxyyLR(4),xxyyLR(4)],'g-.')
            if LS(2)>0
                UpLeftLimb=[UpLeftLimb;LS(2)];
            end
            if RS(2)>0
                LowRightLimb=[LowRightLimb;RS(2)];
            end
        end
        if j>1
            RS=get_distance([prexxyyRL(1:2);xxyyRL(1:2)]);
            LS=get_distance([prexxyyRL(3:4);xxyyRL(3:4)]);
%             fprintf('\n Low Left: %3.2f Up Right: %3.2f\n',LS(2),RS(2))
            plot([prexxyyRL(1),xxyyRL(1)],[prexxyyRL(2),xxyyRL(2)],'r-.')
            plot([prexxyyRL(3),xxyyRL(3)],[prexxyyRL(4),xxyyRL(4)],'r-*')
            if LS(2)>0
                LowLeftLimb=[LowLeftLimb;LS(2)];
            end
            if RS(2)>0
                UpRightLimb=[UpRightLimb;RS(2)];
            end
        end
        % Current steps
        prexxyyLR=xxyyLR;
        prexxyyRL=xxyyRL;
    end
    [dmin,IndxLL]=min(DLL(i,:));
    MinInterLeftLim=[MinInterLeftLim;dmin];
    RighLimbStep=[RighLimbStep;DRR(i,IndxLL)]; % inter right limbs
    [dmin,IndxRR]=min(DRR(i,:));
    LeftLimbStep=[LeftLimbStep;DLL(i,IndxRR)]; % inter right limbs
    MinInterRightLim=[MinInterRightLim;dmin];
%     pause
end

MinIntersame=mean([MinInterLeftLim;MinInterRightLim]);

UpLeftLimb=unique(UpLeftLimb(UpLeftLimb>MinIntersame));
UpRightLimb=unique(UpRightLimb(UpRightLimb>MinIntersame));
LowLeftLimb=unique(LowLeftLimb(LowLeftLimb>MinIntersame));
LowRightLimb=unique(LowRightLimb(LowRightLimb>MinIntersame));
STPS{1,1}=UpLeftLimb;
STPS{1,2}=UpRightLimb;
STPS{1,3}=LowLeftLimb;
STPS{1,4}=LowRightLimb;
% for i=1:Nlr
%     DLL(i,:)
%     
% end
% for j=1:Nrl
%     
% end