TOTAL=[A;B;C];
CATS=[ones(size(A));2*ones(size(B));3*ones(size(C));]

[p,tbl,stats] = kruskalwallis(TOTAL,CATS);

% 'tukey-kramer'|'hsd'|'lsd'|'bonferroni'|'dunn-sidak'|'scheffe'
[c,m] = multcompare(stats,'CType','lsd');