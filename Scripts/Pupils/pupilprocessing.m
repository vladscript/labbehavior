% function pupilprocessing(A)

fps=30;
ts=1/fps;
[pa,bina]=ksdensity(A,linspace(min(A),max(A),100));
% Biggest Mode of Size
[~,MaxbinA,halwidthMaxA]=findpeaks(pa,bina,'NPeaks',1,'SortStr','descend'); % most frequent size
okA=MaxbinA+2*halwidthMaxA;

[pa,bina]=ksdensity(A(A>okA),linspace(min(A(A>okA)),max(A(A>okA)),100));

[~,MaxSize,halwidthMaxA]=findpeaks(pa,bina,'NPeaks',1,'SortStr','descend'); % most frequent size

normA=A/MaxSize;

% trim signal between intervals of visual stimulation
A=21;
B=104803;
normA=normA(A:B);

y=filter(Hlp,normA);