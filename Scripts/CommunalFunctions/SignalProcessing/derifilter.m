% Derivative Filter: FIR 
% Input Signal
%   x: signal
% Ouput
%   dx: numerical proxy of dereivatve
function dx=derifilter(x)
b = [1 -1];
dx=filter(b,1,x);