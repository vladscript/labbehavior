function [Nstart,Nend]=StartEndVar(x)
Nth=5; % fractoin of the segment
[~,BinEdges]=histcounts(x);
AmpMin=BinEdges(find(BinEdges>0,1));
[~,Nstart]=findpeaks(x(1:round(numel(x)/Nth)),'NPeaks',1,'SortStr','descend'); % 
[~,Nend]=findpeaks(x(end:-1:end-round(numel(x)/Nth)),'NPeaks',1,'SortStr','descend'); % 
Nend=numel(x)-Nend;
disp('searching')
aux=1;
A=x(Nstart);
while A>AmpMin
    aux=aux+1;
    A=x(Nstart+aux);
%     fprintf('%2.2f',A)
%     pause
end
disp('start/searching')
Nstart=Nstart+aux;
aux=0;
A=x(Nend);
while A>AmpMin
    aux=aux-1;
    A=x(Nend+aux);
%     fprintf('%2.2f',A)
%     pause
end
Nend=Nend+aux;
disp('end')