global datosUsuario reconocimientoConfiguracion flags isConnectedLego myoObject 
set(handles.mensajesTextBox, 'String', 'Preparando para la clasificación')

%% Cargando variables del clasificador!
tiempoSaltoVentana = reconocimientoConfiguracion.timeShiftWindow;

%% Constantes
tiempoEjecucionMax = 300; % [seg]. tiempo máximo de ejecución!!! 5 minutos
numEjecucionesTimer = ceil(tiempoEjecucionMax / tiempoSaltoVentana);

%% Declaración de Variables
numEjecucionesTimer = ceil(tiempoEjecucionMax / tiempoSaltoVentana);

%% Variables del reconocimiento
flags.leidoMyo = 0; % flag de datos EMG listos
kEjecucionesLoop = 1; % más uno al final
flags.kEjecucionesLoop = 1;
flags.kGestosReconocidos = 0 ;
datosUsuario.gestoRespuestaPendiente = 6 ; % no gesto
datosUsuario.gestoRespuesta = 6 ;
datosUsuario.gestoDibujado = false ;
datosUsuario.angulos = 0 ; % cambiar ángulos
datosUsuario.real = [];


% vectores con datos de tiempo para análisis
tiempoClasificacionVector = zeros(numEjecucionesTimer, 1);
tiempoLoopTotalVector = nan(numEjecucionesTimer, 1);
tiempoOcioVector = zeros(numEjecucionesTimer, 1);

% Gesto resultante del DTW
gestoMasProbableVector = zeros(numEjecucionesTimer, 1);
probGestoVector = zeros(numEjecucionesTimer, 1);

% Gesto resultante. FINALES, al aplicar filtro y umbral.
gestoRespuestaVector = zeros(numEjecucionesTimer, 1);
probabilidadVector = zeros(numEjecucionesTimer, 1);

%% final Robot
global YPRang
YPRang = [0 0 0];


%% Configuración timer
set(handles.mensajesTextBox, 'String', 'Reconocimiento listo!')
timerReconocimiento = timer('ExecutionMode', 'fixedRate', 'TasksToExecute', numEjecucionesTimer, ...
    'TimerFcn', @(~, ~)myoTimerFunction, 'StartDelay', tiempoSaltoVentana, 'Period', tiempoSaltoVentana);

%% timer envio datos
tiempoEnvio = 0.1;
numEjecucionesTimerEnvio = ceil(tiempoEjecucionMax / tiempoEnvio);

timerEnvio = timer('ExecutionMode', 'fixedRate', 'TasksToExecute', numEjecucionesTimerEnvio, ...
    'TimerFcn', @(~, ~)envioTimerFunction, 'StartDelay', tiempoEnvio, 'Period', tiempoEnvio);

start(timerEnvio)
start(timerReconocimiento)
