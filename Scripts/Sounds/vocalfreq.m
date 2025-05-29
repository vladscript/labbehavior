% Frequeny Vocalizaitons by binnig time
% Input
%   Ta,
%   Tb,
%   bin,
% Output
%   V
function [Time,V]=vocalfreq(Ta,Tb,bin)
% bin=0.1
% Make Vector
Time=linspace(0,Tb(end),round(Tb(end)/bin));
V=zeros(size(Time));
for i=1:numel(Ta)
    a=find(Time>=Ta(i),1);
    b=find(Time>=Tb(i),1);
    V(a:b)=V(a:b)+1;
end