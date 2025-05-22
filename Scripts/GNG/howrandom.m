%  TODO
% (generalize to M-nary case)
function [MATTRAN,Hrate,Entrpy]=howrandom(ors)
% Input:
%   Sequence of binary values 
% Ouput
%     
% Transitions
% Rows Current
% Columns Next

stimis=unique(ors);
MATTRAN=zeros(numel(stimis));
for k=2:numel(ors)
    Curr=find(stimis==ors(k));      % Current   t
    Preb=find(stimis==ors(k-1));    % Previous  t-1
    MATTRAN(Curr,Preb)=MATTRAN(Curr,Preb)+1; % Increase frec
    % EntropyRate
    FrecStims=sum(MATTRAN,1);
    mu=sum(MATTRAN,1)./(sum(MATTRAN(:)));
    Hrate(k)=0;
    for i=1:numel(mu)
        A(:,i)=MATTRAN(:,i)./FrecStims(:,i);
        h(i)=0;
        for j=1:size(A,2)
            h(i)=h(i)-A(i,j)*log2(A(i,j));
        end
        Hrate(k)=Hrate(k)+mu(i)*h(i);
    end
end

NansHrate=find(isnan(Hrate));
[MaxH, MaxHTrail]=max(Hrate);
[MinH, MinHTrail]=min(Hrate((NansHrate(end)+1:end)));
MinHTrail=MinHTrail+NansHrate(end)+1;
B=zeros(2,numel(ors));
Gofrq=0;
NoGofrq=0;
for i=1:numel(ors)
% Emission Porbability/ Observation Probabilities
    if ors(i)==stimis(1)
        Gofrq=Gofrq+1;
        
    else
        NoGofrq=NoGofrq+1;
        
    end
    B(2,i)=NoGofrq/i; % Go Probability at each State
    B(1,i)=Gofrq/i; % Go Probability at each State
    Entrpy(i)=-sum([NoGofrq/i, Gofrq/i].*log2([NoGofrq/i, Gofrq/i])); % Entro
end