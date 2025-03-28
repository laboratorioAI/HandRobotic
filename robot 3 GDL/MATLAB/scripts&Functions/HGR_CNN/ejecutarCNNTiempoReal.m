function ejecutarCNNTiempoReal(handles)
    % Función para ejecutar el modelo CNN-LSTM en tiempo real y graficar los gestos reconocidos
    global flags myoObject; % Usar la conexión existente al Myo

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

    %% Loop de reconocimiento
    disp('Iniciando reconocimiento en tiempo real...');
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

            % Convertir la salida a un tipo adecuado
            if isa(class_pred, 'categorical')
                class_pred = string(class_pred);  % Convertir a cadena de caracteres
            end

            % Mostrar resultados en consola
            fprintf(sprintf("Tiempo restante: %.2f, Predicción: %s\n", period - toc(t), class_pred(end)));

            % Extraer la última predicción y actualizar la GUI
            gestoReconocido = class_pred(end); % Última predicción (gesto reconocido)

            % Llamar a la función dibujarGUICNN para graficar el gesto
            dibujarGUI_CNN(handles, gestoReconocido, flags, myoObject);

        catch ME
            disp(['Error en el loop de reconocimiento: ', ME.message]);
            break; % Salir del loop si hay un error crítico
        end

        % Sincronización del loop
        pause(max(0, period - toc(t))); % Esperar tiempo restante
    end

    disp('Reconocimiento en tiempo real finalizado.');
end
