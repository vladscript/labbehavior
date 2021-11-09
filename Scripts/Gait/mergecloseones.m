% Mergeing/Averageing close points
% Input
%   XY: list of coordinates                 [Strides X-Ys]
%   Threshold: 3 times threshold distance   [head-tailbase distance]
% Output
%   XYsave: list of coordinates distanced by Threshold by averagegin close
%   points
function XYclean=mergecloseones(XY,MinLengt)
MinPix=2;
Factor=3;
XYclean=XY;
% XYsave=[];
d=get_distance(XYclean);
Nclose=find(d<=MinLengt/Factor); % Nclose are very close to Nclose-1
% if numel(Nclose)>1
%     % XYinit=XYclean(setdiff(1:size(XYclean,1),unique([Nclose(2:end);Nclose(2:end)-1])),:);
%     FarIndex=setdiff(1:size(XYclean,1),unique([Nclose(2:end);Nclose(2:end)-1]));
% else
%     % XYinit=[];
%     FarIndex=[];
% end
% XYsave=XY;
XYsave=round(XY.*10)/10; % only one decimal digit
IndexSave=1:size(XY,1);
NclosePRE=Nclose;
while numel(Nclose)>1
    XYtemp=[];
    DifPairs=[Nclose,Nclose-1];
    % FIRST APPROACH
    if numel(Nclose)==3
        disp('ok')
    end
    for n=2:numel(Nclose)
        ione=DifPairs(n,1);
        itwo=DifPairs(n,2);
        XYtemp=mean([XYclean(ione,:);XYclean(itwo,:)],1);
        % FarIndex=sort([FarIndex;itwo]);
        XYsave(IndexSave(ione),:)=XYtemp;
        XYsave(IndexSave(itwo),:)=XYtemp;
        fprintf('*')
    end
    
%     % Find Consecutive close indexes:
%     indXX=[find(diff(unique([Nclose;Nclose-1]))>1)+1;numel(Nclose)];
%     for n=1:numel(indXX)-1
%         ione=Nclose(indXX(n));
%         itwo=Nclose(indXX(n+1))-1;
%         XYtemp=mean(XYclean(ione:itwo,:),1);
%         XYsave(IndexSave(ione:itwo),:)=repmat(XYtemp,itwo-ione+1,1);
%         fprintf('*')
%     end
    fprintf('\n')
    
    XYsave=round(XYsave.*10)/10;
    % [XYclean,IndexSave]=unique(XYsave,'rows','stable');
    dsave=get_distance(XYsave);
    IndexSave=find(dsave>MinPix);
    XYclean=XYsave(IndexSave,:);
    d=get_distance(XYclean);
%     d=get_distance(XYsave);
    % XYclean=[XYinit;XYtemp];
    Nclose=intersect(find(d<MinLengt/Factor),find(d>MinPix));
    % Nclose=find(d<MinLengt/Factor);
%     [numel(Nclose),sum(d>MinPix)]
    NclosePRE=Nclose;
%     if numel(Nclose)>1
%         XYinit=XYclean(setdiff(1:size(XYclean,1),unique([Nclose(2:end);Nclose(2:end)-1])),:);
%     else
%         XYinit=[];
%     end
%     XYclean=XYtemp;
%     XYsave=[XYsave;XYtemp];
end

% XYclean=unique(XYsave,'rows','stable');

dsave=get_distance(XYsave);
IndexSave=find(dsave>MinPix);
XYclean=XYsave(IndexSave,:);
    
    
    

% XYclean=[]; % d(i)=eucdist(XY(i,:)-XY(i-1,:))
% XYtemp=[];
% % Close
% 
% XYtemp=[];
% IndxClose=unique([1;find(diff([0;Nclose])>1);numel(Nclose)]);
% XYclean=[];
% for n=1:numel(IndxClose)-1
%     XYclean=[XYclean;mean(XY(IndxClose(n):IndxClose(n+1)-1,:),1)];
% end
% % Distantas
% XYclean=[ XYclean; XY( d>=MinLengt/Factor,: ) ];
% for n=2:numel(d)
%     % d is the distance between XXY_n and XY_{n-1}
%     if d(n)<MinLengt/Factor
%         XYtemp=[XYtemp;XY(n-1,:);XY(n,:)];
%         % keep close ones, closer (in XYtemp)
%     else
%         if isempty(XYtemp)
%             XYclean=[XYclean;XY(n-1,:);XY(n,:)];
%         else
%             XYclean=[XYclean;mean(XYtemp)];
%             XYtemp=[];
%             XYclean=[XYclean;XY(n-1,:);XY(n,:)]; % NEW
%         end
%     end
end