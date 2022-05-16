function [STPS,KindStride]=getsetpmagic(indxLR,indxRL,L2R,R2L)
nteps=1;
STPS={};
xyL2R=[];
xyR2L=[];
iLR=1;
iRL=1;
KindStride=[];
% pre=0 when LR and pre=1 when RL
for n=1:numel(indxLR)
    fprintf('%i',n)
    if n==1 % In the sirst: save it
        if indxLR(n) && ~indxRL(n)
            xyL2R=[xyL2R;L2R(2*iLR-1,:),L2R(2*iLR,:)];
            Diag=0;
            iLR=iLR+1;
        elseif ~indxLR(n) && indxRL(n)
            xyR2L=[xyR2L;R2L(2*iRL-1,:),R2L(2*iRL,:)];
            Diag=1;
            iRL=iRL+1;
        elseif indxLR(n) && indxRL(n)
            xyL2R=[xyL2R;L2R(2*iLR-1,:),L2R(2*iLR,:)];
            iLR=iLR+1;
            xyR2L=[xyR2L;R2L(2*iRL-1,:),R2L(2*iRL,:)];
            iRL=iRL+1;
            Diag=2;
        end
    else
        % Other check kind of stride LR or RL
        if indxLR(n) && ~indxRL(n)
            Diag=0;
        elseif ~indxLR(n) && indxRL(n)
            Diag=1;
        elseif indxLR(n) && indxRL(n)
            Diag=2;
        end
        % If changed
        if Diag~=preDiag % same stride
            % Save and clear buffer
            if Diag==0 
                STPS{nteps}=mean(xyR2L,1);
                xyR2L=[];
                xyL2R=[xyL2R;L2R(2*iLR-1,:),L2R(2*iLR,:)];
                iLR=iLR+1;
            elseif Diag==1 
                STPS{nteps}=mean(xyL2R,1);
                xyL2R=[];
                xyR2L=[xyR2L;R2L(2*iRL-1,:),R2L(2*iRL,:)];
                iRL=iRL+1;
            elseif Diag==2 
                xyL2R=[xyL2R;L2R(2*iLR-1,:),L2R(2*iLR,:)];
                iLR=iLR+1; 
                xyR2L=[xyR2L;R2L(2*iRL-1,:),R2L(2*iRL,:)];
                iRL=iRL+1;
            end
            KindStride=[KindStride;preDiag];
            nteps=nteps+1;
        else % if not changed: keep unless it is the last onte
            if n<numel(indxLR)
                if Diag==1 % R-L
                    xyR2L=[xyR2L;R2L(2*iRL-1,:),R2L(2*iRL,:)];
                    iRL=iRL+1;
                elseif Diag==0 % L-R
                    xyL2R=[xyL2R;L2R(2*iLR-1,:),L2R(2*iLR,:)];
                    iLR=iLR+1;
                else
                    
                end
            end
        end
    end
    preDiag=Diag;
    if mod(n,20)==0
        fprintf('\n')
    else
        fprintf(',')
    end
end