function OL=overlapobjectframes(dX,Dclose)
NefFrames=find(dX<=0);
OL=[];
if ~isempty(NefFrames)
    Intervals=[1,find(diff(NefFrames)>1)+1,numel(NefFrames)];
    % Intervals=unique([1,find(diff(NefFrames)>1)+1,numel(NefFrames)]);
    if numel(unique(Intervals))>1
        for n=1:numel(Intervals)-1
            A=NefFrames(Intervals(n));
            B=NefFrames(Intervals(n+1)-1);
            if B<A
                B=A;
            end
            % search backwards
            while dX(A)<Dclose && A>1
                A=A-1;
                fprintf('.');
            end
            fprintf('\n');
            % search forwards
            while dX(B)<Dclose && B<numel(dX)
                B=B+1;
                fprintf('.');
            end
            fprintf('\n');
            OL=[OL;A,B,B-A];
        end
        fprintf('\n');
        [~,idxok]=unique(OL(:,1:2),'rows');
        OL=OL(idxok,:);
    end
    
else
    fprintf('\n No object overlapping \n');
end
% % fprintf('\n Checking skippe frames:');
% % % Skipped:
% % MoreFrames=find(~ismember(NefFrames,OL(1,1):OL(end,2)));
% % fprintf('%i  frame(s) skipped, adding\n>>:',numel(MoreFrames));
% % OLadd=[];
% % for i=1:numel(MoreFrames)
% %     A=NefFrames(MoreFrames);
% %     B=NefFrames(MoreFrames);
% %     while dX(A)<Dclose && A>1
% %     A=A-1;
% %         fprintf('.');
% %     end
% %     fprintf('\n');
% %     % search forwards
% %     while dX(B)<Dclose && B<numel(dX)
% %         B=B+1;
% %         fprintf('.');
% %     end
% %     OLadd=[OLadd;A,B,B-A];
% % 
% % end