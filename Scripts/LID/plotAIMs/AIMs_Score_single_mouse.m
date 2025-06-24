% Function to calculate AIMs score
% ACcording to the AIMs score scale
% from Cenci & Lundblad1 2007
% and Sebastianutto et al 2016 [Cenci's]
% Type of Input Data
%   36 values of 9 intervals
%   in 4 AIMs:
%       Lo|Li|Ax|Ol
%   And 2 Scales each AIM:
%       Amplitude
%       Basic
% Input:
% X: Measured Values 
% Ouput
% Y.globalscores
function Y=AIMs_Score_single_mouse(X)
% Initialize Output
Y.sessionscores=0;              % Session Score

Y.globalscores=zeros(1,9);      % Global Per Period Score
Y.globalscores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.globalscores_Li=zeros(1,9);         % Limb score Per Period
Y.globalscores_Ax=zeros(1,9);         % Axial score Per Period
Y.globalscores_Ol=zeros(1,9);         % Orolingual score Per Period

Y.globalsumscores=zeros(1,9);   % Global-Sum Per Period Score
Y.globalsumscores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.globalsumscores_Li=zeros(1,9);         % Limb score Per Period
Y.globalsumscores_Ax=zeros(1,9);         % Axial score Per Period
Y.globalsumscores_Ol=zeros(1,9);         % Orolingual score Per Period

Y.basic_scores=zeros(1,9);      % Basic Per Period Score
Y.basicscores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.basicscores_Li=zeros(1,9);         % Limb score Per Period
Y.basicscores_Ax=zeros(1,9);         % Axial score Per Period
Y.basicscores_Ol=zeros(1,9);         % Orolingual score Per Period

Y.amplitudescores=zeros(1,9);    % Amplitude Per Period Score
Y.amplitudescores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.amplitudescores_Li=zeros(1,9);         % Limb score Per Period
Y.amplitudescores_Ax=zeros(1,9);         % Axial score Per Period
Y.amplitudescores_Ol=zeros(1,9);         % Orolingual score Per Period

Y.alosumscores=zeros(1,9);    % ALO-SUM Only Li, Ax & Ol:
Y.alosumscores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.alosumscores_Li=zeros(1,9);         % Limb score Per Period
Y.alosumscores_Ax=zeros(1,9);         % Axial score Per Period
Y.alosumscores_Ol=zeros(1,9);         % Orolingual score Per Period

Y.alobasicscores=zeros(1,9);    % ALO BASIC Only Li, Ax & Ol:
Y.alobasicscores_Lo=zeros(1,9);         % Locomotive score Per Period
Y.alobasicscores_Li=zeros(1,9);         % Limb score Per Period
Y.alobasicscores_Ax=zeros(1,9);         % Axial score Per Period
Y.alobasicscores_Ol=zeros(1,9);         % Orolingual score Per Period

[~,Periods]=size(X);
Nmovements=4;
% TimeIntervals=20:20:180;
if Periods~=36
    disp('[{<{<ERROR>}>}]')
else
    Naux=0; % it Increases +4
    for period=1:9
        AIMs=X(:,Naux+1:Naux+Nmovements); % 2 x 4 Matrix of AIMs score
        Score=prod(AIMs);       % sum{ basic x amplitude } 
        ScoreSum=sum(AIMs);     % sum{ basic + amplitude }
        % Output Scores
        % GLOBAL Only Li, Ax & Ol:
        Y.globalscores(period)=sum(Score(2:end));        
        Y.globalscores_Lo(period)=Score(1);
        Y.globalscores_Li(period)=Score(2);
        Y.globalscores_Ax(period)=Score(3);
        Y.globalscores_Ol(period)=Score(4);
        % GLOBAL-SUM Lo, Li, Ax & Ol:
        Y.globalsumscores(period)=sum(ScoreSum);
        Y.globalsumscores_Lo(period)=ScoreSum(1);
        Y.globalsumscores_Li(period)=ScoreSum(2);
        Y.globalsumscores_Ax(period)=ScoreSum(3);
        Y.globalsumscores_Ol(period)=ScoreSum(4);
        % BASIC Lo, Li, Ax & Ol:
        Y.basic_scores(period)=sum(AIMs(1,:));
        Y.basicscores_Lo(period)=AIMs(1,1);
        Y.basicscores_Li(period)=AIMs(1,2);
        Y.basicscores_Ax(period)=AIMs(1,3);
        Y.basicscores_Ol(period)=AIMs(1,4);
        % AMPLITUDE Only Li, Ax & Ol:
        Y.amplitudescores(period)=sum(AIMs(2,:));
        Y.amplitudescores_Lo(period)=AIMs(2,1);
        Y.amplitudescores_Li(period)=AIMs(2,2);
        Y.amplitudescores_Ax(period)=AIMs(2,3);
        Y.amplitudescores_Ol(period)=AIMs(2,4);
        % ALO-SUM Only Li, Ax & Ol:
        Y.alosumscores(period)=sum(ScoreSum(2:end));
        Y.alosumscores_Lo(period)=ScoreSum(1);
        Y.alosumscores_Li(period)=ScoreSum(2);
        Y.alosumscores_Ax(period)=ScoreSum(3);
        Y.alosumscores_Ol(period)=ScoreSum(4);
        % ALO BASIC Only Li, Ax & Ol:
        Y.alobasicscores(period)=sum(AIMs(1,2:end));
        Y.alobasicscores_Lo(period)=AIMs(1,1);
        Y.alobasicscores_Li(period)=AIMs(1,2);
        Y.alobasicscores_Ax(period)=AIMs(1,3);
        Y.alobasicscores_Ol(period)=AIMs(1,4);
        
        Naux=Naux+Nmovements;
    end
end
% SESSION SCORES
Y.sessionscores=sum(Y.globalscores);
Y.sessionsumscores=sum(Y.globalsumscores);
Y.sessionbasscores=sum(Y.basic_scores);
Y.sessionampscores=sum(Y.amplitudescores);
Y.sessionalosumscores=sum(Y.alosumscores);
Y.sessionalobasscores=sum(Y.alobasicscores);