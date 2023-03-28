function P=polygonperimeter(pgonA,xratio,yratio)
Xpoly=[pgonA.Vertices(:,1)*xratio,pgonA.Vertices(:,2)*yratio];
Xpoly=[Xpoly;Xpoly(1,:)];
P=sum(get_distance(Xpoly));