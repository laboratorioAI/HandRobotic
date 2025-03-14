%% COSAS DEL GUI!
% no prestar atencin, archivo creado para facilitar cdigo
function varargout = interfazUsuario(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       'interfazUsuario.fig', ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interfazUsuario_OpeningFcn, ...
    'gui_OutputFcn',  @interfazUsuario_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function interfazUsuario_OutputFcn(~, ~, ~)


%% inicioGUI
function interfazUsuario_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

inicioInterfaz





%% CONEXIONES

function conectarMyoButton_Callback(~,~,handles)
% se crean funciones para conectar al Lego y al Myo. estas funciones
% modifican la interfaz de usuario.

global mensajeEspere  isConnectedMyo flags
mensajeEspere={'Conectando con Myo', 'por favor espere'};
h1=espere;
drawnow
inicializacionMyo(handles)
drawnow
close(h1);

if isConnectedMyo
    %% abriendo script de reconocimiento
    flags.detener=0; % en 1 se detiene todo, 0 es no detener. seguir
    flags.reconocer=0; % en 1 reconoce
    flags.dibujarEMG=1; % 1 dibuja EMG IMU, 0 dibuja el gesto!
    reconocimientoScriptGUI;
end


function conectarLegoButton_Callback(~, ~, handles)

global mensajeEspere
mensajeEspere = {'Conectando con Lego', 'por favor espere'};
h1 = espere;
drawnow
inicializacionLego(handles);
drawnow
close(h1);


%% BOTONES

function usuarioButton_Callback(~, ~, handles)
usuarioButtonGUI(handles);
drawnow


function mostrarResultadosButton_Callback(~, ~, handles)
% se detiene la ejecucin mientras se muestran los resultados
global flags

%% deteniendo ejecucin


flags.iniciado = false;
flags.reconocer = false;
flags.moverIMULego = false;
set ( handles.iniciarButton , 'String' , 'Reanudar')

set(handles.mensajesTextBox,'String','Mostrando Resultados!')
set(handles.robotRadio,'Enable','off')
set(handles.pausaRadio,'Value',1)

flags.dibujarEMG = 1 ; % para dibujar gesto reconocido!

set(handles.mostrarResultadosButton,'Enable','off')

global mensajeEspere hEspere
mensajeEspere = {'Cargando archivos', 'por favor espere'};
hEspere = espere ;
drawnow
resultadosGUI = resultados;
uiwait(resultadosGUI)
drawnow



function iniciarButton_Callback(hObject, ~, handles)
global flags datosUsuario EV3
try
    flags.iniciado;
catch
    flags.iniciado = false;
end

if ~flags.iniciado % si reconocer
    %
    set ( hObject , 'String' , 'Pausar' )
    flags.iniciado = true ;
    flags.reconocer = true ;
    set(handles.tituloGestoText,'String','Reconociendo')
    set(handles.robotRadio,'Enable','on')
    set(handles.robotRadio,'Value',1)
    
    flags.dibujarEMG = 0 ; % para dibujar gesto reconocido!
    set(handles.mostrarResultadosButton,'Enable','on')
    flags.moverIMULego = 1 ;
    
else
    if flags.isRobotMoving
        pararMandoRobot(datosUsuario,EV3);                        
    end
    flags.moverIMULego = 0 ;
    flags.iniciado = false ;
    set ( hObject , 'String' , 'Reanudar' )
    flags.reconocer= false ;
    set(handles.tituloGestoText,'String','')
    set(handles.pausaRadio,'Value',1)
    set(handles.robotRadio,'Enable','off')
    
    flags.dibujarEMG = true ; % para dibujar gesto reconocido!
end
beep
drawnow


function verUsuarioButton_Callback(~, ~, ~)
verBaseDatos


%% Control Paneles

%% robot control
function pausaRadio_Callback(~, ~, handles)
switchControlRobot(handles)

function yawRadio_Callback(~, ~, handles)
switchControlRobot(handles)

function pitchRadio_Callback(~, ~, handles)
switchControlRobot(handles)

function rollRadio_Callback(~, ~, handles)
switchControlRobot(handles)

function robotRadio_Callback(~, ~, handles)
switchControlRobot(handles)



%% FINAL!
function mainCanvas_CloseRequestFcn(hObject, ~, ~)
global flags isConnectedLego EV3
flags.detener = true ;
flags.reconocer = false ;
% flags.leidoMyo = 0; % para salir del lazo del reconocimiento!

delete(hObject);

if isConnectedLego
    EV3.writeMailBox('modos','text','finalizar')
end
isConnectedLego = false;


function tiempoBUtton_Callback(hObject, eventdata, handles)
figure
try
tiemposPlot
handles.mensajesTextBox.String = '';
catch
    handles.mensajesTextBox.String = 'pause la ejecucin';
end
