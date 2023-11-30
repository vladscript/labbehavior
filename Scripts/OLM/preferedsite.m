% Function to know the preference of site of mice in OLM
function  OUTTABLE=preferedsite(CenterArea,bottomLim,topLim,leftLim,rightLim,Xnose,Ynose,pgonA,pgonB)

%% Distribution XY
Xml=mostlikelyvalue(Xnose);
Yml=mostlikelyvalue(Ynose);

%% Q1 
Equis=[CenterArea(1),rightLim(1),rightLim(1),CenterArea(1)];
Yesss=[CenterArea(2),rightLim(2),topLim(2),topLim(2)];
Q1 = polyshape(Equis,Yesss);
idxQ1=inpolygon(Xnose,Ynose,Equis,Yesss);
AatQ1=inpolygon(pgonA.Vertices(:,1),pgonA.Vertices(:,2),Equis,Yesss);
BatQ1=inpolygon(pgonB.Vertices(:,1),pgonB.Vertices(:,2),Equis,Yesss);
ModQ1=inpolygon(Xml,Yml,Equis,Yesss);
%% Q2 
Equis=[CenterArea(1),leftLim(1),leftLim(1),CenterArea(1)];
Yesss=[CenterArea(2),leftLim(2),topLim(2),topLim(2)];
Q2 = polyshape(Equis,Yesss);
idxQ2=inpolygon(Xnose,Ynose,Equis,Yesss);
AatQ2=inpolygon(pgonA.Vertices(:,1),pgonA.Vertices(:,2),Equis,Yesss);
BatQ2=inpolygon(pgonB.Vertices(:,1),pgonB.Vertices(:,2),Equis,Yesss);
ModQ2=inpolygon(Xml,Yml,Equis,Yesss);
%% Q3
Equis=[CenterArea(1),leftLim(1),leftLim(1),CenterArea(1)];
Yesss=[CenterArea(2),leftLim(2),bottomLim(2),bottomLim(2)];
Q3 = polyshape(Equis,Yesss);
idxQ3=inpolygon(Xnose,Ynose,Equis,Yesss);
AatQ3=inpolygon(pgonA.Vertices(:,1),pgonA.Vertices(:,2),Equis,Yesss);
BatQ3=inpolygon(pgonB.Vertices(:,1),pgonB.Vertices(:,2),Equis,Yesss);
ModQ3=inpolygon(Xml,Yml,Equis,Yesss);
%% Q4
Equis=[CenterArea(1),rightLim(1),rightLim(1),CenterArea(1)];
Yesss=[CenterArea(2),rightLim(2),bottomLim(2),bottomLim(2)];
Q4 = polyshape(Equis,Yesss);
idxQ4=inpolygon(Xnose,Ynose,Equis,Yesss);
AatQ4=inpolygon(pgonA.Vertices(:,1),pgonA.Vertices(:,2),Equis,Yesss);
BatQ4=inpolygon(pgonB.Vertices(:,1),pgonB.Vertices(:,2),Equis,Yesss);
ModQ4=inpolygon(Xml,Yml,Equis,Yesss);

%% Geometry: uneeded


% horQ1=CenterArea-rightLim;
% % horQ1=leftLim-rightLim;
% VhorQ1=repmat(horQ1,size(XY,1),1);  % Vector Horizontal Line
% 
% verQ1=CenterArea-topLim;
% % verQ1=bottomLim-topLim;
% VverQ1=repmat(verQ1,size(XY,1),1);  % Vector Vertical Line
% 
% 
% 
% % Angles
% Vtheta=dot(VhorQ1,XY,2)./(vecnorm(XY,2,2).*vecnorm(VhorQ1,2,2)); % cos of theta
% Htheta=dot(XY,VverQ1,2)./(vecnorm(XY,2,2).*vecnorm(VverQ1,2,2)); % cos of theta
% 
% AngVer=acosd(Htheta);
% AngHor=acosd(Vtheta);
% 
% figure; 
% histogram(AngVer); hold on;
% histogram(AngHor); 
% 
% DotsatQ1=find(and(AngHor<90,AngVer<90))
% DotsatQ2=find(and(AngHor>90,AngVer>90))
% DotsatQ3=find(and(AngHor<90,AngVer>90))
% DotsatQ4=find(and(AngHor>90,AngVer<90))

%% PLOT
% figure;
% % Dots re.centered:
% scatter(Xnose,Ynose); hold on
% plot(Q1)
% scatter(Xnose(idxQ1),Ynose(idxQ1));
% plot(Q2)
% scatter(Xnose(idxQ2),Ynose(idxQ2));
% plot(Q3)
% scatter(Xnose(idxQ3),Ynose(idxQ3));
% plot(Q4)
% scatter(Xnose(idxQ4),Ynose(idxQ4));
% ax1=gca;
% ax1.YDir='reverse'

%% Quantification
SAMPLES=sum([idxQ1,idxQ2,idxQ3,idxQ4])';
OBJA=sum([AatQ1,AatQ2,AatQ3,AatQ4])';
OBJB=sum([BatQ1,BatQ2,BatQ3,BatQ4])';
OUTTABLE=[SAMPLES,OBJA,OBJB,[ModQ1;ModQ2;ModQ3;ModQ4]]

