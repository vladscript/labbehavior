function XA=mostlikelyvalue(xoa1)
[px,binx]=ksdensity(xoa1,linspace(min(xoa1),max(xoa1),100),'Function','pdf');
[~,posX]=findpeaks(px,binx,'SortStr','descend');
XA=posX(1);
