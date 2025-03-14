% hace la corrección ante desbordes!

function angulo = ajusteAngulo(anguloDeltaLim,anguloAnterior,anguloAhorita)

%% ajuste angulo
% anguloDeltaLim = orientacion.anguloDeltaLim ;
% 
% anguloAnterior = orientacion.degYPR(end,1);
% anguloAhorita = degYPR(1);

% delta
deltaAngulo = abs ( anguloAhorita  - anguloAnterior ) ;

% decision
if deltaAngulo >= anguloDeltaLim % desborde!!!
    angulo = sign( anguloAnterior ) * ( 360  - abs( anguloAhorita ) ) ;
    
else
    angulo = anguloAhorita ;
    
end
