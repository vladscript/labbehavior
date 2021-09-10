% Nergeing close points
function XYclean=mergecloseones(XY,MinLengt)
Factor=3;    
d=get_distance(XY);XYclean=[];
XYtemp=[];
for n=2:numel(d)
    % d is the distance between XXY_n and XY_{n-1}
    if d(n)<MinLengt/Factor
        XYtemp=[XYtemp;XY(n-1,:);XY(n,:)];
    else
        if isempty(XYtemp)
            XYclean=[XYclean;XY(n-1,:);XY(n,:)];
        else
            XYclean=[XYclean;mean(XYtemp)];
            XYtemp=[];
        end
    end
end