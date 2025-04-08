function dibujarGUI_CNN(handles, gestoReconocido, reconocimientoConfiguracion)
    global axesGesto YPRang flags datosUsuario myoObject

    flags.isRobotMoving = false;
    flags.moverIMULego = true;
    
    disp(['Valor de flags.moverIMULego antes del loop: ', mat2str(flags.moverIMULego)]);  % Depuración
    flags.kdiscernirGesto2Robot = 0;

    disp(['Valor de flags.dibujarEMGCNN: ', num2str(flags.dibujarEMGCNN)]);  % Depuración
    disp(['Valor de flags.reconocerCNN: ', num2str(flags.reconocerCNN)]);  % Depuración

    disp('Reconociendo gesto...');
    
    if ischar(gestoReconocido) | isstring(gestoReconocido)
        gestoReconocido = find(strcmp(gestoReconocido, reconocimientoConfiguracion.nameGestures));
    end

    if isnumeric(gestoReconocido) & (gestoReconocido > 0) & (gestoReconocido <= length(reconocimientoConfiguracion.nameGestures))
        nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{gestoReconocido};

        disp(['Nombre del gesto: ', nombreGestoRespuesta]);

        try
            imagenGesto = reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);

            if isempty(imagenGesto)
                error('La imagen para el gesto no está definida correctamente.');
            else
                if size(imagenGesto, 3) == 1
                    imagenGesto = repmat(imagenGesto, [1, 1, 3]);
                end

                set(handles.tituloGestoText, 'String', nombreGestoRespuesta);
                axesGesto.CData = imagenGesto;
            end
        catch ME
            disp(['Error al cargar la imagen: ', ME.message]);
            axesGesto.CData = zeros(size(axesGesto.CData));
            set(handles.tituloGestoText, 'String', 'Error al cargar imagen');
        end
        
        % SOLUCION USANDO FLAGS
        % flags.gestoRespuesta = gestoReconocido;  % Aquí se asegura que flags.gestoRespuesta tenga el valor correcto
        % disp(['Valor de flags.gestoRespuesta asignado: ', num2str(flags.gestoRespuesta)]);

        % Asignamos el gesto reconocido directamente a datosUsuario.gestoRespuesta
        datosUsuario.gestoRespuesta = gestoReconocido;  % Aquí es donde asignamos el gesto reconocido
        disp(['Valor de datosUsuario.gestoRespuesta asignado DIBUJAR: ', num2str(datosUsuario.gestoRespuesta)]);

        flags.gestoDibujado = true;
    else
        set(handles.tituloGestoText, 'String', 'Reconociendo...');
        axesGesto.CData = zeros(size(axesGesto.CData)); 
    end

    % SOLUCION USANDO FLAGS
    % Asignamos el valor de flags.gestoRespuesta a una variable 'gestoRespuesta'
    % gestoRespuesta = flags.gestoRespuesta;
    % disp(['Valor de gestoRespuesta asignado desde flags.gestoRespuesta: ', num2str(gestoRespuesta)]);

    % Ahora, asignamos 'gestoRespuesta' a 'datosUsuario.gestoRespuesta'
    % datosUsuario.gestoRespuesta = gestoRespuesta;
    % disp(['Valor de datosUsuario.gestoRespuesta: ', num2str(datosUsuario.gestoRespuesta)]);

    % Ahora asignamos directamente el valor de datosUsuario.gestoRespuesta a gestoRespuesta
    gestoRespuesta = datosUsuario.gestoRespuesta;  % Se asigna el valor directamente de datosUsuario
    disp(['Valor de gestoRespuesta asignado desde datosUsuario.gestoRespuesta: ', num2str(gestoRespuesta)]);

    %% EMG
    if ~flags.reconocerCNN
        emgPlot = myoObject.myoData.emg_log;
        myoObject.myoData.clearLogs();
    else
        emgPlot = datosUsuario.emgVector;
    end

    samplesLoop = size(emgPlot, 1);
    if samplesLoop == 0
        samplesLoop = 40;
        emgPlot = zeros(40, 8);
    elseif samplesLoop > 200 * 0.2
        samplesLoop = 40;
    end

    datosUsuario.emgVector = circshift(datosUsuario.emgVector, -samplesLoop);
    datosUsuario.emgVector(end - samplesLoop + 1:end, :) = emgPlot(end - samplesLoop + 1:end, :);

    emgVector = datosUsuario.emgVector;

    %% matriz de rotación
    R = myoObject.myoData.rot;
    %disp("Matriz de Rotacion");
    %disp(R);
    matrizRotacion = R .* ([1 1 -1; 1 1 -1; -1 -1 1]);
    %disp(matrizRotacion);
    
    %% dibujar la orientación y los datos EMG
    actualizarOrientacionGrafico(matrizRotacion, emgVector)

    % Proceso del robot (si está en movimiento)
    if flags.isRobotMoving
        YPR = YPRang;
        handles.yawText.String = num2str(YPR(1));   
        handles.pitchText.String = num2str(-YPR(2)); 
        handles.rollText.String = num2str(YPR(3));  
    else
        handles.yawText.String = '';
        handles.pitchText.String = '';
        handles.rollText.String = '';
    end



    %% ROBOT
    if flags.moverIMULego
        gestos2MandoRobot(handles)
    end
end
