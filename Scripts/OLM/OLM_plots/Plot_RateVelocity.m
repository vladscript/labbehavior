figure
bar(tvel,drate)
ylabel('cm/s');
xlabel('s')
title(sprintf('Velocity each %2.1f seconds',ws))
hold on
for n=1:numel(AMP)
    plot(TIMES(n),AMP(n),'r*');
end
plot([0,TIMES(end)],[velthres,velthres],'--r')
% bouts