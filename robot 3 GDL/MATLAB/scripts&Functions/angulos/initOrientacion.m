function orientacion = initOrientacion(matrizRot)
matrizRot = matrizRot .* ( [1 1 -1;1 1 -1;-1 -1 1] );

orientacion.matrizRotOriginal = matrizRot;

degYPR = rotm2eul(matrizRot,'ZYX'); % matlab function

degYPR = round(rad2deg(degYPR));

orientacion.degYPR = degYPR;
orientacion.chullaDegYPR = degYPR;

orientacion.origen = degYPR ;

% limites del delta para los desbordes
orientacion.yawDeltaLim = 300;  % 60 grados de permisividad
orientacion.pitchDeltaLim = 300;
orientacion.rollDeltaLim = 300;

orientacion.limMinMaxYPR = [-75 -30 -135 ; 75 60 135];


end

