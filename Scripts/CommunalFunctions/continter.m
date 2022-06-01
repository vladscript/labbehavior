function [lima,limb]=continter(intera)
lima=1;
limb=numel(intera);
di=diff(intera);
% % subplot(211)
% % bar(intera)
% % subplot(212)
% % bar(di)
InterJumps=unique([1;find(di>2);numel(intera)]);
[~,b]=max(diff(InterJumps));
lima=InterJumps(b);
limb=InterJumps(b+1);