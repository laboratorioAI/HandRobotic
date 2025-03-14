% SWITCH PANEL!
function switchControlRobot(handles)
global EV3 flags datosUsuario

%% ROBOT
if get(handles.robotRadio,'Value')
    flags.moverIMULego = 1 ;
    set(handles.mostrarResultadosButton,'Enable','on')
    
elseif  get(handles.pausaRadio,'Value')
    %% PAUSA
    
    flags.moverIMULego = 0 ;
    
    
    %% roll, pitch, yaw...
elseif get(handles.yawRadio,'Value') || get(handles.pitchRadio,'Value') || get(handles.rollRadio,'Value')
    flags.moverIMULego = 0 ; % por si acaso...
    
    % pregunta por ángulo mover!
    anguloMover=inputdlg({'Angulo a mover grado de libertad seleccionado.'},'Angulo de prueba',1,{'30'});
    anguloMover=str2double(char(anguloMover));
    
    % es válido?
    if ~isempty((anguloMover)) && abs(anguloMover)<91 % que sea un ángulo que tenga sentido
        % parar cualquier cosa en lego!
        angulos=datosUsuario.angulos;
        flagMovimientoRobot=0; %??
        
        
        EV3.writeMailBox('angulos','numeric',angulos)
        
        EV3.writeMailBox('movimiento','text','parar')
        flags.movimientoRobot=flagMovimientoRobot; %?
        
        %% envia el que sí es!
        EV3.writeMailBox('modos','text','moverGradoQ')
        
        if get(handles.yawRadio,'Value')
            EV3.writeMailBox('gradoQ','text','yaw')
            
        elseif get(handles.pitchRadio,'Value')
            EV3.writeMailBox('gradoQ','text','pitch')
        else
            EV3.writeMailBox('gradoQ','text','roll')
        end
        
        EV3.writeMailBox('anguloQ','numeric',anguloMover)
        
        set(handles.mostrarResultadosButton,'Enable','on')
    else
        % si es que muere... tncs
        errordlg('Ingrese un angulo valido!', 'ANGULO INCORRECTO', 'modal');
        set(handles.pausaRadio,'Value',1)
        
        set(handles.mostrarResultadosButton,'Enable','off')
    end
    
else
    disp('problemas con el switch del panel del control robot de ese switchControl')
end

end

