IAok=IA;
indxOK=[];
for i=1:size(IAok,1)
    if isempty( intersect(IAok(i,1):IAok(i,2), disA) )
        indxOK=[indxOK;i];
    else
        disp('discarded interval')
    end
end
IA=IAok(indxOK,:);


IBok=IB;
indxOK=[];
for i=1:size(IBok,1)
    if isempty( intersect(IBok(i,1):IBok(i,2), disB) )
        indxOK=[indxOK;i];
    else
        disp('discarded interval')
    end
end
IB=IBok(indxOK,:);

% LOG: export time stamps and events as CSV table
fprintf('\n>Exporting LOG file: ')
NameLog=[f(1:indxmark-1),'_LOG.csv'];
LogDestiantion=FileOutput;

% Classes=categorical({'Exploration_A','Exploration_B','Overlap_A','Overlap_B','Bout'});

Classes={'Exploration_A','Exploration_B','Overlap_A','Overlap_B','Bout'};

Zexort=table();
% Explorations
Zexort=[Zexort; array2table(IA(:,1:2)),repmat(Classes(1),size(IA,1),1) ];
Zexort=[Zexort; array2table(IB(:,1:2)),repmat(Classes(2),size(IB,1),1) ];
% Overlappings
Zexort=[Zexort; array2table(OLA(:,1:2)),repmat(Classes(3),size(OLA,1),1) ];
Zexort=[Zexort; array2table(OLB(:,1:2)),repmat(Classes(4),size(OLB,1),1) ];
% Bouts
% BOUTS=[TIMES',AMP]
bouts_A=TIMES';
bouts_B = bouts_A+1;
BOUTS=[bouts_A*fps,bouts_B*fps];

Zexort=[Zexort; array2table([BOUTS(:,1),BOUTS(:,2)]),repmat(Classes(5),size(BOUTS,1),1) ];

Zexort.Properties.VariableNames={'Frame_A','Frame_B','Action'};

[~,IndexSort]=sort(table2array(Zexort(:,1)),'ascend');

Zexort=Zexort(IndexSort,:);

Zexort(end+1,:)=table(ta,tb,{num2str(fps)});

writetable(Zexort,[LogDestiantion,NameLog]);

fprintf('done.\n')