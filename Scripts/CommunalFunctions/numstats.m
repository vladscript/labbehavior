function OutPutStats=numstats(x)
Mean=mean(x);
Var=var(x);
Kurt=kurtosis(x,0);
Skew=skewness(x);

OutPutStats=[Mean;Var;Kurt;Skew];