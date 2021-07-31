% Function to get Euclidean Distance in every Position
% Input
%   xy: Nx2 matrix of pair of coordinates
% Ouput
%   d: Nx1 distance btween vurrent and past position
% 
% Euclidean distance between previous and actual time
% d = sqrt (x_2-x_1)^2 + (y_2-y_1)^2 )
% 
function d=get_distance(xy)
Nsamp=size(xy,1);
d=zeros(Nsamp,1);
    % for n=2:Nsamp
        % % d(n)=sqrt( (xy(n-1,1)-xy(n,1))^2 + (xy(n-1,2)-xy(n,2))^2 );
        % d(n)=sqrt( (xy(n,1)-xy(n-1,1))^2 + (xy(n,2)-xy(n-1,2))^2 );
    % end
    % Without Loop
    d(2:end)=sqrt( diff(xy(:,1)).^2 + diff(xy(:,2)).^2);
end