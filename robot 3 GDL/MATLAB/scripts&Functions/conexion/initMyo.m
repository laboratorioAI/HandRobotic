% Valores predefinidos del sistema de Clasificación de gesto del Myo
% Armband
% variable global incluyendo datos por defecto!
global reconocimientoConfiguracion  datosUsuario myoObject

%% valores predefinidos de clasificación!
windowTime = 1;
ordenFiltro=4;
freqFiltro=0.05;
nameGestures={'WaveIn';'WaveOut';'Fist';'Open';'Pinch';'noGesto'};

reconocimientoConfiguracion.timeShiftWindow=0.25;
reconocimientoConfiguracion.windowTime=windowTime;
reconocimientoConfiguracion.ordenFiltro=ordenFiltro;
reconocimientoConfiguracion.freqFiltro=freqFiltro;
[reconocimientoConfiguracion.Fb, reconocimientoConfiguracion.Fa] = butter(ordenFiltro, freqFiltro, 'low'); % creando filtro
reconocimientoConfiguracion.kNN=5;
reconocimientoConfiguracion.probabilidadkNNUmbral=0.7;
reconocimientoConfiguracion.nameGestures=nameGestures;
reconocimientoConfiguracion.numTry=5;
reconocimientoConfiguracion.timeGesture=2;
reconocimientoConfiguracion.numGestures=length(nameGestures); % totales incluyendo noGesto


%% Para dibujar!
datosUsuario.emgVector = zeros( windowTime * 200,8); % basado en el tamaño de la ventana y la freq del EMG


%% cargando imágenes en variable usuarios
for  kGesto=1:reconocimientoConfiguracion.numGestures % incluye el noGesto?
    nombreGesto =reconocimientoConfiguracion.nameGestures{kGesto};
    imageGesture = imread(['images\' nombreGesto  '.png']); % leyendo imagen
    
    reconocimientoConfiguracion.imagenGesto.(nombreGesto)=imageGesture;
    
end



%% Conectar MYO
% isConnected es una bandera del Myo. connectMyo es la función para conectar el MYO
isConnectedMyo =  connectMyo(handles);
pause(0.5) % estabilizar IMU

if isConnectedMyo
    
    Ro = myoObject.myoData.rot
    datosUsuario.orientacion = initOrientacion(Ro);
    
end


