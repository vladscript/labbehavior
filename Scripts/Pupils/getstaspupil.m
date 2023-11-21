function OutPut=getstaspupil(FranesScreen,FranesStim,ys)
Output_ScreenBlank=numstats(ys(FranesScreen));
Output_ScreenSim=numstats(ys(FranesStim));
OutPut=[Output_ScreenBlank,Output_ScreenSim];
% disp(OutPut);