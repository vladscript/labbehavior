function s=barpreference(interA,interB,t)
% plot cummulative progression of object in OLM task
ObjPref=categorical(zeros(size(t)));
s=zeros(size(t));
ObjPref(interA)='A';
ObjPref(interB)='B';
A=0;
B=0;
figure; 
Ax=subplot(1,1,1);
% f = waitbar(0,'>>Plotting ...');
for i=1:numel(t)
    switch ObjPref(i)
        case 'A'
            A=A+1;
        case 'B'
            B=B+1;
%         otherwise
%             %fprintf('.')
    end
    TOTAL=A+B;
    if TOTAL>0
        base=100*A/TOTAL;
        s(i)=base;
        plot(Ax,t(i),base,'xk'); hold on; % PERCENT
        line([t(i),t(i)],[100,base],'Color','green')    % B
        line([t(i),t(i)],[0,base],'Color','blue');      % A
    end
%     waitbar(i/numel(t),f);
    if rem(t(i),10)==60
        fprintf('>Time: %3.2f\n',t(i));
    end
end
% close(f);
Ax.YLim=[0,100];
Ax.XLim=[0,t(end)]; % Seconds