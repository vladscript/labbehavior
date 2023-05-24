% v = VideoReader('STIMgray.mp4');
function Index=TypeStim(v)

%% Processing
Index=zeros(v.NumFrames,1);
for n=1:1:v.NumFrames
    fprintf('>Progress: %3.2f %%',100*n/v.NumFrames);
    frame = rgb2gray( read(v,n) );
    frame=frame(50:end-50,50:end-50); % margin

    horsig=graytrace(frame);
    versig=graytrace(frame');

    [ah,lagh,bh]=autocorr(horsig,numel(horsig)-1);
    [av,lagv,bv]=autocorr(versig,numel(versig)-1);
    wh=lagh(find(ah<bh(1),1));
    wv=lagv(find(av<bv(1),1));
    xh=smooth(horsig,wh/numel(horsig),'lowess');
    xv=smooth(versig,wv/numel(versig),'lowess');
    dxh=diff(xh);
    dxv=diff(xv);
    kh=kurtosis(dxh,0);
    kv=kurtosis(dxv,0);
    % DECISION
    if kh<3 && kv<3
        fprintf('\n[]')
        Index(n)=1;
    elseif kh<3 && kv>3
        fprintf('\n==')
        Index(n)=2;
    elseif kh>3 && kv<3
        fprintf('\n||')
        Index(n)=3;
    else
        fprintf('\n?')
        Index(n)=4;
    end
end

end
