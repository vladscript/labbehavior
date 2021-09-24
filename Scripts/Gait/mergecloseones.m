% Mergeing close points
function XYclean=mergecloseones(XY,MinLengt)
Factor=3;    
d=get_distance(XY);XYclean=[];
XYtemp=[];
% Close
Nclose=find(d<MinLengt/Factor);
XYtemp=[];
IndxClose=unique([1;find(diff([0;Nclose])>1);numel(Nclose)]);
XYclean=[];
for n=1:numel(IndxClose)-1
    XYclean=[XYclean;mean(XY(IndxClose(n):IndxClose(n+1)-1,:),1)];
end
% Distantas
XYclean=[ XYclean; XY( d>=MinLengt/Factor,: ) ];

% for n=2:numel(d)
%     % d is the distance between XXY_n and XY_{n-1}
%     if d(n)<MinLengt/Factor
%         XYtemp=[XYtemp;XY(n-1,:);XY(n,:)];
%         % keep close ones, closer (in XYtemp)
%     else
%         if isempty(XYtemp)
%             XYclean=[XYclean;XY(n-1,:);XY(n,:)];
%         else
%             XYclean=[XYclean;mean(XYtemp)];
%             XYtemp=[];
%             XYclean=[XYclean;XY(n-1,:);XY(n,:)]; % NEW
%         end
%     end
end