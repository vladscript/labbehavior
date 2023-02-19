function Npcs=explorpca(Xparts,pci,pcj)

rowsOK=find(~isnan(sum(Xparts,2)));
% idx=Xparts(rowsOK,end)
[wcoeff,score,latent,tsquared,explained] = pca(Xparts(rowsOK,:),...
    'Rows','complete','VariableWeights','variance');
idx=1:numel(rowsOK);

Npcs=find(cumsum(explained)>95,1);

scatter(score(:,pci),score(:,pcj),[],idx)

%  coefforth = inv(diag(std(Xparts(rowsOK,:))))*wcoeff;
%  cscores = zscore(Xparts(rowsOK,:))*coefforth;