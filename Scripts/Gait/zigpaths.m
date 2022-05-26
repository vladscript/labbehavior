%% Analyze Paths #########################################################
function [yvar,XDistance,Nzigzags]=zigpaths(Path,A1,C1,cmSlahpisx)
m=-A1;
b=-C1;
N=numel(Path);
yvar=zeros(1,N);
XDistance=zeros(1,N);
Nzigzags=zeros(1,N);

figure;
for n=1:N
    
    xy=Path{n};
    if size(xy,1)>5
        xbin=[min(xy(:,1)):max(xy(:,1))];
        ylin=m.*xy(:,1)+b;
    %     plot(xy(:,1),xy(:,2)); hold on;
    %     plot(xy(:,1),ylin);

        % DETRENDING BRIDGE
        ydet=xy(:,2)-ylin;
        % subplot(211)
    %     plot(xy(:,1),ydet); hold on;
        % subplot(212)
        %bar(diff(xy(:,1)));
        % Get intervals of x directions
        dtx=diff(xy(:,1)); % change in X-dir to dientify biggest mode of dir
        [pxbin,xbin]=ksdensity(dtx,linspace(min(dtx),...
            max(dtx),100));
        [~,Bp,Cp]=findpeaks(pxbin,xbin,'Npeak',1,'SortStr','descend');
        if ~isempty(Bp)
            txmin=min(xy(find(dtx(intersect(find(dtx>=Bp-Cp/2),find(dtx<=Bp+Cp/2)))),1));
            txmax=max(xy(find(dtx(intersect(find(dtx>=Bp-Cp/2),find(dtx<=Bp+Cp/2)))),1));
            Nmin=find(xy(:,1)==txmin);
            Nmax=find(xy(:,1)==txmax);
            if numel(Nmin)>1
                Nmin=max(Nmin);
            end
            if numel(Nmax)>1
                Nmax=max(Nmax);
            end
            if Nmin>Nmax
                Nbuff=Nmin;
                Nmin=Nmax;
                Nmax=Nbuff;
            end
        %     plot([xy(Nmin,1),xy(Nmin,1)],[min(ydet),max(ydet)],'-.r')
        %     plot([xy(Nmax,1),xy(Nmax,1)],[min(ydet),max(ydet)],'-.r')
        %     plot(xy(Nmin:Nmax,1),ydet(Nmin:Nmax),'-.g')


        %     fprintf('\n>%i - %i\n',Nmin,Nmax)

            % DETRENDING TRAJECTORY
            [p,~,mu] = polyfit(xy(Nmin:Nmax,1), ydet(Nmin:Nmax), 1);
            ytraj = polyval(p,xy(Nmin:Nmax,1),[],mu); 
        %     plot(xy(Nmin:Nmax,1),ytraj,'-m')

            yplana=ydet(Nmin:Nmax)-ytraj;
            plot(xy(Nmin:Nmax,1),yplana); hold on;
            ysm=smooth(yplana,5,'lowess');
            plot(xy(Nmin:Nmax,1),ysm,'k'); hold on;
            axis tight; grid on;
            yvar(n)=var(yplana)*cmSlahpisx;

            if numel(ysm)>2
                % turns
                Npe=findpeaks(ysm);
                Nups=numel(Npe);
                Npe=findpeaks(-ysm);
                Ndowns=numel(Npe);
                XDistance(n)=abs(xy(Nmax,1)-xy(Nmin,1))*cmSlahpisx;
                Nzigzags(n)=min([Nups,Ndowns]);
                fprintf('\n>Balance Variance [cm]: %3.2f; Distance [cm]: %3.2f #ZigZgas: %i',...
                    yvar(n),XDistance(n),Nzigzags(n));
            else
                fprintf('\n>Few Trajectory Points (%i)',numel(ysm));
            end
        else
            fprintf('\n>Few Trajectory Points (%i)',numel(ysm));
        end
    %     pause
    else
        fprintf('\n>Few Trajectory Points (%i)',size(xy,1));
    end
end
