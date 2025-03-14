%% Inicio de la conexión Myo GUI
function inicializacionMyo(handles)
global isConnectedMyo isConnectedLego 


isConnectedMyo=0;
initMyo

drawnow % espera que se sincronice el myo

if isConnectedMyo==1
    axes(handles.ledMyoAxes);
    handles.ledMyo=scatter(0,0,30,'g','filled');
    axis off;
    set(handles.conectarMyoButton,'Enable','off')
    set(handles.mensajesTextBox,'String','MYO CONECTADO!')
    set(handles.usuarioButton,'Enable','on')

    
    % iniciar a dibujar!
    inicioGraF(handles)
        
    
    if isConnectedLego==1
        set(handles.yawRadio,'Enable','on')
        set(handles.pitchRadio,'Enable','on')
        set(handles.rollRadio,'Enable','on')
        set(handles.pausaRadio,'Enable','on')
        

    end
else   
    
    axes(handles.ledMyoAxes);
    handles.ledMyo=scatter(0,0,30,'r','filled');
    axis off;
    set(handles.mensajesTextBox,'String',{'WARNING! MYO NO CONECTADO, INTENTE DE NUEVO O REINICIE MYO CONNECT'})
    load splat
    sound(y,Fs)
end
end
