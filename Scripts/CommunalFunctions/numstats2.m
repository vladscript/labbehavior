function OutPutStats=numstats2(x)
Mean=mean(x);
Mode=mode(x);
Median=median(x);
Var=var(x);
Kurt=kurtosis(x,0);
Skew=skewness(x);

OutPutStats=[Mean,Mode,Median,Var,Kurt,Skew];