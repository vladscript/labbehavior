function [indxRL,indxLR]=closeperpslopes(mRL,mLR)
indxRL=[];
indxLR=[];
if numel(mRL)>2 && numel(mLR)>2
    fprintf('>Enough strides detected\n')
    [smRL,wRL]=ModeSlope(mRL);
    [smLR,wLR]=ModeSlope(mLR);
    % SLOPES oF digonal strides must be closer to perpednicuñar
    aux=1;
    indxs=[];
    for i=1:numel(smRL)
        for j=1:numel(smLR)
            Modedist(aux)=abs(smRL(i))-abs(smLR(j));
            indxs=[indxs;i,j];
            aux=aux+1;
        end
    end
    [~,i]=min(abs(Modedist));
    indxRL=indxs(i,1);
    indxLR=indxs(i,2);
    fprintf('>Right-Left Stride slope %3.2f +/- %3.2f\n',...
        smRL(indxRL),wRL(indxRL)/2);
    fprintf('>Left-Right Stride slope %3.2f +/- %3.2f\n',...
        smLR(indxLR),wLR(indxLR)/2);
%     disp('ok')
    indxRL=slopesinrange(smRL(indxRL)-wRL(indxRL)/2,smRL(indxRL)+wRL(indxRL)/2,mRL);
    indxLR=slopesinrange(smLR(indxLR)-wLR(indxLR)/2,smLR(indxLR)+wLR(indxLR)/2,mLR);
else
    fprintf('>Missing strides \n')
end
%% Nested funcitons
    function [slopesmodes,ws]=ModeSlope(Mslopes)
        [px,xbin]=ksdensity(Mslopes,linspace(min(Mslopes),max(Mslopes),100));
        if numel(px)>2
            [~,slopesmodes,ws]=findpeaks(px,xbin);
        else
            slopesmodes=[];
        end
    end
    function indx=slopesinrange(minw,maxw,allslopes)
        indx=[];
        for k=1:numel(allslopes)
            if allslopes(k)>minw && allslopes(k)<maxw
                indx=[indx;k];
                fprintf('*')
            end
        end
        fprintf('\n')
    end
end