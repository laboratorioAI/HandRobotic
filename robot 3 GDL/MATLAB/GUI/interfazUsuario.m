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
    global flags;
    handles.output = hObject;
    guidata(hObject, handles);

    inicioInterfaz;
    
    % Inicializar la variable global
    flags.reconocimientoActivo = false; % Reconocimiento no activo al inicio

    % Desactivar los radio buttons al inicio
    habilitarPanelAlgoritmos(handles, false); % Panel de algoritmos deshabilitado inicialmente

%% CONEXIONES
function conectarMyoButton_Callback(~, ~, handles)
    % Conecta el Myo y habilita los radio buttons de algoritmos si es exitoso
    global mensajeEspere isConnectedMyo flags
    mensajeEspere = {'Conectando con Myo', 'por favor espere'};
    h1 = espere;
    drawnow;
    inicializacionMyo(handles); % Función personalizada para inicializar Myo
    drawnow;
    close(h1);

    if isConnectedMyo
        %% Activar el panel de algoritmos
        habilitarPanelAlgoritmos(handles, true); % Habilitar los radio buttons de algoritmos
        %% Lógica adicional para reconocimiento
        flags.detener = 0; % En 1 se detiene todo, 0 es no detener. seguir
        flags.reconocer = 0; % En 1 reconoce
        flags.reconocerCNN = 0; % En 1 reconoce
        flags.dibujarEMGCNN = 1;
        flags.dibujarEMG = 1; % 1 dibuja EMG IMU, 0 dibuja el gesto!
        reconocimientoScriptGUI;
    end

function conectarLegoButton_Callback(~, ~, handles)
    % Ejemplo de lógica para conectar un Lego
    global mensajeEspere
    mensajeEspere = {'Conectando con Lego', 'por favor espere'};
    h1 = espere;
    drawnow;
    inicializacionLego(handles);
    drawnow;
    close(h1);

%% BOTONES
function usuarioButton_Callback(~, ~, handles)
    if get(handles.radiobutton27, 'Value') == 1 % El radio button KNN está seleccionado
        usuarioButtonGUI(handles);
        drawnow;
    else
        disp('Error: El algoritmo KNN no está seleccionado.');
        set(handles.mensajesTextBox, 'String', 'Seleccione el algoritmo KNN para continuar.');
    end

function mostrarResultadosButton_Callback(~, ~, handles)
    % Detener ejecución mientras se muestran los resultados
    global flags

    %% Deteniendo ejecución
    flags.iniciado = false;
    flags.reconocer = false;
    flags.reconocerCNN = false;
    flags.moverIMULego = false;
    set ( handles.iniciarButton , 'String' , 'Reanudar');

    set(handles.mensajesTextBox,'String','Mostrando Resultados!');
    set(handles.robotRadio,'Enable','off');
    set(handles.pausaRadio,'Value',1);

    flags.dibujarEMG = 1; % Para dibujar gesto reconocido!
    flags.dibujarEMGCNN = 1;
    set(handles.mostrarResultadosButton,'Enable','off');

    global mensajeEspere hEspere
    mensajeEspere = {'Cargando archivos', 'por favor espere'};
    hEspere = espere;
    drawnow;
    resultadosGUI = resultados;
    uiwait(resultadosGUI);
    drawnow

function iniciarButton_Callback(hObject, ~, handles)
    global flags datosUsuario EV3 algoritmoSeleccionado reconocimientoConfiguracion;
    try
        flags.iniciado;
    catch
        flags.iniciado = false;
    end

    % Validar que algoritmoSeleccionado sea válido
    if isempty(algoritmoSeleccionado) || ~isscalar(algoritmoSeleccionado)
        set(handles.mensajesTextBox, 'String', 'Error: Seleccione un algoritmo antes de iniciar.');
        beep;
        return;
    end

    % Ejecutar el switch con un valor válido
    switch algoritmoSeleccionado
        case 1 % Caso KNN
            disp('Iniciando reconocimiento con KNN...');
            if ~flags.iniciado % Si el reconocimiento no está activo
                flags.reconocimientoActivo = true; % Marca el inicio del reconocimiento
                set(hObject, 'String', 'Pausar');
                flags.iniciado = true;
                flags.reconocer = true;
                set(handles.tituloGestoText, 'String', 'Reconociendo');
                set(handles.robotRadio, 'Enable', 'on');
                set(handles.robotRadio, 'Value', 1);

                flags.dibujarEMG = 0; % Para dibujar gesto reconocido
                set(handles.mostrarResultadosButton, 'Enable', 'on');
                flags.moverIMULego = 1;
            else
                if flags.isRobotMoving
                    pararMandoRobot(datosUsuario, EV3);
                end
                flags.moverIMULego = 0;
                flags.iniciado = false;
                set(hObject, 'String', 'Reanudar');
                flags.reconocer = false;
                set(handles.tituloGestoText, 'String', '');
                set(handles.pausaRadio, 'Value', 1);
                set(handles.robotRadio, 'Enable', 'off');
                flags.reconocimientoActivo = false; % Marca el fin del reconocimiento
            end       
        case 2 % Caso CNN
            disp('Iniciando reconocimiento con CNN...');
            if ~flags.iniciado
                flags.reconocimientoActivo = true; % Marca el inicio del reconocimiento                       
                set(hObject, 'String', 'Pausar'); % Cambiar texto a "Pausar"
                flags.iniciado = true;
                flags.reconocerCNN = true;

                set(handles.tituloGestoText, 'String', 'Reconociendo');
                set(handles.robotRadio, 'Enable', 'on');
                set(handles.robotRadio, 'Value', 1);
                flags.dibujarEMGCNN = 0; % Para dibujar gesto reconocido
                set(handles.mostrarResultadosButton, 'Enable', 'on');
                flags.moverIMULego = 1;
                
            else
                % Verificar si el robot está moviéndose y detenerlo si es necesario
                if flags.isRobotMoving
                    pararMandoRobot(datosUsuario, EV3); % Detener robot si está en movimiento
                end

                flags.moverIMULego = 0;
                disp(['Estado de moverIMULego al pausar reconocimiento: ', num2str(flags.moverIMULego)]); % Mostrar el estado al pausar
                flags.iniciado = false;
                set(hObject, 'String', 'Reanudar');
                flags.reconocerCNN = false; 
                set(handles.tituloGestoText, 'String', '');
                set(handles.pausaRadio, 'Value', 1);
                set(handles.robotRadio, 'Enable', 'off');
                flags.reconocimientoActivo = false;
            end

        otherwise
            set(handles.mensajesTextBox, 'String', 'Error: Algoritmo desconocido.');
            beep;
    end

    % Si el reconocimiento termina y cambia de algoritmo, restaurar el texto del botón
    if ~flags.reconocimientoActivo
        set(hObject, 'String', 'Iniciar'); % Restaurar texto a "Iniciar"
        disp('Reconocimiento finalizado. Botón restaurado a "Iniciar".');
    end
    
    drawnow;

function verUsuarioButton_Callback(~, ~, handles)
    if get(handles.radiobutton27, 'Value') == 1 % El radio button KNN está seleccionado
        verBaseDatos();
    else
        disp('Error: El algoritmo KNN no está seleccionado.');
        set(handles.mensajesTextBox, 'String', 'Seleccione el algoritmo KNN para continuar.');
    end

%% FINAL!
function mainCanvas_CloseRequestFcn(hObject, ~, ~)
    % Cierre de la aplicación
    global flags isConnectedLego EV3
    flags.detener = true;
    flags.reconocer = false;
    flags.reconocerCNN = false;

    delete(hObject);

    if isConnectedLego
        EV3.writeMailBox('modos', 'text', 'finalizar');
    end
    isConnectedLego = false;

function tiempoBUtton_Callback(hObject, eventdata, handles)
    % Mostrar tiempos
    figure;
    try
        tiemposPlot;
        handles.mensajesTextBox.String = '';
    catch
        handles.mensajesTextBox.String = 'Pausa la ejecución';
    end

%% Algoritmos
% Para KNN (radio button 27)
function radiobutton27_Callback(hObject, eventdata, handles)
    global algoritmoSeleccionado flags;
    if flags.reconocimientoActivo
        % No permitir cambio de algoritmo mientras el reconocimiento está activo
        set(hObject, 'Value', 0); % Desactiva el radio button
        set(handles.radiobutton28, 'Value', 1); % Mantiene seleccionado CNN
        set(handles.mensajesTextBox, 'String', 'Finalice el reconocimiento actual antes de cambiar a KNN.');
        beep;
        return;
    end
    
    if get(hObject, 'Value') == 1 % Si se selecciona KNN
        algoritmoSeleccionado = 1; % Asignar 1 para KNN
        habilitarPanelUsuario(handles, true); % Habilitar el panel de usuario
        set(handles.iniciarButton, 'Enable', 'off'); % Desactiva el botón "Iniciar"
        
        % Llamar a la función para restablecer datosUsuario para el nuevo algoritmo
        restablecerDatosUsuarioParaNuevoAlgoritmo();
        disp('Algoritmo KNN seleccionado. Se requiere seleccionar un usuario para activar Iniciar.');
    else
        habilitarPanelUsuario(handles, false); % Deshabilitar panel de usuario
    end


function radiobutton28_Callback(hObject, eventdata, handles)
    global algoritmoSeleccionado flags datosUsuario;
    
    % Verifica si los datos de usuario no están cargados
    if ~isfield(datosUsuario, 'usuarioValidoFlag') || datosUsuario.usuarioValidoFlag == 0
        nombreUsuario = 'Mishel';  % Nombre de usuario predeterminado
        disp(['Cargando usuario predeterminado: ' nombreUsuario]);
        try
            archivo = load(['.\usersData\' nombreUsuario]);  % Ruta al archivo del usuario
            datosUsuario = archivo.datosUsuario;  % Cargar los datos
            datosUsuario.usuarioValidoFlag = 1;  % Marcar como usuario válido
            disp('Usuario predeterminado cargado correctamente.');
        catch
            disp('Error al cargar el usuario predeterminado.');
            return;  % Salir si no se puede cargar el usuario
        end
    end

    if flags.reconocimientoActivo
        set(hObject, 'Value', 0); % Desactivar el botón si hay reconocimiento activo
        set(handles.radiobutton27, 'Value', 1); % Mantener KNN seleccionado
        set(handles.mensajesTextBox, 'String', 'Finalice el reconocimiento actual antes de cambiar a CNN.');
        beep;
        return;
    end

    if get(hObject, 'Value') == 1 % Selecciona CNN
        algoritmoSeleccionado = 2; % Asignar CNN como algoritmo seleccionado
        habilitarPanelUsuario(handles, false); % Deshabilitar panel de usuario
        set(handles.iniciarButton, 'Enable', 'on'); % Habilitar botón "Iniciar"
        set(handles.iniciarButton, 'String', 'Iniciar'); % Restaurar texto a "Iniciar"
        disp('Algoritmo CNN seleccionado.');
    else
        set(handles.iniciarButton, 'Enable', 'off'); % Deshabilitar botón "Iniciar"
    end




%% Habilitar Panel de Algoritmos
function habilitarPanelAlgoritmos(handles, habilitar)
    if habilitar
        set(handles.radiobutton27, 'Enable', 'on'); % Activa el Radio Button de KNN
        set(handles.radiobutton28, 'Enable', 'on'); % Activa el Radio Button de CNN
        disp('Panel de algoritmos habilitado.');
    else
        set(handles.radiobutton27, 'Enable', 'off'); % Desactiva el Radio Button de KNN
        set(handles.radiobutton28, 'Enable', 'off'); % Desactiva el Radio Button de CNN
        disp('Panel de algoritmos deshabilitado.');
    end

function habilitarPanelUsuario(handles, habilitar)
    if habilitar
        set(handles.usuarioButton, 'Enable', 'on'); % Habilita el panel de usuario
        set(handles.verUsuarioButton, 'Enable', 'on'); % Habilita el panel de usuario
        disp('Panel de usuario habilitado.');
    else
        set(handles.usuarioButton, 'Enable', 'off'); % Habilita el panel de usuario
        set(handles.verUsuarioButton, 'Enable', 'off'); % Habilita el panel de usuario
        disp('Panel de usuario deshabilitado.');
    end


% Solo restablecer campos específicos dentro de la estructura de datosUsuario
% Funcion esta dando errores por o}lo que no se la utiliza
function restablecerDatosUsuarioParaNuevoAlgoritmo()
    global datosUsuario;
    
    % Limpiar solo los campos específicos que deben restablecerse para un nuevo algoritmo
    % Por ejemplo, si 'gestoRespuesta' y otros campos son específicos del algoritmo
    datosUsuario.gestoRespuesta = [];  % Limpiar el gestoRespuesta de cualquier valor previo
    datosUsuario.tiempoClasificacionVector = []; % Limpiar el tiempoClasificacionVector si es necesario
    datosUsuario.tiempoOcioVector = []; % Limpiar el tiempoOcioVector si es necesario
    datosUsuario.tiempoLoopTotalVector = []; % Limpiar el tiempoLoopTotalVector si es necesario
    datosUsuario.gestoRespuestaVector = []; % Limpiar el gestoRespuestaVector si es necesario
    
    % No eliminar los datos de usuario, solo los campos que deben reiniciarse
