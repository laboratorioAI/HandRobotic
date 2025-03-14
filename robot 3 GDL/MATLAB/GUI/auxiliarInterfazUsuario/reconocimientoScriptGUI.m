% script reconocimiento GUI
% script que contiene el código de reconocimiento. Los datos del sistema de
% reconocimiento por defecto son encontrados en la variable global
% reconocimientoConfiguracion. Los datos del usuario son encontrados en
% datosUsuario. Estas dos estructuras contienen los parámetros necesarios.

% El script contiene dos lazos. El primero termina completamente el
% programa, además se usa para esperar. El segundo es únicamente para
% habilitar, deshabilitar el reconocimiento.

% Se inserta la función dibujarGUI. Esta función se ejecuta en los lazos de
% espera.


%% SCRIPT
global emg flags myoObject datosUsuario reconocimientoConfiguracion isConnectedMyo

%%
% Lazo principal para ejecuciones múltiples
while ~flags.detener % mientras no se dé la orden de "detener" el sistema continúa
    
    
    %% Esperarando inicio del reconocimiento
    while ~flags.reconocer && ~flags.detener % o bien se da orden de "detener" o "reconocer" si no, continúa esperando
        if isConnectedMyo
            [datosUsuario]=dibujarGUI(handles,datosUsuario,myoObject ,reconocimientoConfiguracion ,emg);
        end
        pause(0.05);
        drawnow
    end
    
    if flags.reconocer
        drawnow
        preparativosReconocimiento
        
        %% mega lazo de reconocimiento
        while kEjecucionesLoop < numEjecucionesTimer && flags.reconocer && ~flags.detener
            % se ejecuta hasta que las ejecuciones del timer se sobrepasen o se
            % anule la bandera de reconocimiento
            drawnow
            reconocimiento
        end
        
        disp('Fin en reconocimientoScirptGUI')
        %% Salida
        
        %% detener timer
        try
            stop(timerReconocimiento) % (este timer viene de "reconocimiento")
            delete(timerReconocimiento)
            
            stop(timerEnvio) % (este timer viene de "reconocimiento")
            delete(timerEnvio)
        catch
            disp('qué pasó con el timer, ahora sí debería funcionar!!')
        end
        beep
        
        
        %% limitando vectores
        flags.kEjecucionesLoop = kEjecucionesLoop;
        
        datosUsuario.tiempoClasificacionVector = tiempoClasificacionVector(1:kEjecucionesLoop - 1); % kEjecucionesLoop viene de "reconcimiento"
        datosUsuario.tiempoOcioVector = tiempoOcioVector(1:kEjecucionesLoop - 1);
        datosUsuario.tiempoLoopTotalVector = tiempoLoopTotalVector(1:kEjecucionesLoop - 1);
        datosUsuario.gestoRespuestaVector = gestoRespuestaVector(1:kEjecucionesLoop);
    end
    
    
end

