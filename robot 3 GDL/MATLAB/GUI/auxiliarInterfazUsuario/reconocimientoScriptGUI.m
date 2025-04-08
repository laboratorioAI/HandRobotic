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
global emg flags myoObject datosUsuario reconocimientoConfiguracion isConnectedMyo algoritmoSeleccionado

%%
% Lazo principal para ejecuciones múltiples
while ~flags.detener % mientras no se dé la orden de "detener" el sistema continúa
    
    %% Esperando inicio del reconocimiento
    while ~flags.reconocer && ~flags.reconocerCNN && ~flags.detener  % O bien se da orden de "detener" o "reconocer", si no, continúa esperando
        if isConnectedMyo
            % Aquí dibujamos la GUI mientras esperamos el inicio del reconocimiento
            [datosUsuario] = dibujarGUI(handles, datosUsuario, myoObject, reconocimientoConfiguracion, emg);
        end
        pause(0.05); % Pausa para evitar que el loop consuma demasiados recursos
        drawnow % Actualiza la interfaz gráfica
    end
    
    %% Ejecutando el algoritmo seleccionado (KNN o CNN)
    if algoritmoSeleccionado == 1 && flags.reconocer 
        disp("Entrando a preparativos del algoritmo KNN...");
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
            disp('¿Qué pasó con el timer? Ahora sí debería funcionar!!')
        end
        beep
        
        
        %% limitando vectores
        flags.kEjecucionesLoop = kEjecucionesLoop;
        
        datosUsuario.tiempoClasificacionVector = tiempoClasificacionVector(1:kEjecucionesLoop - 1); % kEjecucionesLoop viene de "reconocimiento"
        datosUsuario.tiempoOcioVector = tiempoOcioVector(1:kEjecucionesLoop - 1);
        datosUsuario.tiempoLoopTotalVector = tiempoLoopTotalVector(1:kEjecucionesLoop - 1);
        datosUsuario.gestoRespuestaVector = gestoRespuestaVector(1:kEjecucionesLoop);
    end

    
    %% Ejecutando el algoritmo seleccionado (KNN o CNN)
    if algoritmoSeleccionado == 2 && flags.reconocerCNN
       disp("Entrando a preparativos del algoritmo CNN...");
        drawnow
        preparativosCNN
        
        %% mega lazo de reconocimiento
        while kEjecucionesLoop < numEjecucionesTimer && flags.reconocerCNN && ~flags.detener
            % se ejecuta hasta que las ejecuciones del timer se sobrepasen o se
            % anule la bandera de reconocimiento
            drawnow
            ejecutarCNNTiempoReal(handles, reconocimientoConfiguracion);
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
            disp('¿Qué pasó con el timer? Ahora sí debería funcionar!!')
        end
        beep
        
        
        %% limitando vectores
        flags.kEjecucionesLoop = kEjecucionesLoop;
        
        datosUsuario.tiempoClasificacionVector = tiempoClasificacionVector(1:kEjecucionesLoop - 1); % kEjecucionesLoop viene de "reconocimiento"
        datosUsuario.tiempoOcioVector = tiempoOcioVector(1:kEjecucionesLoop - 1);
        datosUsuario.tiempoLoopTotalVector = tiempoLoopTotalVector(1:kEjecucionesLoop - 1);
        datosUsuario.gestoRespuestaVector = gestoRespuestaVector(1:kEjecucionesLoop);
    end
    
end
