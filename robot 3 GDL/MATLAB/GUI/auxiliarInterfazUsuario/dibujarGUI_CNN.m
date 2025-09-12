function dibujarGUI_CNN(handles, gestoReconocido, reconocimientoConfiguracion)
    global axesGesto YPRang flags datosUsuario myoObject

    flags.isRobotMoving = false;
    flags.moverIMULego = true;
        flags.kdiscernirGesto2Robot = 0;

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

        % Asignamos el gesto reconocido directamente a datosUsuario.gestoRespuesta
        datosUsuario.gestoRespuesta = gestoReconocido;  % Aquí es donde asignamos el gesto reconocido
        disp(['Valor de datosUsuario.gestoRespuesta asignado DIBUJAR: ', num2str(datosUsuario.gestoRespuesta)]);

        flags.gestoDibujado = true;
    else
        set(handles.tituloGestoText, 'String', 'Reconociendo...');
        axesGesto.CData = zeros(size(axesGesto.CData)); 
    end

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
    % R = myoObject.myoData.rot;
    % matrizRotacion = R .* ([1 1 -1; 1 1 -1; -1 -1 1]);
    
    %% dibujar la orientación y los datos EMG
    % actualizarOrientacionGrafico(matrizRotacion, emgVector)

    %% MATRIZ DE ROTACIÓN
    % Intentar obtener la matriz de rotación directamente desde myoObject
    try
        if isfield(myoObject, 'myoData') && isfield(myoObject.myoData, 'rot') && ~isempty(myoObject.myoData.rot)
            R = myoObject.myoData.rot;
        else
            % Si no hay rotación, intentar usar el método getRotation de la clase Myo
            miMyo = Myo();  % Instancia que usa el myoObject global
            R = miMyo.getRotation();  % Llama al método
        end
    catch ME
        % En caso de cualquier error, usar matriz identidad como valor por defecto
        disp(['Error al obtener la matriz de rotación: ', ME.message]);
        R = eye(3); % Valor predeterminado
    end

    % Verificar que la matriz R tiene las dimensiones correctas
    if size(R, 1) == 3 && size(R, 2) == 3
        % Si la matriz tiene las dimensiones correctas, realizar la transformación
        matrizRotacion = R .* ([1 1 -1; 1 1 -1; -1 -1 1]);
    else
        % Si la matriz no tiene las dimensiones correctas, mostrar un mensaje de error
        disp('Error: La matriz de rotación no tiene las dimensiones correctas.');
        matrizRotacion = eye(3);  % Usar una matriz identidad como valor predeterminado
    end
    
    %% Dibujar la orientación y los datos EMG
    % Aquí seguimos con la parte de los gráficos si no hay error con la matriz de rotación
    if exist('matrizRotacion', 'var') && exist('emgVector', 'var')
        actualizarOrientacionGrafico(matrizRotacion, emgVector);
    else
        disp('Error: Datos para la orientación o los EMG no están disponibles.');
    end


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
     % if flags.moverIMULego
        % gestos2MandoRobot(handles)
    % end

    %% ROBOT
    if flags.moverIMULego
        global bloqueoGesto
        tiempoActual = now * 24 * 3600;  % Tiempo actual en segundos
    
        if tiempoActual - bloqueoGesto.tiempoUltimoGesto >= bloqueoGesto.duracionBloqueo
            disp('Se permite enviar orden al robot (pasó el tiempo de bloqueo)');
            gestos2MandoRobot(handles)
        else
            disp('NO se permite enviar orden al robot (aún en tiempo de bloqueo)');
        end
end

end
