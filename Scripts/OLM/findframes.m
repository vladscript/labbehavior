% first and last frame
function [ta,tb]=findframes(X,LikeliTh,fps)
tb=size(X,1);
% All-Body-Part Likelihoods
L=[X.earleftl,X.earrightl,X.nosel,X.centerl,X.lateralleftl,X.lateralrightl,...
    X.tailbasel,X.tailendl];
Lbin=L>LikeliTh;
AllLs=sum(Lbin,2);
ta=find(AllLs==8,1);
if ~isempty(ta)
    tb_upsideodwn=find(AllLs(end:-1:1)==8,1);
    tb=tb-(tb_upsideodwn-1);
else
    % default
    ta=1;
    tb=size(X,1);
    fprintf('*** Check pose detecton ***')
end

Total=((tb-ta)/fps)/60;
Minutos=floor(Total);
Segundos=(Total-Minutos)*60;
fprintf('>Interval of first and last correct ID of mouse: %i:%1.1f\n',Minutos,Segundos);