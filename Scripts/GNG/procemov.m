function [zmOK,zmOKS,Turns,RZ]=procemov(mov)
% 
zm=zscore(mov);                     % z-score of sensor signal
zdm=zscore(derifilter(mov));        % Speed
dirm=sign(zdm);                     % direction
% Mov=cumsum(derifilter(zm).*dirm);   % Accumulated Distance
% plot(derifilter(Mov))

[~,PosPk]=findpeaks(zdm,"Threshold",mean([0 max(zdm)]));
[~,NegPk]=findpeaks(-zdm,"Threshold",-mean([0 min(zdm)]));

Giros=ones(size([PosPk;NegPk]));
GirosINdx=sort([PosPk;NegPk]);
[~,Binx]=intersect(GirosINdx,NegPk);
Giros(Binx)=-1;
Giros(end+1)=Giros(end);
GirosINdx=unique([GirosINdx;numel(zm)+1]);
%% Main Loop
a=1;
zmOK=zeros(size(zm));
zmOKS=zmOK;
zPre=0;
zsPre=0;
for n=1:numel(Giros)
    fprintf('\n Giro: %i/%i',n,numel(Giros))
    b=GirosINdx(n);
    z=zm(a:b-1);
    RZ(n)=range(z);
%     if n==108 % 2-bug
%         disp('stop')
%     end
    if numel(z)>3
        zs=smiith(z,0.01);
    else
        zs=z;
    end
%     plot(z); hold on
%     plot(sz,'LineWidth',2); 
%     hold off;
%     axis tight; grid on;

    if n>1
        if Giros(n)>0
            zmOK(a:b-1)=z-z(1)+zPre;
            zmOKS(a:b-1)=zs-zs(1)+zsPre;
        else
            zmOK(a:b-1)=-z+z(1)+zPre;
            zmOKS(a:b-1)=-zs+zs(1)+zsPre;
        end
    else
        zmOK(a:b-1)=z;
    end
    zPre=zmOK(b-1);
    zsPre=zmOK(b-1);
%     plot(zmOK(1:b-1))
%     title(sprintf('Ventana: %i Cambio: %1.1f, Giro: %i',n,z(1)-z(end)),Giros(n))

    a=b;
    fprintf('\n')
%     pause;
end

Turns=Giros.*GirosINdx;