%% PCA of Feats
X=readtable('C:\Users\vladi\OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO\WORK\Data Analysis\Datos\Conducta\LID\LIDdata\PosterJA2024\CamOF\DATAR3_STATFEATS_TABLE.csv');

Xnum=table2array(X(:,[3:end]));

%% PCA
[wcoeff,score,latent,~,explained] = pca(Xnum,'VariableWeights','variance');

figure
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')

Y=tsne(Xnum,'Algorithm','barneshut','NumPCAComponents',40,'Exaggeration',55);
gscatter(Y(:,1),Y(:,2),HL)

[Y,loss] = tsne(Xnum,'Algorithm','exact');


%%
[Y2,loss2] = tsne(Xnum,'Algorithm','barneshut','NumPCAComponents',40,'Exaggeration',55,'NumDimensions',3);

figure
v = double(categorical(HL));
c = full(sparse(1:numel(v),v,ones(size(v)),numel(v),3));
scatter3(Y2(:,1),Y2(:,2),Y2(:,3),15,c,'filled')
title('3-D Embedding')
view(-50,8)