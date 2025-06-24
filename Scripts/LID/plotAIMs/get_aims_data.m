% Read AIMs from N mice
% Input
%   Matrix of Nx2 rows x 36 columns
% Output
%   Data Structure
%   Plots
function AIMS_Structure=get_aims_data(A)
[Ndouble,~]=size(A);
fprintf(' Scored Rodents:   %i  \n',Ndouble/2);
AIMS_Structure=cell(Ndouble/2,1);
% Main Loop
aux=1;
for n=1:2:Ndouble
    %     MAKE SCORES
    AIMS_Structure{aux}=AIMs_Score_single_mouse(A(n:n+1,:));
    aux=aux+1;
end