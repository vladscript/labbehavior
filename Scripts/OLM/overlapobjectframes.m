function OL=overlapobjectframes(dX,Dclose)
NefFrames=find(dX<=0);
Intervals=[1,find(diff(NefFrames)>1)+1,numel(NefFrames)];
OL=[];
for n=1:numel(Intervals)-1
    A=NefFrames(Intervals(n));
    B=NefFrames(Intervals(n+1)-1);
    % search backwards
    while dX(A)<Dclose && A>1
        A=A-1;
        fprintf('.');
    end
    fprintf('\n');
    % search forwards
    while dX(B)<Dclose && B<numel(dX)
        B=B+1;
        fprintf('.');
    end
    fprintf('\n');
    OL=[OL;A,B,B-A];
end
fprintf('\n');
[~,idxok]=unique(OL(:,1:2),'rows');
OL=OL(idxok,:);