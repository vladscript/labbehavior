function [indxRL,indxLR]=closeperpslopes(mRL,mLR,R2Lstride,L2Rstride)
indxRL=[];
indxLR=[];
epsislope=0.1;
if numel(mRL)>5 && numel(mLR)>5
    fprintf('>Enough strides detected\n')
    [smRL,wRL]=ModeSlope(mRL);
    [smLR,wLR]=ModeSlope(mLR);
    % SLOPES oF digonal strides must be closer to perpednicuñar
    aux=1;
    indxs=[];
    Modedist=[];
    for i=1:numel(smRL)
        for j=1:numel(smLR)
            Modedist(aux)=abs(smRL(i))-abs(smLR(j));
            indxs=[indxs;i,j];
            aux=aux+1;
        end
    end
    %     [~,i]=min(abs(Modedist));
    diffslist=abs(Modedist);
    if numel(Modedist)>1
        [minlist,minindx]=find(diffslist<=epsislope);
        if isempty(minlist)
            [minlist,minindx]=min(diffslist);
        end
    else
        minlist=Modedist;
        minindx=1;
    end
    
    for j=1:numel(minlist)
        fprintf('\n>Checking slope peaks of %3.2f & %3.2f',...
            smRL(indxs(minindx(j),1)),smLR(indxs(minindx(j),2)))
        % Intervlas RL
%         find(mRL>smRL(indxs(minindx(j),1))-wRL(indxs(minindx(j),1))/2)
%         find(mRL<smRL(indxs(minindx(j),1))+wRL(indxs(minindx(j),1))/2)
        Equis=[R2Lstride(intersect(find(mRL>smRL(indxs(minindx(j),1))-wRL(indxs(minindx(j),1))/2),...
            find(mRL<smRL(indxs(minindx(j),1))+wRL(indxs(minindx(j),1))/2)),1);L2Rstride(intersect(find(mLR>smLR(indxs(minindx(j),2))-wLR(indxs(minindx(j),2))/2),...
            find(mLR<smLR(indxs(minindx(j),2))+wLR(indxs(minindx(j),2))/2)),1)];
        if isempty(Equis)
            Equis=[R2Lstride(intersect(find(mRL>smRL(indxs(minindx(j),1))-wRL(indxs(minindx(j),1))),...
            find(mRL<smRL(indxs(minindx(j),1))+wRL(indxs(minindx(j),1)))),1);L2Rstride(intersect(find(mLR>smLR(indxs(minindx(j),2))-wLR(indxs(minindx(j),2))),...
            find(mLR<smLR(indxs(minindx(j),2))+wLR(indxs(minindx(j),2)))),1)];
        end
        % Xvar(j)=var(Equis);
        Xvardiff(j)=abs(max(Equis)-min(Equis));
%         xi=find(minlist==minlist(j));
    end
    [~,auxX]=max(Xvardiff);
    indxRL=indxs(minindx( auxX ),1);
    indxLR=indxs(minindx( auxX ),2);
    widthslope=max([wRL(indxRL),wLR(indxLR)]);
    fprintf('>Right-Left Stride slope %3.2f +/- %3.2f\n',...
        smRL(indxRL),widthslope);
    fprintf('>Left-Right Stride slope %3.2f +/- %3.2f\n',...
        smLR(indxLR),widthslope);
%     disp('ok')
    indxRL=slopesinrange(smRL(indxRL)-widthslope,smRL(indxRL)+widthslope,mRL);
    indxLR=slopesinrange(smLR(indxLR)-widthslope,smLR(indxLR)+widthslope,mLR);
else
    fprintf('>Few strides detected\n')
    indxRL=slopesinrange(min(mRL),max(mRL),mRL);
    indxLR=slopesinrange(min(mLR),max(mLR),mLR);
end
%% Nested funcitons
    function [slopesmodes,ws]=ModeSlope(Mslopes)
        [px,xbin]=ksdensity(Mslopes,linspace(min(Mslopes),max(Mslopes),50));
        if numel(px)>2
            [~,slopesmodes,ws]=findpeaks(px,xbin);
            if isempty(slopesmodes)
                slopesmodes=mean(xbin);
                ws=max(xbin)-min(xbin);
            end
        else
            % slopesmodes=[];
            slopesmodes=mean(ModeSlope);
        end
    end
    function indx=slopesinrange(minw,maxw,allslopes)
        indx=[];
        for k=1:numel(allslopes)
            if allslopes(k)>=minw && allslopes(k)<=maxw
                indx=[indx;k];
                fprintf('*')
            end
        end
        fprintf('\n')
    end
end