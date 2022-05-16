function T=makesteptable(STPS,ncro,cmSlahpisx)
for n=1:4
    Nsteps(n)=numel(STPS{n});
end
MatDat=zeros(max(Nsteps),4);
for n=1:4
    for i=1:max(Nsteps)
        if ~isempty(STPS{n}) && i<=numel(STPS{n})
            MatDat(i,n)=STPS{n}(i)*cmSlahpisx;
        else
            MatDat(i,n)=NaN;
        end
    end
end

T=table(repmat(ncro,max(Nsteps),1),[1:max(Nsteps)]',MatDat(:,1),MatDat(:,2),...
    MatDat(:,3),MatDat(:,4));

NameVars={'Crossing','StepDetected','Up_Left_CM','Up_Right_CM','Low_Left_CM','Low_Right_CM'};

T.Properties.VariableNames=NameVars;
disp(T)
AvgStrides=mean(MatDat,1,'omitnan');
fprintf('\n>Avg. Strides pre Limb: \nUp-Left: %3.2f\nUp-Rigth: %3.2f\nLow-Left: %3.2f\nLow-Rigth: %3.2f\n',...
    AvgStrides(1),AvgStrides(2),AvgStrides(3),AvgStrides(4))