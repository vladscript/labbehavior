% first and last frame
function [ta,tb]=findframes(X,LikeliTh,fps)
% All-Body-Part Likelihoods
L=[X.earleftl,X.earrightl,X.nosel,X.centerl,X.lateralleftl,X.lateralrightl,...
    X.tailbasel,X.tailendl];
Nparts=size(L,2);
Lbin=L>LikeliTh;
AllLs=sum(Lbin,2);
DoFindFrame=true;
LimMin=floor(X.FRAME(end)/fps/60-1)*60*fps;
while DoFindFrame
    tb=size(X,1);
    ta=find(AllLs==Nparts,1);
    if ~isempty(ta)
        tb_upsideodwn=find(AllLs(end:-1:1)==Nparts,1);
        tb=tb-(tb_upsideodwn-1);
    end
%     else
%         % default
%         ta=1;
%         tb=size(X,1);
%         fprintf('\n*** Check pose detecton ***\n')
%     end

    if (tb-ta)>LimMin    % more than 4 minuts
        DoFindFrame=false;
        fprintf('\n*** Check %i body parts ***\n',Nparts);
    else
        Nparts=Nparts-1;
    end
end

Total=((tb-ta)/fps)/60;
Minutos=floor(Total);
Segundos=(Total-Minutos)*60;
fprintf('\n>Interval of first and last correct ID of mouse: %i:%1.1f\n',Minutos,Segundos);