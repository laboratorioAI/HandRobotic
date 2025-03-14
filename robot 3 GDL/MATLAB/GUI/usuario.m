function varargout = usuario(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @usuario_OpeningFcn, ...
    'gui_OutputFcn',  @usuario_OutputFcn, ...
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






% --- Executes just before usuario is made visible.
function usuario_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for usuario
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%% Moviendo y apareciendo figura
global datosUsuario

movegui(hObject,'center')
drawnow
figure(hObject)
datosUsuario.usuarioValidoFlag=0; % bandera de usuario válido, 1 es válido, 0 no





% --- Outputs from this function are returned to the command line.
function varargout = usuario_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







% --- Executes on button press in aceptarButton.
function aceptarButton_Callback(hObject, eventdata, handles)
% leyendo selección
seleccionUsuario = get(get(handles.buttonGroup,'SelectedObject'),'Tag');

% variable conteniendo datos del usuario
global datosUsuario

switch seleccionUsuario
    
    case 'nuevoUsuario'
        
        % enviar a entrenamiento directamente
        entrenamientoGUI=entrenamiento;
        uiwait(entrenamientoGUI);
        
        if datosUsuario.entrenamientoValidoFlag==1 % si usuario es válido
            datosUsuario.usuarioValidoFlag=1; % usuario es válido
            datosUsuario=rmfield(datosUsuario,'entrenamientoValidoFlag'); % remuevo campos
            datosUsuario=rmfield(datosUsuario,'numRepeticionesEntrenadas'); % remuevo campos
            datosUsuario=rmfield(datosUsuario,'numGestosEntrenados'); % remuevo campos
        end
        
        close(gcf)
        
    case 'existenteUsuario'
        % mensaje para ingresar nombre de usuario
        nameUser=inputdlg({'Nombre de usuario'},'Usuario',1,{'jonaZ'});
        
        % detectando información vónida
        if ~isempty(nameUser)
            
            try
                % detectar usuario vónido. Se detecta a travón de abrir archivo
                % dataBase
                emgVector=datosUsuario.emgVector;
                orientacion = datosUsuario.orientacion ;
                archivo = load(['.\usersData\' char(nameUser) ])  ;
                datosUsuario = archivo.datosUsuario;
                drawnow
                datosUsuario.emgVector=emgVector;
                datosUsuario.orientacion  = orientacion ;
                disp('Usuario encontrado')
                hObject.UserData.usuarioFlag=1;
                hObject.UserData.nameUser=char(nameUser);
                beep
                datosUsuario.nombreUsuario=nameUser;
                datosUsuario.usuarioValidoFlag=1; % usuario es válido                
                
                close(gcf)
                
            catch
                uiwait(msgbox('Ingrese un nombre de usuario valido.','Mensaje','modal'));
            end
            
        end
        
    otherwise
        disp('Problema')
        
end



% --- Executes on button press in nuevoUsuario.
function nuevoUsuario_Callback(hObject, eventdata, handles)
% hObject    handle to nuevoUsuario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of nuevoUsuario




% --- Executes on button press in existenteUsuario.
function existenteUsuario_Callback(hObject, eventdata, handles)
% hObject    handle to existenteUsuario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of existenteUsuario




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);

