% Function that gets distance per interval time
% Input
%   d:      instant distance    [cm]
%   ws:     window time         [seconds]
%   fps:    sampling frequency  [fps]
% Output
%   drate: velotity hisotgrama: [distance/time]
function drate=get_velocity_interval(d,ws,fps)
Nws=round(ws*fps);      % samples per window time
N=numel(d);             % Total N of samples in d
Nbin=floor(N/Nws);      % Integer Bins of time
if N-Nbin*Nws>0
    lastwin=(N-Nbin*Nws)/Nws; % fraction of last window
    drate=zeros(Nbin+1,1);
else
    drate=zeros(Nbin,1);
    lastwin=0;
end 
A=1;
B=Nws;
if B>N
    B=N;
    ws=ws*lastwin;
end
for n=1:numel(drate)
    % disp([A,B])
    drate(n)=(d(B)-d(A))/ws; % Distance per Time Period
    A=B+1;
    B=B+Nws;
    if B>N
        B=N;
        ws=ws*lastwin;
    end
end