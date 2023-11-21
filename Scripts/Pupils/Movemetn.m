%%  MOVEMENT

fs_daq=1000;
%%

A=round((Nstart/fps)*fs_daq);
B=round((Nend/fps)*fs_daq);
Mlx=TreadMill(A:B);
Vlx=derifilter(Mlx);
100*numel(find(abs(Vlx)>0.05))/numel(Vlx)

%%

A=round((Nstart/fps)*fs_daq);
B=round((Nend/fps)*fs_daq);
Mctrl=TreadMIll(A:B);
Vctrl=derifilter(Mctrl);
100*numel(find(Vctrl>0.05))/numel(Vctrl)
% binM=linspace(min(M),max(M),100);
% [P,B]=findpeaks(ksdensity(M,binM));
% binM(B(end))


