%% Analyze Paths in Bridge
% 
function pathnalyzer(Path)
N=numel(Path);
for i=1:N
    CenterXY=Path{n};
    % DIRECTIONS
    tabulate(sign(diff(CenterXY(:,1))))
    
    figure; 
    subplot(2,1,1)
    plot(CenterXY(:,1),CenterXY(:,2),'')
    subplot(2,1,2)
end