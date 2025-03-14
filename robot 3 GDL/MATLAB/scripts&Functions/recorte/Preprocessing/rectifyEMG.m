function rectifiedEMG = rectifyEMG(rawEMG, rectFcn)
switch rectFcn
    case 'square'
        rectifiedEMG = rawEMG.^2;
    case 'abs'
        rectifiedEMG = abs(rawEMG);
    case 'none'
        rectifiedEMG = rawEMG;
    otherwise
        fprintf(['Wrong rectification function. Valid options are square, ',...
            'abs and none']);
end
return