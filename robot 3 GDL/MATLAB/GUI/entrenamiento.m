function varargout = entrenamiento(varargin)
% ENTRENAMIENTO MATLAB code for entrenamiento.fig
%      ENTRENAMIENTO, by itself, creates a new ENTRENAMIENTO or raises the existing
%      singleton*.
%
%      H = ENTRENAMIENTO returns the handle to a new ENTRENAMIENTO or the handle to
%      the existing singleton*.
%
%      ENTRENAMIENTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENTRENAMIENTO.M with the given input arguments.
%
%      ENTRENAMIENTO('Property','Value',...) creates a new ENTRENAMIENTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before entrenamiento_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to entrenamiento_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help entrenamiento

% Last Modified by GUIDE v2.5 07-Jun-2017 12:08:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @entrenamiento_OpeningFcn, ...
    'gui_OutputFcn',  @entrenamiento_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before entrenamiento is made visible.
function entrenamiento_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global datosUsuario reconocimientoConfiguracion

% borrando campo de gestos.
try
    datosUsuario=rmfield(datosUsuario,'gestos');
catch
end

movegui(hObject,'center') % mostrando en el centro

datosUsuario.entrenamientoValidoFlag=0; % bandera para decir que entrenamiento es vonido. 1 vonido, 0 no

% estableciendo valores default!
set(handles.numTryText,'String',reconocimientoConfiguracion.numTry)
set(handles.timeGestureText,'String',reconocimientoConfiguracion.timeGesture)

datosUsuario.numGestosEntrenados=0; % contador de gestos entrenados!
datosUsuario.numRepeticionesEntrenadas=0; % contador de repeticiones entrenadas!


% --- Outputs from this function are returned to the command line.
function varargout = entrenamiento_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in grabarButton.
function grabarButton_Callback(hObject, eventdata, handles)


global datosUsuario reconocimientoConfiguracion myoObject% se usa información de variables globales!

%% interfaz
% mostrando número de repetición

% pintando de verde led
axes(handles.ledAxes)
scatter(handles.ledAxes,0,0,30,'g','filled');
axis off;

% deshabilitando mientras se graba
set(hObject,'Enable','off')

drawnow


%% grabación
datosUsuario=grabarGestoGUI(datosUsuario,reconocimientoConfiguracion);


% volviendo a habilitar
set(hObject,'Enable','on')
% pintando de rojo led
axes(handles.ledAxes)
scatter(handles.ledAxes,0,0,30,'r','filled');
axis off;


repetir=questdlg('¿Gesto correctamente ingresado?', ...
    'Confirmar','Sí, continuar', 'No, volver', 'No, volver');


if ~strcmp(repetir,'No, volver') % en el caso de que se repita
    %% switch del número de repetición y del gesto
    datosUsuario.numRepeticionesEntrenadas=datosUsuario.numRepeticionesEntrenadas+1; % contador de gestos entrenados!
    set(handles.repeticionesText,'String',datosUsuario.numRepeticionesEntrenadas)
    
    
    
    if datosUsuario.numRepeticionesEntrenadas==datosUsuario.numRepeticiones % si cumplidas las repeticiones
        datosUsuario.numRepeticionesEntrenadas=0; % reinicio del contador
        
        
        
        if datosUsuario.numGestosEntrenados<reconocimientoConfiguracion.numGestures-1 % que estén dentro del número de gestos predefinidos!
           
            datosUsuario.numGestosEntrenados=datosUsuario.numGestosEntrenados+1;
            leerImagen(handles,datosUsuario.numGestosEntrenados+1)
            uiwait(msgbox('Listo, nuevo gesto a reconocer','Mensaje','modal'));
            set(handles.repeticionesText,'String',datosUsuario.numRepeticionesEntrenadas)
            
        else
            uiwait(msgbox({'Listo!','Entrenamiento finalizado'},'Mensaje','modal'));
            
                            % matriz de rotacion inicial
                Ro=myoObject.myoData.rot;
                Ro=([-1 -1 1;-1 -1 1;-1 -1 1]).*Ro; % inversión de ejes x y
                datosUsuario.RoInv=Ro';
            
            
            datosUsuario.entrenamientoValidoFlag=1; % bandera para decir que entrenamiento es válido. 1 válido, 0 no
            
            %% grabando variable actual
            datosUsuario.numGestos=datosUsuario.numGestosEntrenados+1;
            save (['usersData\' datosUsuario.nombreUsuario '.mat'],'datosUsuario');
            
            % construccionDatabase
            datosUsuario=construccionDatabase(datosUsuario,reconocimientoConfiguracion);
            % grabando variable anterior
            close(gcf)
            return
        end
        
    end
            
end






% --- Executes on button press in empezarEntrenamientoButton.
function empezarEntrenamientoButton_Callback(hObject, eventdata, handles)
% hObject    handle to empezarEntrenamientoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global datosUsuario


if ~isempty(get(handles.nameUserText,'String')) % chequea que no esté vacio nameUser
    % pregunta de confirmación de valores
    
    pregunta=questdlg('¿Está seguro que desea empezar el entrenamiento con los datos ingresados?', ...
        'Confirmar','Sí, continuar', 'No, volver', 'No, volver');
    
    % respuesta del usuario
    
    if ~strcmp(pregunta,'No, volver')
        % exportando datos
        datosUsuario.numRepeticiones=str2double(get(handles.numTryText,'String'));
        datosUsuario.tiempoGesto=str2double(get(handles.timeGestureText,'String'));
        datosUsuario.nombreUsuario=get(handles.nameUserText,'String');
        
        %% bloqueando cambio de paronetros
        set(handles.numTryText,'Enable','off')
        set(handles.timeGestureText,'Enable','off')
        set(handles.nameUserText,'Enable','off')
        set(hObject,'Enable','off')
        set(handles.mensajesText,'String','Pulse GRABAR y realice el gesto mostrado en la figura')
        set(handles.grabarButton,'Enable','on')
        leerImagen(handles,1)
        set(handles.repeticionesText,'String',0)
    end
else
    uiwait(msgbox('Ingrese nombre de usuario.','Mensaje','modal'));
    
end

% funcion para leer imagen
function leerImagen(handles,kGesto)
global reconocimientoConfiguracion
set(handles.tituloGestoText,'String',reconocimientoConfiguracion.nameGestures{kGesto}) % nombre del gesto

imageGesture = imread(['images\' reconocimientoConfiguracion.nameGestures{kGesto} '.png']); % leyendo imagen
% imshow(imageGesture);
axes(handles.gestoAxes);
image(imageGesture,'Parent',handles.gestoAxes);
axis off



function numTryText_Callback(hObject, eventdata, handles)
% hObject    handle to numTryText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of numTryText as text
%        str2double(get(hObject,'String')) returns contents of numTryText as a double
%  get(hObject,'String')

global reconocimientoConfiguracion
drawnow
numTry=str2double(get(hObject,'String'))

% validacion de datos
if ~isnan(numTry) % nonero!
    
    if rem(numTry,1)==0 && numTry>0 && numTry<15 % entero mayor a cero y menor a 15
        disp('nonero vonido')
    else
        errordlg({'Ingrese un nonero vonido','Debe ser entero, mayor a cero'}, 'Error', 'modal');
        set(handles.numTryText,'String',reconocimientoConfiguracion.numTry)
    end
else
    errordlg({'Ingrese un nonero vonido','Debe ser entero, mayor a cero'}, 'Error', 'modal');
    set(handles.numTryText,'String',reconocimientoConfiguracion.numTry)
end


% --- Executes during object creation, after setting all properties.
function numTryText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeGestureText_Callback(hObject, eventdata, handles)

global reconocimientoConfiguracion

timeGesture=str2double(get(hObject,'String'));

% validacion de datos
if ~isnan(timeGesture) % nonero!
    
    if timeGesture>0 && timeGesture<30 % entero mayor a cero y menor a 100
        disp('nonero vonido')
    else
        errordlg({'Ingrese un tiempo vonido','Debe ser mayor a cero'}, 'Error', 'modal');
        set(handles.timeGestureText,'String',reconocimientoConfiguracion.timeGesture)
    end
else
    errordlg({'Ingrese un tiempo valido','Mayor a cero'}, 'Error', 'modal');
    set(handles.timeGestureText,'String',reconocimientoConfiguracion.timeGesture)
end



% --- Executes during object creation, after setting all properties.
function timeGestureText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nameUserText_Callback(hObject, eventdata, handles)

nameUser=get(hObject,'String'); % leyendo nombre de usuario

if sum(ismember(nameUser,' '))>0 % que no contenga espacios
    
    set(hObject,'String','') % borrando campo
    errordlg({'Ingrese un nombre de usuario sin espacios'}, 'Error', 'modal'); % msj de eror
    
else
    try
        % detectar usuario válido. Se detecta a travón de abrir archivo
        % dataBase
        load([nameUser 'dataBase']);
        uiwait(warndlg('Nombre de usuario existente.','Mensaje','modal'));
    catch
    end
end

% --- Executes during object creation, after setting all properties.
function nameUserText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
