%% Lick Raster
        STIstr=STIMRESPONSE(:,1);
STI=zeros(size(STIstr));
        STI(STIstr=='Go')=1;
            ors=STI(:,1); % numerical sequence of stim degrees
    StimLength=abs(round(round(mean(StimDur))/fs)*1000);

%% PLOT RASTER (fast vis)
    % Input (Lick Matrix,ors,)
    if size(LickMatrix,1)<numel(ors)
        LickMatrix(end+1,:)=zeros(size(LickMatrix(1,:)));
        fprintf('*')
    end
    if size(SpeMatrix,1)<numel(ors)
        SpeMatrix(end+1,:)=zeros(size(SpeMatrix(1,:)));
        fprintf('x')
    end
    figure
    A1=subplot(131);
    imagesc(LickMatrix)
    A1.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A1.XTick)
        A1.XTickLabel{n}=num2str(A1.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix,1)],'EdgeColor','k')
    ti=title([[MouseID{i},'-',Sesion{i}]]);
    ti.Interpreter='none';
    ylabel('Trials')
    
    A2=subplot(132);
    
    imagesc(LickMatrix(ors==stimis(1),:))
    A2.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A2.XTick)
        A2.XTickLabel{n}=num2str(A2.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix(ors==stimis(1),:),1)],'EdgeColor','k')
    title(sprintf('Stim: %i °',stimis(1)))
    xlabel('Peri-Stimuli [ms]')
    A3=subplot(133);
    imagesc(LickMatrix(ors==stimis(2),:))
    A3.XTick=0:fs:size(LickMatrix,2);
    for n=1:numel(A3.XTick)
        A3.XTickLabel{n}=num2str(A3.XTick(n)-PreStim);
    end
    hold on;
    rectangle('Position',[PreStim 0 StimLength size(LickMatrix(ors==stimis(2),:),1)],'EdgeColor','k');
    title(sprintf('Stim: %i °',stimis(2)))
    CM=[1 1 1; 0 0 0];
    colormap(CM);