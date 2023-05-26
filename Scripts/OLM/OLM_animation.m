%% OLM animation

% Make Animation of Distances
makeanimation=true; % visualizar
savebool=true; % guardar .avi de animación

%% Animation
if makeanimation
    animatedistance(pgonA,pgonB,Xnose,Ynose,topLim,bottomLim,rightLim,leftLim,fps,savebool);
end
