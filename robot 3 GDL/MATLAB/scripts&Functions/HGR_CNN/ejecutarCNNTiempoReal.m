function ejecutarCNNTiempoReal(handles, reconocimientoConfiguracion)
    global flags myoObject datosUsuario gestoReconocido; % Usar la conexión existente al Myo

    global mensajeEspere  
    mensajeEspere={'Preparando para reconocimiento', 'por favor espere'};
    h1=espere;
    drawnow

    % Configuración de parámetros
    window_size = 300; % Tamaño de la ventana deslizante
    stride = 30; % Estride para la ventana
    addpath(genpath('MyoMex-master')); % Asegúrate de incluir las librerías necesarias

    period = 1/200 * stride; % Período ajustado para sincronización

    %% Inicialización
    % Crear una instancia de la clase Myo
    try
        myo = Myo(); 
        disp('Conexión inicial al Myo exitosa.');
    catch ME
        error(['Error al conectar al dispositivo Myo: ', ME.message]);
    end

    % Cargar el modelo CNN-LSTM
    try
        model = Model_spec_CNN_LSTM(); % Instancia del modelo
        disp('Modelo CNN-LSTM cargado correctamente.');
    catch ME
        error(['Error al cargar el modelo CNN-LSTM: ', ME.message]);
    end

    close(h1);
    drawnow

    %preparativosCNN;

    %% Loop de reconocimiento
    disp('Iniciando reconocimiento en tiempo real...');
    % Variable para controlar el tiempo de retardo después de cada gesto
    tiempo_retraso_post_gesto = 1;  % 1 segundo de retraso después de la detección del gesto
    while flags.reconocerCNN
        t = tic;
        try
            % Verificar que `myo` sea una instancia válida de la clase `Myo`
            if ~isa(myo, 'Myo')
                error('El objeto `myo` no es una instancia válida de la clase `Myo`.');
            end

            % Usar el método load_EMG_window de la clase Myo para cargar datos EMG
            emg_window = myo.load_EMG_window(window_size); % Ventana de datos EMG
            
            % Clasificar los datos EMG con el modelo CNN-LSTM
            class_pred = model.classify(emg_window);

            % Asegurarnos de que la predicción sea una cadena
            class_pred_str = string(class_pred(end));  % Convertir a string si no lo es

            % Mapea el gesto reconocido (categoría) a un índice numérico
            gesture_map = containers.Map({'waveIn', 'waveOut', 'fist', 'open', 'pinch', 'noGesture'}, ...
                                         [1, 2, 3, 4, 5, 6]);

            % Convertir la predicción a un índice numérico
            if isKey(gesture_map, strip(class_pred_str))  % Usamos strip para eliminar espacios innecesarios
                gestoReconocido = gesture_map(strip(class_pred_str));  % Obtener índice numérico
            else
                gestoReconocido = 0;  % Si no hay coincidencia, devolver un valor por defecto (gesto desconocido)
            end

            % Mostrar resultados en consola
            fprintf(sprintf("Tiempo restante: %.2f, Predicción: %s\n", period - toc(t), class_pred_str));
            
            % Llamar a la función dibujarGUI_CNN para graficar el gesto
            dibujarGUI_CNN(handles, gestoReconocido, myoObject, reconocimientoConfiguracion, datosUsuario);
            % preparativosCNN;
            % Ralentizar después de detectar un gesto
            pause(tiempo_retraso_post_gesto);  % Pausa después de un gesto
            
        catch ME
            disp(['Error en el loop de reconocimiento: ', ME.message]);
            break; % Salir del loop si hay un error crítico
        end

        % Sincronización del loop
        pause(max(0, period - toc(t))); % Pausa adicional
        %pause(1.2);
    end

    disp('Reconocimiento en tiempo real finalizado.');
end