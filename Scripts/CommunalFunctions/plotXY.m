function plotXY(X,varargin)
[~,Ncols]=size(X);

if isempty(varargin)
    Names=1:Ncols/2;
    Names=num2str(Names);
else
    Names=varargin{1};
end


CM=colormap(parula);
if size(CM,1)>Ncols/2;
    CM=CM(round(linspace(1,size(CM,1),round(Ncols/2))),:);
end

keep=true;
if mod(Ncols,2)==0
    fprintf('\n[its all good man]\n!') 
else
    keep=false;
    fprintf('\n!>odd number of  columns in pose coordiantes\n!') 
end
if keep
    figure
    aux=1;
    fprintf('\nPlotting: ')
    for n=1:2:Ncols
        fprintf('%i',aux)
        x=X(:,n);
        y=X(:,n+1);
        plot(x,y,'Color',CM(aux,:)); hold on
        if n<Ncols-1
            fprintf(',')
        end
        aux=aux+1;
    end
    fprintf(' body parts\n')
    legend(Names)
end