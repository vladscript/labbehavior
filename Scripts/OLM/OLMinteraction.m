function  dClose=OLMinteraction(dA)
dClose=1;
x=-dA;
P=findpeaks(x);
[pp,pbon,bw]=ksdensity(-P,linspace(min(-P),max(-P),100));
[~,B]=findpeaks(pp,pbon);
InitHres=4; % [cm]
indxok=find(B>0,1);
cc=1;
while B(indxok)>InitHres
    bw=bw/2;
    [pp,pbon,bw]=ksdensity(-P,linspace(min(-P),max(-P),100),'Bandwidth',bw);
    [~,B]=findpeaks(pp,pbon);
    indxok=find(B>0,1);
    cc=cc+1;
    fprintf('>>>')
end
if cc>2
    [pp,pbon]=ksdensity(-P,linspace(min(-P),max(-P),100),'Bandwidth',bw*2);
    [~,B]=findpeaks(pp,pbon);
end
indxok=find(B>0,1);
dClose=B(indxok);