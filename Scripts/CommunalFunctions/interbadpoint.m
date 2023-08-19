function x=interbadpoint(x,nookinde,spanw)
    xs=smooth(x,spanw,'rloess');
    x(nookinde)=xs(nookinde);
end