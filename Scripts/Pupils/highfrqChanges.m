function [Nstart,Nend]=highfrqChanges(dsf)

[~,Nstart]=findpeaks(dsf(1:round(numel(dsf)/2)),'NPeaks',1,'SortStr','descend'); % 
Nstart=Nstart+1;            % Test started
% ds=dsf(Nstart:end);
% Way back wards:
[~,Nend]=findpeaks(-dsf(end:-1:end-round(numel(dsf)/2)),'NPeaks',1,'SortStr','descend'); % 
Nend=numel(dsf)-Nend;