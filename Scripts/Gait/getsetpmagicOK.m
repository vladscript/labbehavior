function STPS=getsetpmagicOK(indx,Stride)
posIndx=find(indx);
posIndx=[posIndx(1),find(indx)];
naux=1;
XYbuff=[];
nstep=1;
STPS={};
for n=2:numel(posIndx)
    if posIndx(n)-posIndx(n-1)<2
        XYbuff=[XYbuff;Stride(naux*2-1,:),Stride(naux*2,:)];
        naux=naux+1;
    else
        STPS{nstep}=mean(XYbuff,1);
        nstep=nstep+1;
        XYbuff=[];
        XYbuff=[XYbuff;Stride(naux*2-1,:),Stride(naux*2,:)];
        naux=naux+1;
    end
end
if isempty(STPS) && ~isempty(XYbuff)
    STPS{nstep}=mean(XYbuff,1);
end
