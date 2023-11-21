function OutPut=exploratoryresults(FramesBlank,FramesStim,ys)
figure
% Histograms
H=histogram(ys,'Normalization','count');
hold on
histogram(ys(FramesBlank),'BinEdges',H.BinEdges,'Normalization','count');
histogram(ys(FramesStim),'BinEdges',H.BinEdges,'Normalization','count');
grid on

[xcd,cdf]=ecdf(ys);
xm=cdf(find(xcd>0.05,1));
XM=cdf(find(xcd>0.95,1));
Ax=gca;
if mean(diff(H.BinEdges))>(XM-xm)
    axis tight;
else
    Ax.XLim=[xm,XM];
end
legend('All','Blank','Stim')
% Stats
OutPut=getstaspupil(FramesBlank,FramesStim,ys);