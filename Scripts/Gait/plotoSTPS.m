function plotoSTPS(STPS)
for n=1:numel(STPS)
    xxyy=STPS{n};
    if mod(n,2)==0
        colorsqr='sw';
    else
        colorsqr='sk';
    end
    plot(xxyy([1,3]),xxyy([2,4]),colorsqr,'MarkerSize',15)
end