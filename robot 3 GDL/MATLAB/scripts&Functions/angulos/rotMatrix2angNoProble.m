% la mismisima matriz de rotación del myoData...
% decide a partir de los vectores anteriores...
% legacy
% RoInv = [-1 0 0;0 -1 0;0 0 1];
% matrizRot = RoInv*matrizRot.*([-1 -1 1;-1 -1 1;-1 -1 1]); % rotación de eje!

function [orientacion] = rotMatrix2angNoProble(matrizRot,orientacion)

% matrices originales
orientacion.matrizRotOriginal = cat(3,orientacion.matrizRotOriginal,matrizRot);

% rotación de eje!
matrizRot = matrizRot .* ( [1 1 -1;1 1 -1;-1 -1 1] );
orientacion.matrizRot = matrizRot;

% conversión a yaw pitch roll
% [q1 ,q2, q3] = matrizRot2ang(matrizRot,'Rzxy'); % exactamente lo mismo
degYPR = rotm2eul(matrizRot,'ZYX'); % matlab function

% a grados
degYPR = round(rad2deg(degYPR));

% yaw
% yawAnterior = orientacion.degYPR(end,1);
yawAnterior = orientacion.chullaDegYPR(1);
yawAhorita = degYPR(1);

yaw = ajusteAngulo(orientacion.yawDeltaLim,yawAnterior,yawAhorita);


% pitch
% pitchAnterior = orientacion.degYPR(end,2);
pitchAnterior = orientacion.chullaDegYPR(2);
pitchAhorita = degYPR(2);

pitch = ajusteAngulo(orientacion.pitchDeltaLim,pitchAnterior,pitchAhorita);

% roll
% rollAnterior = orientacion.degYPR(end,3);
rollAnterior = orientacion.chullaDegYPR(3);
rollAhorita = degYPR(3);

roll = ajusteAngulo(orientacion.rollDeltaLim,rollAnterior,rollAhorita);

% memoria
degYPR = [ yaw pitch roll ];
orientacion.chullaDegYPR = degYPR;
orientacion.degYPR = [orientacion.degYPR ; degYPR ];

end
