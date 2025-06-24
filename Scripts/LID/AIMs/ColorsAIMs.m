% Input
%   Cond
% Output
%   Colors
function [Ncond, ColorsC]=ColorsAIMs(Cond)
%% Colors
COnditions=unique(Cond,'stable');
Ncond=numel(COnditions);
maxrep=0;
for i=1:Ncond
    Nreps(i)=sum(ismember(Cond,COnditions(i)));
    
    if Nreps(i)>maxrep
        maxrep=Nreps(i);
    end
end
% 5 Condtions with gradients
NameColor={'Blues','Purples','Greens','Oranges','Reds','Greys'};

if Ncond<numel(NameColor)
    disp('Color OK')
    for i=1:Ncond
        ColorsPal=cbrewer('seq', NameColor{i},2*Nreps(i)+1);
        ColorsC{i}=ColorsPal(2:2:end,:);
    end
else
    ColorsC{1}=cbrewer('qual', 'Set1', Nevals);
end