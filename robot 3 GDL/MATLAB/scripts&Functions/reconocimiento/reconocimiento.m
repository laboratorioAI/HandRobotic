% un reconocimiento!
% tiempo de espera en lazo
isPrimerLazoEspera = true ;
tiempoOcio = tic;

%% Esperando datos EMG disponibles
while  (flags.dibujarGestoReconocido) ... % cuando es importantísimo que dibuje!!
        || ~flags.leidoMyo && flags.reconocer && ~flags.detener % si ya leyó valor, si hay q reconocer, si hay q acabar ejecución
    drawnow
    %% gráficos GUI
    if isPrimerLazoEspera  % se ejecuta una vez
        [datosUsuario] = dibujarGUI(handles,datosUsuario,myoObject ,reconocimientoConfiguracion ,emg);
        isPrimerLazoEspera = false;
        flags.dibujarGestoReconocido = false;
        flags.kLazosReconocimientoDibujados = flags.kLazosReconocimientoDibujados + 1 ;
    end
    % angulosEnviarRobot(); % solo si es que se está moviendo
    drawnow
    
    if toc(tiempoOcio) > tiempoSaltoVentana * 5  % demasiado tiempo esperando!!
        flags.detener = true ;
        flags.reconocer = false ;
        flags.moverIMULego = false ;
        disp('Mucho tiempo  esperando en reconocimiento!!!!')
        return
    end
end

flags.leidoMyo = false ;
% medición de tiempos
tiempoOcioVector(kEjecucionesLoop) = toc(tiempoOcio);
tiempoClasificacion=tic;




%% Preprocesamiento
% cargando y flitrando gesto a ser analizado

% Cargando muestras obtenidas
emgPlot = emg ;
muestrasObtenidasLoop = size( emgPlot , 1 );

if muestrasObtenidasLoop == 0
    muestrasObtenidasLoop = 40 ;
    emgPlot = zeros( 40 , 8 ) ;
    
    flags.kExeXSamPerdidasRecog = flags.kExeXSamPerdidasRecog + 1;
    flags.muestrasPerdidas = true ;
    
elseif muestrasObtenidasLoop > 200 * 0.5 %% eliminamos log!
    muestrasObtenidasLoop
    muestrasObtenidasLoop = 100;
    emgPlot = emg( 1:100, : ) ;
    disp('caso rarísimo en reconocimiento')
end


% concatenando señal a clasificar!
signalClasificar = circshift(signalClasificar,-muestrasObtenidasLoop);

signalClasificar(end-muestrasObtenidasLoop+1:end,:) = emgPlot;

signalClasificar = filtfilt(Fb, Fa,abs(signalClasificar));


%% DTW
% El algoritmo DTW es calculado entre la señal a clasificar
% "signalClasificar" y todas las señales del database, por canal. El
% resultado de estas operaciones se almacena como una matriz 30x8
% DTWdeSignalClasificar.


parfor kDatabase=1:sizeDatabase
    for kChannel=1:8
        DTWdeSignalClasificar(kDatabase,kChannel)=...
            dtw_c(database{kDatabase,kChannel},signalClasificar(:,kChannel),50);
    end
end




%% Reducción a una dimensión
% Se suma el resultado DTW de los ocho canales.
% DTWsumCanales es un vector columna que contiene la suma de las
% distancias DTW entre la señal a clasificar (signalClasificar) y las
% señales del database.
DTWsumCanales=sum(DTWdeSignalClasificar,2);




%% kNN
% Se ordena el resultado de la suma de los DTW. La variable
% kNNresults contiene la posición de los resultados con menor suma de
% distancias DTWs.

[~,kNNresults]=sort(DTWsumCanales);
% [DTWValuesSortedKNN,kNNresults]=sort(DTWsumCanales); % se ignoran los valores del DTW

kNNresults=ceil(kNNresults/numRepeticiones);
% esta división cambia el significado de kNNresults.
% Ahora contiene el número de gesto correspondiente a los menores DTW

kNNresults=kNNresults(1:kNN,:);         % Escogiendo los k más cercanos
%     DTWValuesSortedKNN=DTWValuesSortedKNN(1:kNN,:);

% Encontrando el gesto más común entre los vecinos más cercanos con
% su respectiva probabilidad
[gestoMasProbablekNN,probGestokNN]=mode(kNNresults);

probGestokNN=probGestokNN/kNN;         % probabilidad por unidad

gestoString=char(nombreGestos{gestoMasProbablekNN}); % Asignando nombre al gesto resultante

% Resultados únicamente de KNN, antes de filtrado y umbralKNN
probGestoKNNVector(kEjecucionesLoop)=probGestokNN;
gestoMasProbablekNNVector(kEjecucionesLoop)=gestoMasProbablekNN;





%% Umbral y Filtro
gestoRespuesta=0; % variable de salida! Por defecto es 0: "noGesto"

% ignoro resultado de noGesto
if gestoMasProbablekNN~=6
    % Umbral
    if probGestokNN>probabilidadkNNUmbral        % Comparando que se supere el umbral de probabilidad
        
        if kEjecucionesLoop>1 % debido únicamente a que compara con valor anterior, es decir, en el primer lazo, respuesta es noGesto
            
            
            % filtro a la salida. Compara que el gesto sea igual al
            % resultante anterior. El gesto resultante anterior es
            % aquel sin cosiderar el umbral.
            if gestoMasProbablekNNVector(kEjecucionesLoop-1)==gestoMasProbablekNN
                gestoRespuesta=gestoMasProbablekNN;
            end
            
            
            % cambio de estado
            if gestoRespuestaVector(kEjecucionesLoop-1)==gestoRespuesta % resultado debe ser igual al gesto respuesta anterior
                flags.gestoFiltrado=gestoRespuesta;
                gestoRespuesta=0; % aplicando filtro
                
                % cuando se ha aplicado el filtro, el gesto del
                % filtrado se guarda como variable. esta se compara en
                % lazos siguientes para ignorar
            elseif flags.gestoFiltrado==gestoMasProbablekNN % si el gesto de KNN es respuesta del filtro
                gestoRespuesta=0;
            end
        end
    end
end
datosUsuario.gestoRespuesta = gestoRespuesta ;


%% Imprimiendo resultados
if gestoRespuesta ~= 0 || gestoRespuesta ~= 0  % O no gesto resultante o noGesto
    % Cuando el gesto resultante no supera el umbral o cuando el
    % resultado del KNN devuelve no gesto
    
    gestoRespuestaVector(kEjecucionesLoop) = gestoRespuesta ;
    probabilidadVector(kEjecucionesLoop) = probGestokNN ;
    
    datosUsuario.gestoRespuestaPendiente = gestoRespuesta ;
    flags.kGestosReconocidos = flags.kGestosReconocidos  + 1 ;
    flags.dibujarGestoReconocido = true ;
else
    flags.dibujarGestoReconocido = false ;
end



%% ROBOT
if flags.moverIMULego

    gestos2MandoRobot(handles)

%     angulosEnviarRobot; % se enviaba en el drawnow! Eran muchos...
% se envía con timer
end





%% Final de lazo
% tiempos
tiempoClasificacionVector(kEjecucionesLoop) = toc(tiempoClasificacion);


tClass = tiempoClasificacionVector(kEjecucionesLoop)+tiempoOcioVector(kEjecucionesLoop);

tiempoLoopTotalVector(kEjecucionesLoop) = tClass;

if tClass > tiempoSaltoVentana * 1.15 % 15% de tolerancia
    % cuando el tiempo del lazo actual supera el tiempo de la ventana.
    % Time problems.
    
    flags.tiempoAlerta = true;
    flags.tClass = tClass / tiempoSaltoVentana;
    
    % 33 set( handles.auxiliarText , 'String' , [ num2str(tClass / tiempoSaltoVentana) ] )
    %     fprintf('!!!!%4.2f| \n',...
    %         (tiempoClasificacionVector(kEjecucionesLoop)+tiempoOcioVector(kEjecucionesLoop))/tiempoSaltoVentana*100);
end

kEjecucionesLoop = kEjecucionesLoop + 1;
flags.kEjecucionesLoop = kEjecucionesLoop;

