% Versión Lego
% Funcióon para grabar datos emg de un gesto usando librería MYO MEX!
% Myo debe estar conectado
% Datos son almacenados en variable global datosUsuarios.nombre del gesto.
% Al finalizar son grabados en el la carpeta usersData

% donde gesto va desde 1 a último gesto grabado.

%%
function datosUsuario=grabarGestoGUI(datosUsuario,datosReconocimiento)


%% leyendo
tiempoGesto=datosUsuario.tiempoGesto;

numRepeticion=datosUsuario.numRepeticionesEntrenadas+1;
numGesto=datosUsuario.numGestosEntrenados+1;
nombreGesto=datosReconocimiento.nameGestures{numGesto};

global flags emg myoObject
emg=zeros(1,8);
drawnow

% Configuración del Timer
flags.leidoMyo=0;
tmr = timer('ExecutionMode','fixedRate','TasksToExecute',1,...
    'TimerFcn',@(~,~)myoTimerFunction,'StartDelay',tiempoGesto,'Period',tiempoGesto);
myoObject.myoData.clearLogs();

% Inicio del timer
tic
start(tmr)

% Waiting bar
h = waitbar(0,'Por favor espere');

%% Esperando lectura de los datos
while  flags.leidoMyo==0
    clc
    percentage=(toc)/tiempoGesto;
    waitbar(toc/tiempoGesto,h);
    percentage = percentage *100;
    fprintf('Please wait: %4.2f%%',percentage)
    drawnow
end
close(h);
clc
beep
fprintf('Gesto grabado\nGRACIAS!\n');

% Deteniendo timer
stop(tmr);
delete(tmr);

%% Grabando
datosUsuario.gestos.(nombreGesto).emg{numRepeticion,1}=emg;
datosUsuario.gestos.(nombreGesto).fecha=date;

emg=zeros(1,8); % Clearing variable emg for new data

end