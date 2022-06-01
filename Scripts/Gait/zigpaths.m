%% Analyze Paths #########################################################
function [yvar,XDistance,Nzigzags,VelocityProm]=zigpaths(Path,A1,C1,cmSlahpisx,fs)
% fs=30; % aprox the same evrry video
m=-A1;
b=-C1;
N=numel(Path);
yvar=zeros(1,N);
XDistance=zeros(1,N);
Nzigzags=zeros(1,N);
VelocityProm=zeros(1,N);
for n=1:N
    fprintf('\n>Analysing cross #%i :\n',n)
    xy=Path{n};
    if size(xy,1)>5
        Af=figure;
        Af.NumberTitle='off';
        Af.Name=sprintf('Path: #%i',n);
        xbin=[min(xy(:,1)):max(xy(:,1))];
        ylin=m.*xy(:,1)+b; % BRIDGE LINE
        % DETRENDING BRIDGE
        ydet=xy(:,2)-ylin;
        ax1=subplot(211);
        plot(xy(:,1),xy(:,2)); hold on;
        plot(xy(:,1),ylin); 
        ax2=subplot(212);
        dtx=diff(xy(:,1)); % change in X-dir to dientify biggest mode of dir
        plot(ax2,xy(2:end,1),dtx,'b'); hold on;
        ylabel('Instant Change on X-dir (dx/dn)')
        linkaxes([ax1,ax2],'x');
        % Get intervals of x directions
        
        [pxbin,xbin]=ksdensity(dtx,linspace(min(dtx),...
            max(dtx),100));
        conte=0.5*max(xy(:,1))/max(pxbin);
        plot(ax2,pxbin*conte+min(xy(:,1)),xbin,'.-g') % Velocity Mode
        [Ap,Bp,Cp]=findpeaks(pxbin,xbin,'Npeak',1,'SortStr','descend');
        plot(ax2,Ap*conte+min(xy(:,1)),Bp,'og') % Peak Velocity Mode
        if ~isempty(Bp)
            LimA=Bp-Cp/2;
            LimB=Bp+Cp/2;
            if Bp>0
                if LimA<0
                    LimA=0;
                end
            else
                if LimB>0
                    LimB=0;
                end
            end
            intera=intersect(find(dtx>LimA),find(dtx<LimB));
            if numel(intera)>2
                [lima,limb]=continter(intera);

                bar(ax2,xy(intera(lima:limb),1), dtx(intera(lima:limb)))
                xinter=xy(intera(lima:limb),1);
                txmin=min(xinter);
                txmax=max(xinter);
                plot(ax2,[txmin,txmin],[min(dtx),max(dtx)],'-xr');
                plot(ax2,[txmax,txmax],[min(dtx),max(dtx)],'-xr');
                Nmin=find(xy(:,1)==txmin);
                Nmax=find(xy(:,1)==txmax);
                % Fixxes
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

                plot(ax1,[xy(Nmin,1),xy(Nmin,1)],[min(ydet),max(ydet)],'-.r')
                plot(ax1,[xy(Nmax,1),xy(Nmax,1)],[min(ydet),max(ydet)],'-.r')
                plot(ax1,xy(Nmin:Nmax,1),ydet(Nmin:Nmax),'-g')

                % DETRENDING TRAJECTORY
                [p,~,mu] = polyfit(xy(Nmin:Nmax,1), ydet(Nmin:Nmax), 1);
                ytraj = polyval(p,xy(Nmin:Nmax,1),[],mu); 
                plot(ax1,xy(Nmin:Nmax,1),ytraj,'-m')
                yplana=ydet(Nmin:Nmax)-ytraj;
                plot(ax1,xy(Nmin:Nmax,1),yplana,'b'); 
                ysm=smooth(yplana,5,'lowess');
                plot(ax1,xy(Nmin:Nmax,1),ysm,'k');
                xcont=xy(Nmin:Nmax,1); % same as xinter
                if numel(ysm)>2
                    % turns
    %                 [PpeU,NpeU]=findpeaks(ysm,xcont,'MinPeakHeight',0); % Ups
    %                 [PpeD,NpeD]=findpeaks(-ysm,xcont,'MinPeakHeight',0); % Downs

                    [PpeU,NpeU]=findpeaks(ysm,'MinPeakHeight',0); % Ups
                    if isempty(PpeU)
                        [PpeU,NpeU]=max(ysm);
                    end
                    [PpeD,NpeD]=findpeaks(-ysm,'MinPeakHeight',0); % Downs
                    if isempty(PpeD)
                        [PpeD,NpeD]=min(ysm);
                    end
                    if and(numel(NpeU)>0,numel(NpeD)>0)
                        % Search of symmetric balances
                        MatP=[];
                        for i=1:numel(PpeU)
                            for j=1:numel(PpeD)
                                MatP(i,j)=abs(PpeU(i)-PpeD(j));
                            end
                        end
                        [SimU,SimD]=find(MatP==min(MatP(:)));
                        plot(ax1,xcont( NpeU(SimU)),PpeU(SimU),'*r');
                        plot(ax1,xcont( NpeD(SimD)),-PpeD(SimD),'*r');
                        if NpeU(SimU)<NpeD(SimD)
                            SegA=NpeU(SimU);
                            SegB=NpeD(SimD);
                        else
                            SegA=NpeD(SimD);
                            SegB=NpeU(SimU);
                        end
                        ytr=ysm(SegA:SegB);
                        plot(ax1,xcont(SegA:SegB),ytr,'color',[0.1,0.9,0.7])
                        axis(ax1,[min([xcont(SegA),xcont(SegB)]),max([xcont(SegA),xcont(SegB)]),min(ytr),max(ytr)]);
                        grid on;
                        Uptr=[];
                        Downtr=[];
                        if SegB-SegA+1>3
                            Uptr=findpeaks(ytr,'MinPeakHeight',0,'MinPeakDistance',2);
                            Downtr=findpeaks(-ytr,'MinPeakHeight',0,'MinPeakDistance',2);
                        elseif SegB-SegA+1==3
                            Uptr=findpeaks(ytr,'MinPeakHeight',0,'MinPeakDistance',1);
                            Downtr=findpeaks(-ytr,'MinPeakHeight',0,'MinPeakDistance',1);
                        end
                        % Number of eak in between
                        Nups=numel(Uptr)+1;
                        Ndowns=numel(Downtr)+1;
                        % Metrics:
                        XDistance(n)=(xcont(SegB)-xcont(SegA))*cmSlahpisx;
                        yvar(n)=var(ytr)*cmSlahpisx;
                        Nzigzags(n)=min([Nups,Ndowns]);
                        VelocityProm(n)=((xcont(SegB)-xcont(SegA))*cmSlahpisx)/((SegB-SegA)/fs);
                        fprintf('\n>Balance Variance [cm]: %3.2f\n>Distance [cm]: %3.2f\n>#ZigZgas: %i\n>Vel. Prom.: %3.2f [cm/s]\n',...
                        yvar(n),XDistance(n),Nzigzags(n),VelocityProm(n));
                    else
                        fprintf('\n>no symmetric balance detected<<<<<)');
                    end                
                else 
                    fprintf('\n>Few Points of Undisrupted (no stops and no turns) Trajectory');
                end
            else
                fprintf('\n>No Undisrupted Trajectory detected');
            end
        else
            fprintf('\n>Few Trajectory Points (%i)',numel(ysm));
        end
    %     pause
    else
        fprintf('\n>Few Trajectory Points (%i)',size(xy,1));
    end
end
