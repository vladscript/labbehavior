function ProgTable=findprogression(PEAKS)
ProgTable=[];
Progressions=1;
Nstops=[];
Veloities=[];
Veloities=[Veloities;PEAKS(1,3)];
Intervals=[];
Intervals(Progressions,1)=PEAKS(1,1);
AvgVel=[];
for n=2:size(PEAKS,1)
    if PEAKS(n,1)<=PEAKS(n-1,2)
        fprintf('*')
        Veloities=[Veloities;PEAKS(n,3)];
    else
        AvgVel(Progressions,1)=max(Veloities);
        Intervals(Progressions,2)=PEAKS(n-1,2);
        Progressions=Progressions+1;
        Intervals(Progressions,1)=PEAKS(n,1);
        Nstops=[Nstops;n];
        Veloities=[];
        Veloities=[Veloities;PEAKS(n,3)];
        fprintf('\n')
    end
    if n==size(PEAKS,1)
        Intervals(Progressions,2)=PEAKS(n,2);
        AvgVel(Progressions,1)=mean(Veloities);
    end
end
ProgTable=[Intervals,AvgVel];