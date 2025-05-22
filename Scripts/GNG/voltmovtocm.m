%% Input: Turns, Z
% AN8 Sensors, DataSheet:
% Output Voltage 10% to 90% of input (see graph for voltage vs. rotation angle
% characteristics)
% Z,
% Turns
% RZ,
% cylrad
% wv: window for speed [ms]
% fs: amplign frequency [Hz]
function [D,Spped]=voltmovtocm(Z,Turns,RZ,cylrad,ws,fs)
NG=numel(Turns);
a=1;
Volts2piRad=0.95*floor(max(RZ));
Spped=[];
D=[];
for i=1:NG
    b=abs(Turns(i));
    if b>numel(Z)
        b=numel(Z);
    end
    if or(RZ(i)>Volts2piRad && b>0, i==NG)
        z=Z(a:b); 
        % z(1)-> 0 rad
        % z(end)-> 2pi rad
        radiands=abs((z-z(1))/range(z)*2*pi); % rad
        dis=radiands*cylrad; % cm
        if numel(D)>0
            D=[D;dis+D(end)];
        else
            D=[D;dis];
        end
        S=get_velocity_interval(dis,ws/1000,fs);
        Spped=[Spped;S];
        a=b+1;
%         plot(z)
%         axis tight; grid on;
%         pause
    end
end


