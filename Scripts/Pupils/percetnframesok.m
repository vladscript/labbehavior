% Gets frames with detection of all combinations of dots inpupil
% Input
%   sQRl: Binary Matirx above likelihood threshold
% Output
%   All Combinations:   all possible axis or area
%   % of simultaneuos frames
% 
function [DotsCombs,PctFrames]=percetnframesok(sQRl)
[f,N]=size(sQRl);
n=N; aux=1;
DotsCombs={};
PctFrames=[];
fprintf('\n');
while n>1
    DotsIndx=[nchoosek([1:N],n)];
    k=size(DotsIndx,1);
    for i=1:k
        OKFrames=sum(sum(sQRl(:,DotsIndx(i,:)),2)==n);
        PctFrames(aux,1)=OKFrames/f;
        % Save
        DotsCombs{aux,1}=DotsIndx(i,:);
        aux=aux+1;
    end
    n=n-1;
    fprintf('x\n')
end