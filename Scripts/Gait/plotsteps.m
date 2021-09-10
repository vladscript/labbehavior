% plots circles on already holded on figure
function plotsteps(indx,XYs,varargin)
if isempty(varargin)
    markerType='ow';
    LineWidt=1;
else
    markerType=varargin{1};
    LineWidt=varargin{2};
end
if isempty(indx)
    indxp=1:size(XYs,1);
else
    indxp=round(indx*2-1);
end
for i=1:numel(indxp)
    if isempty(indx)
        plot(XYs(indxp(i),1),XYs(indxp(i),2),markerType,'LineWidth',LineWidt);
    else
        plot(XYs(indxp(i),1),XYs(indxp(i),2),markerType,'LineWidth',LineWidt);
        plot(XYs(indxp(i)+1,1),XYs(indxp(i)+1,2),markerType,'LineWidth',LineWidt);
    end
end
    