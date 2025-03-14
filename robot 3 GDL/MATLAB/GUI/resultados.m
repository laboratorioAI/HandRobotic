function varargout = resultados(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @resultados_OpeningFcn, ...
    'gui_OutputFcn',  @resultados_OutputFcn, ...
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


% --- Executes just before resultados is made visible.
function resultados_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


movegui(hObject,'center') % centrando ventana

a = pwd;

axes(handles.tiemposAxes)
tiemposPlot


try
    robotPlot(handles)
    
catch
    cd(a)
    set(handles.mensajesTextbox,'String','Problemas mostrando diagrama del movimiento del robot')
end

try
    global hEspere
    close(hEspere);
catch
end

% --- Outputs from this function are returned to the command line.
function varargout = resultados_OutputFcn(~, ~, handles)

varargout{1} = handles.output;


% --- Executes on button press in OKButton.
function OKButton_Callback(~, ~, ~)
close(gcf)
