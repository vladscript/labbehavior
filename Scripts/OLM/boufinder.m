function [AMP,TIMES]=boufinder(drate,tvel,velthres)

    [AMP,TIMES]=findpeaks([0;drate;0],[-1,tvel,tvel(end)+1],'MinPeakHeight',velthres);
    if isempty(AMP)
        fprintf('\n!>Poor movement detection, diminished velocity threshold\n')
        velthres=std(drate);
        [AMP,TIMES]=findpeaks(drate,tvel,'MinPeakHeight',velthres);
    end

    fprintf('\n[%i peaks detected]\n',numel(AMP))

   