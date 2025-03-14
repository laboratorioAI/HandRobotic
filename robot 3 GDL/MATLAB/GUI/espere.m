function varargout = espere(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @espere_OpeningFcn, ...
                   'gui_OutputFcn',  @espere_OutputFcn, ...
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


% --- Executes just before espere is made visible.
function espere_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

global mensajeEspere
movegui(hObject,'north')
set(handles.mensajeText,'String',mensajeEspere)
drawnow 


function varargout = espere_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
