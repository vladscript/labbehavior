function pgonA=rectangleobject(xoa1,yoa1,xoa2,yoa2,xoa3,yoa3,xoa4,yoa4)
N=numel(xoa1);
% [Cx Cy] = centroid(pgonA)
wirstangel=360*ones(N,1);
for n=1:N
    pgonA = polyshape([xoa1(n),xoa2(n),xoa3(n),xoa4(n)],...
        [yoa1(n),yoa2(n),yoa3(n),yoa4(n)]);
    if pgonA.NumRegions==1
        u=[xoa2(n),yoa2(n)]-[xoa1(n),yoa1(n)];
        v=[xoa4(n),yoa4(n)]-[xoa1(n),yoa1(n)];
        a=acosd(dot(u,v)/(norm(u)*norm(v)));
        
        u=[xoa2(n),yoa2(n)]-[xoa3(n),yoa3(n)];
        v=[xoa4(n),yoa4(n)]-[xoa3(n),yoa3(n)];
        b=acosd(dot(u,v)/(norm(u)*norm(v)));
        
        wirstangel(n)=max([abs(90-a),abs(90-b)]);
    end
     
end
[degdif,Nok]=min(wirstangel)
n=Nok;
pgonA = polyshape([xoa1(n),xoa2(n),xoa3(n),xoa4(n)],...
        [yoa1(n),yoa2(n),yoa3(n),yoa4(n)]);