% gestión inicial del GUI 
movegui(hObject,'center') % centrando ventana

%% leds
axes(handles.ledMyoAxes); % Myo
handles.ledMyo=scatter(0,0,30,'r','filled');
axis off;

axes(handles.ledLegoAxes); % lego
handles.ledLego=scatter(0,0,30,'r','filled');
axis off;

%% Borrar todo de los ejes
axes(handles.mainAxes);
axis off;
axes(handles.orientacionAxes);
axis off;


%% deshabilitando
set(handles.mostrarResultadosButton,'Enable','off')

set(handles.usuarioButton,'Enable','off')
set(handles.verUsuarioButton,'Enable','off')

set(handles.iniciarButton,'Enable','off')

set(handles.yawRadio,'Enable','off')
set(handles.pitchRadio,'Enable','off')
set(handles.rollRadio,'Enable','off')
set(handles.robotRadio,'Enable','off')
set(handles.pausaRadio,'Enable','off')

set(handles.mensajesTextBox,'String','TERMINADOS LOS PREPARATIVOS')




