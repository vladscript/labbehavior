% save_colormap_data
HMName=[file(1:indxmark-1),'_HeatMAP.csv'];
N=N/fps; % SECONDS
csvwrite([[FileOutput,HMName]],N)