function Lengths=anlayzestrides(XYa,distrefe)
Lengths=[];
if ~isempty(XYa)
    
    D=pdist(XYa);
    Lengths=D(intersect(find(D>distrefe*0.8),find(D<distrefe*1.2)));
    if ~isempty(Lengths)
        fprintf('\n Average lengths found: %3.2f\n',mean(Lengths));
    else
        fprintf('\n No intersection found\n');
    end
else
    fprintf('\n No data found.\n')
end
end