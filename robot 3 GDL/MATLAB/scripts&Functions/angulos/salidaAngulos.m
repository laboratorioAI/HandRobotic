% se le suma el origen... el primer  punto válido!
% saturador! no hay filtro

function [yaw,pitch,roll] = salidaAngulos ( orientacion )
% YPR = orientacion.degYPR(end,:);
YPR = orientacion.chullaDegYPR;

YPR = YPR - orientacion.origen;

limMin = orientacion.limMinMaxYPR(1,:); 
limMax = orientacion.limMinMaxYPR(2,:); 

saturarArriba = YPR > limMax; % si es mayor se intercambia el valor
YPR = saturarArriba .* limMax + ~saturarArriba .* YPR ;

saturarAbajo = YPR < limMin;
YPR = saturarAbajo .* limMin + ~saturarAbajo .* YPR ;

yaw = YPR(1);
pitch = YPR(2);
roll = YPR(3);
end
