% Input
%   XYA: [x_a,y_a]
%   XYB: [x_b,y_b]
% Output
% m
% b
% Line: y=mx+b
function [m,b]=getlineWall(XYA,XYB)
m=(XYB(2)-XYA(2))/(XYB(1)-XYA(1));
b=XYA(2)-m*XYA(1);

