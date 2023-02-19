function XY=getlikelycoords(Xx,Xy,Xl,Lthres)
XY=NaN*ones(size(Xx,1),2);
XY(Xl>Lthres,:)=[Xx(Xl>Lthres),Xy(Xl>Lthres)];