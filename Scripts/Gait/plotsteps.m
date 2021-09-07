% plots circles on already holded on figure
function plotsteps(indx,XYs)
indxp=round(indx*2-1);
for i=1:numel(indxp)
    plot(XYs(indxp(i),1),XYs(indxp(i),2),'ow');
    plot(XYs(indxp(i)+1,1),XYs(indxp(i)+1,2),'ow');
end
    