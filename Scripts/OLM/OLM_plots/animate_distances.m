% function animate_distances()

FigDis=figure();
FigDis.Name='Distance animation';
FigDis.Position(end)=round(FigDis.Position(end)/2);
% resize fig:


Nframes=tnose(end)+1; % starts at zero
if savebool
    nameout=FD;                 % Hz: dafult frames per second (user input)
    prompt={'Name:'};
    name='Video:';
    numlines=1;
    defaultanswer={nameout};
    answer={};
    while isempty(answer)
        answer=inputdlg(prompt,name,numlines,defaultanswer);
    end
    nameout= answer{1};
    v = VideoWriter([nameout,'.avi']);
    fprintf('>Creating: %s file',v.Filename);
    v.FrameRate=fps;
    open(v)
end

%% Plot all
axa1=subplot(1,1,1);
plot(dA,'Color','blue')