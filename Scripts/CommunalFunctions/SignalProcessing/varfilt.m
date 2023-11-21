% Get variance from a lsidin window os ws size
% Input
%   x: signal
%   ws: sliding window size
% Ouput
%   Vsingal: variance of x each ws samples
function Vsignal=varfilt(x,ws)
Vsignal=zeros(size(x));
% VARIANCE SIGNAL $$$
% ws=100; % slidgin window for variance computing
a=1;
for i=1:numel(x)
    if i<=numel(x)-ws
        Vsignal(i)=var(x(i:i+ws-1));
    else
        Vsignal(i)=var(x(i-a:end));
        a=a+1;
    end
end
