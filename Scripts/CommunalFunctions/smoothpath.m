function [Xsmooth,Ysmooth]= smoothpath(t,X,Y)

    % Smoothing options:
    % 'moving' Moving average 
    % 'lowess' Local regression using weighted linear least squares and a 1st degree polynomial model
    % 'loess' Local regression using weighted linear least squares and a 2nd degree polynomial model
    % 'sgolay' Savitzky-Golay filter. 
    % 'rlowess' A robust version of 'lowess' that assigns lower weight to outliers in the regression
    % 'rloess' A robust version of 'loess' that assigns lower weight to outliers in the regression.
    
    %     sspan=[0.0025]; % *100 size of the window
    sspan=0.0005:0.0005:0.0250;
    smethod='loess';
    Xerrstd=0; Yerrstd=0; i=0;
    while Xerrstd<1 && Yerrstd<1
        i=i+1;
        Xsmooth=smooth(t,X,sspan(i),smethod);
        Ysmooth=smooth(t,Y,sspan(i),smethod);
        resX=X-Xsmooth;
        resY=Y-Ysmooth;
        Xerrstd=std(resX);
        Yerrstd=std(resY);
        RESIDUALS(i,:)=[Xerrstd,Yerrstd];
        fprintf('>Span: %3.2f %% StdErrX:%3.2f px, StdErrY:%3.2f px\n',sspan(i)*100,std(resX),std(resY))
    end
    if i>1
        i=i-1;
    end
    Xsmooth=smooth(t,X,sspan(i),smethod);
    Ysmooth=smooth(t,Y,sspan(i),smethod);