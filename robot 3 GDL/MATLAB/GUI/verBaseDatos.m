function varargout = verBaseDatos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @verBaseDatos_OpeningFcn, ...
    'gui_OutputFcn',  @verBaseDatos_OutputFcn, ...
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




function verBaseDatos_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

axis(handles.axesLeyenda,'off')

global datosUsuario
set(handles.nombreText,'String',{'Bienvenido',char(datosUsuario.nombreUsuario)})





function varargout = verBaseDatos_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;




% --- Executes on button press in WaveInRadio.
function WaveInRadio_Callback(hObject, eventdata, handles)
dibujar(handles)

function WaveOutRadio_Callback(hObject, eventdata, handles)
dibujar(handles)

function FistRadio_Callback(hObject, eventdata, handles)
dibujar(handles)

function OpenRadio_Callback(hObject, eventdata, handles)
dibujar(handles)

function PinchRadio_Callback(hObject, eventdata, handles)
dibujar(handles)

function noGestoRadio_Callback(hObject, eventdata, handles)
dibujar(handles)



function rep1_Callback(hObject, eventdata, handles)
dibujar(handles)

function rep2_Callback(hObject, eventdata, handles)
dibujar(handles)

function rep3_Callback(hObject, eventdata, handles)
dibujar(handles)

function rep4_Callback(hObject, eventdata, handles)
dibujar(handles)


function rep5_Callback(hObject, eventdata, handles)
dibujar(handles)



function dibujar(handles)
global datosUsuario
global repVector


%% leyendo gesto seleccionado
gestos={'WaveIn','WaveOut','Fist','Open','Pinch','noGesto'};
for kGesto=1:6
    
    estadoRadio=get(handles.([gestos{kGesto} 'Radio']),'Value');
    if estadoRadio==1
        gestoSeleccionado=gestos{kGesto};
        numGesto=kGesto;
        break
    end
    
end

%% leyendo rep seleccionadas
repVector=[];

for kRep=1:5
    estadoRadioRep=get(handles.(['rep' num2str(kRep)]),'Value');
    
    if estadoRadioRep==1
        
        repVector=[repVector kRep];
    end
    
    
end


%% dibujando
colorVector={'b','r','g','m','k'};

cla(handles.axesLeyenda)
hold(handles.axesLeyenda,'on')

for kRadioRep=1:size(repVector,2)
    
    
    kRep=repVector(kRadioRep);
    
    color=colorVector{kRep};
    
    emgVector=datosUsuario.gestos.(gestoSeleccionado).emg{kRep};
    
    kPosicion=5*(numGesto-1)+kRep;
    
    for kCanal=1:8
        %% raw!
        nombreAxes=['axes' num2str(kCanal)];
        if kRadioRep==1
            cla(handles.(nombreAxes))
        end
        plot(handles.(nombreAxes),emgVector(:,kCanal),color);
        hold(handles.(nombreAxes),'on')
        ylim(handles.(nombreAxes),[-1 1]);
        xlim(handles.(nombreAxes),[0 400]);
        
        if kCanal==4 || kCanal==5
            handles.(nombreAxes).XTick = [0 175 375];
            handles.(nombreAxes).XTickLabel = {'0' '1seg' '2seg'};
        else
            handles.(nombreAxes).XTick = [];
        end
        
        %% filtrada!
        nombreAxesPro=['axes' num2str(kCanal+8)];
        if kRadioRep==1
            cla(handles.(nombreAxesPro))
        end
        plot(handles.(nombreAxesPro),datosUsuario.database{kPosicion,kCanal},color);
        hold(handles.(nombreAxesPro),'on')
        ylim(handles.(nombreAxesPro),[0 1]);
        xlim(handles.(nombreAxesPro),[0 400]);
        if kCanal==4 || kCanal==5
            handles.(nombreAxesPro).XTick = [0 175 375];
            handles.(nombreAxesPro).XTickLabel = {'0' '1seg' '2seg'};
        else
            handles.(nombreAxesPro).XTick = [];
        end
    end
    
    %%
    plot(handles.axesLeyenda,0,0,color)
    
    
end
leyendas={'REPETICION 1','REPETICION 2','REPETICION 3','REPETICION 4','REPETICION 5'};
legend(handles.axesLeyenda,leyendas{repVector})

