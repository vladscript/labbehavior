% Distance from pairs of columns of X to matrix Y
function D=distanceto(X,Y)
[Nrows,Ncols]=size(X);
D=[];
aux=1;
fprintf('\n')
for n=1:2:Ncols
    Xbuffer=zeros(2*Nrows,2);
    fprintf('%i',aux)
    x=X(:,n); y=X(:,n+1);
    Xbuffer(1:2:end,:)=[x,y];
    Xbuffer(2:2:end,:)=Y;
    d=get_distance(Xbuffer);
    D=[D,d(2:2:end)];
    if n<Ncols-1
        fprintf(',')
    end
    aux=aux+1;
end
fprintf('\n')