% lowesss smoothing by increasing windowing
function xs=smiith(x,deltatep)
xs=x;
acfpre=10;
acfact=1;
deltatepinit=deltatep;
% deltatep=0.01;
fprintf('\n>Smoothing:\n')
n=1;
while abs(acfact)<abs(acfpre)
    sx=smooth(1:numel(x),x,deltatep,'lowess');
    r=x-sx;
    acf=autocorr(r,1);
    acfpre=acfact;
    acfact=acf(end);
    deltatep=n*deltatep;
    n=n+1;
    % autocorr(r)
    fprintf('*')
end
if n>2
    deltatep=deltatep*(n-2);
else
    deltatep=deltatep*(n);
end
xs=smooth(x,deltatep,'lowess');
fprintf('\n done.\n')