classdef Myo < handle
    % Myo class to communicate with Myo
    % Esta clase interactúa con el dispositivo Myo para leer datos EMG y realizar otras tareas.

    properties (GetAccess = public, SetAccess = private)
        isConnected = false;
        myoObject
    end

    methods
        %% Constructor
        function obj = Myo()
            % El constructor intenta conectar el Myo
            disp('Intentando conectar al Myo...');
            obj.connectMyo();  % Intenta conectar al Myo
        end

        %% Conectar Myo
        function connectMyo(obj)
            % Aquí debes colocar el código que establece la conexión con el Myo
            % Para esta demostración se simula que la conexión fue exitosa
            disp('Conectando al Myo...');
            obj.isConnected = true;
            disp('Conexión con el Myo exitosa!');
            
            % Este es un objeto simulado para fines de demostración
            obj.myoObject = struct();
            obj.myoObject.myoData = struct('emg_log', rand(200,8), 'rot', rand(1,3)); % Datos de ejemplo para EMG y rotación
            disp('Datos de EMG y rotación simulados en myoObject.');
        end

        %% Leer EMG
        function emg = readEmg(obj)
            % Retorna las señales EMG
            % disp('Intentando leer datos EMG...');
            if obj.isConnected
                emg = obj.myoObject.myoData.emg_log; % Recupera los datos EMG simulados
                % disp('Datos EMG leídos con éxito.');
                obj.myoObject.myoData.emg_log = []; % Limpia los datos después de leerlos
            else
                error('Myo no está conectado.');
            end
        end

        %% Obtener datos de rotación
        function rot = readRotation(obj)
            % Devuelve la orientación (rotación) del Myo
            disp('Intentando leer datos de rotación...');
            if obj.isConnected
                rot = obj.myoObject.myoData.rot;
                disp('Datos de rotación leídos con éxito.');
            else
                error('Myo no está conectado.');
            end
        end

        %% Método `load_EMG_window`
        function data = load_EMG_window(obj, window_size)
            % Este método devuelve la ventana más reciente de datos EMG dentro del tamaño de ventana especificado.
            % Inputs:
            %   - window_size: Tamaño de la ventana deslizante para los datos EMG.
            % Outputs:
            %   - data: Matriz de tamaño [window_size x 8] con los datos EMG.

            
            
            arguments
                obj
                window_size (1, 1) double {mustBePositive, mustBeInteger}
            end
        
            %disp(['Intentando cargar ventana de datos EMG con tamaño: ', num2str(window_size)]);
            % Inicializar ventana persistente para almacenar los datos
            persistent emg;
            if isempty(emg)
                emg = zeros(window_size, 8); % Matriz inicial llena de ceros
                %disp('Ventana EMG inicializada.');
            end
            
            % Obtener nuevos datos utilizando el método `readEmg`
            newData = obj.readEmg();
            %disp('Datos EMG obtenidos y listos para procesar.');

            % Calcular el tamaño del salto (stride)
            stride = size(newData, 1);
            if stride > window_size
                stride = window_size; % Limitar el tamaño del stride al de la ventana
            end
            % disp(['Tamaño del stride calculado: ', num2str(stride)]);

            % Actualizar la ventana con los nuevos datos
            emg = circshift(emg, -stride, 1); % Mueve los datos antiguos hacia arriba
            emg(end - stride + 1:end, :) = newData(end - stride + 1:end, :); % Añade los nuevos datos al final
            % disp('Ventana EMG actualizada con nuevos datos.');

            % Devolver la ventana actualizada
            data = emg;
            % disp('Datos de la ventana EMG retornados.');
        end

        %% Terminar la conexión con Myo
        function terminateMyo(obj)
            % Simula la desconexión
            disp('Terminando la conexión con Myo...');
            obj.isConnected = false;
            disp('Conexión con Myo terminada.');
        end
    end
end
