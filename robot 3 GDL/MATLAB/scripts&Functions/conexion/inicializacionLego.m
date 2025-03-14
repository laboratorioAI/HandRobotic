%% Conexion con Lego
function inicializacionLego(handles)
global isConnectedLego isLegoProgramRunning isConnectedMyo flags
isConnectedLego = initLego(handles);
drawnow
if isConnectedLego == 1
    % axes(handles.ledLegoAxes);
    handles.ledLego = scatter(handles.ledLegoAxes,0,0,30,'g','filled');
    axis(handles.ledLegoAxes,'off');
    
    set(handles.conectarLegoButton,'Enable','off')
    
    set(handles.mensajesTextBox,'String', 'LEGO CONECTADO' )
    
    scatter(handles.pinzaAxes,0,0,30,'r','filled');
    axis(handles.pinzaAxes,'off');
    
    handles.pinzaText.String = 'Estado cerrado';
    
    if isConnectedMyo == 1
        set(handles.yawRadio,'Enable','on')
        set(handles.pitchRadio,'Enable','on')
        set(handles.rollRadio,'Enable','on')
        set(handles.pausaRadio,'Enable','on')
        
        flags.moverIMULego = true ;
        
    end
else
    
    if isLegoProgramRunning
        set(handles.mensajesTextBox,'String',{'WARNING!','LEGO NO CONECTADO, REVISE CONEXIÓN BLUETOOTH'})
    else
        set(handles.mensajesTextBox,'String',{'WARNING!', 'EJECUTE PROGRAMA EN EV3'})
    end
    
    %     axes();
    scatter(handles.ledLegoAxes,0,0,30,'r','filled');
    axis(handles.ledLegoAxes,'off');
    
    load splat
    sound(y,Fs)
end

end

