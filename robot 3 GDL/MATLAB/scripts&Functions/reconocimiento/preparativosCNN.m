global datosUsuario reconocimientoConfiguracion flags isConnectedLego myoObject 
set(handles.mensajesTextBox, 'String', 'Preparando para la clasificación')

%% Cargando variables del clasificador!
tiempoVentana = reconocimientoConfiguracion.windowTime;
tiempoSaltoVentana = reconocimientoConfiguracion.timeShiftWindow;
numGestos = reconocimientoConfiguracion.numGestures;
Fb = reconocimientoConfiguracion.Fb;
Fa = reconocimientoConfiguracion.Fa;
nombreGestos = reconocimientoConfiguracion.nameGestures;
numRepeticiones = datosUsuario.numRepeticiones;
database = datosUsuario.database;

if isfield(datosUsuario, 'numRepeticiones')
    numRepeticiones = datosUsuario.numRepeticiones;
else
    error('El campo numRepeticiones no existe en datosUsuario.');
end

%% Constantes
freq = 200; % Hz. Frecuencia por defecto
tiempoEjecucionMax = 300; % [seg]. tiempo máximo de ejecución!!! 5 minutos

%% Declaración de Variables
muestrasVentana = round(tiempoVentana * freq);
numEjecucionesTimer = ceil(tiempoEjecucionMax / tiempoSaltoVentana);

% variables dependientes del reconocimiento
DTWdeSignalClasificar = zeros(numRepeticiones * numGestos, 8);
[sizeDatabase, ~] = size(database);
signalClasificar = zeros(muestrasVentana, 8);

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

%% Variables del reconocimiento
flags.leidoMyo = 0; % flag de datos EMG listos
kEjecucionesLoop = 1; % más uno al final
flags.kEjecucionesLoop = 1;
flags.kLazosReconocimientoDibujados = 0;
flags.kExeXSamPerdidasRecog = 0; % contador de las veces que no tuvo datos en el reconocimiento
flags.kMyoRecibido = 0; % veces que se ejecuto la función del Myo
flags.gestoFiltrado = 0; % bandera para aplicar posfiltro
flags.kGestosReconocidos = 0;
flags.dibujarGestoReconocido = false;
flags.kCasiNoDibujadosGestos = 0;
flags.kGestosDibujados = 0;
datosUsuario.gestoRespuestaPendiente = 6; % no gesto

datosUsuario.gestoDibujado = false;
datosUsuario.gestoRespuesta = 6;
datosUsuario.angulos = 0; % cambiar ángulos

% robot
flags.moverIMULego = isConnectedLego; % iniciamos! % se conecta desde "initLego"
flags.isRobotMoving = false; % toggle
flags.kdiscernirGesto2Robot = 0;
flags.LimpiarAxes = true;
flags.tiempoAlerta = 0; % lazo mayor a 200 milisegundos.
flags.muestrasPerdidas = false; % si no encontró 
flags.kGestosRepetidos = 0;

flags.kDatosLegoEnviados = 0;
datosUsuario.real = [];

%% CNN

%global mensajeEspere  
%mensajeEspere = {'Preparando para reconocimiento', 'por favor espere'}; 
%h1 = espere;
%drawnow
%close(h1);
%drawnow

%dibujarGUI_CNN(handles, gestoRespuesta, myoObject, reconocimientoConfiguracion, datosUsuario);
%ejecutarCNNTiempoReal(handles, reconocimientoConfiguracion)


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

