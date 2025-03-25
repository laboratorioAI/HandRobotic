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
            if ~obj.isConnected 
                obj.connectMyo();
            end

            if ~obj.isConnected 
                warning("No se pudo conectar al Myo.");
            end
        end

        %% Resetear los datos del buffer
        function resetBuffer(obj)
            obj.myoObject.myoData.clearLogs();
        end

        %% Conectar Myo
        function connectMyo(obj)
            obj.isConnected = true; % Bandera que indica estado de conexión

            try
                % Revisando si existe conexión existente
                obj.isConnected = obj.myoObject.myoData.isStreaming;
                
                % Si no se está transmitiendo, reiniciar conexión
                if isnan(obj.myoObject.myoData.rateEMG)
                    obj.terminateMyo();
                    obj.isConnected = false;
                end
            catch
                % En caso de que no haya conexión detectada.
                try
                    % Nueva conexión
                    obj.myoObject = MyoMex();
                    obj.myoObject.myoData.startStreaming();
                    disp('Conexión con MYO exitosa.');
                catch
                    % No se pudo conectar
                    obj.isConnected = false;
                    warning('No se pudo conectar al dispositivo Myo.');
                end
            end
        end

        %% Leer datos EMG
        function emg = readEmg(obj)
            % Retorna las señales EMG
            if obj.isConnected
                emg = obj.myoObject.myoData.emg_log; % Recupera los datos EMG
                obj.myoObject.myoData.clearLogs(); % Limpia los datos después de leerlos
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

            % Inicializar ventana persistente para almacenar los datos
            persistent emg;
            if isempty(emg)
                emg = zeros(window_size, 8); % Matriz inicial llena de ceros
            end

            % Obtener nuevos datos utilizando el método `readEmg`
            newData = obj.readEmg();

            % Calcular el tamaño del salto (stride)
            stride = size(newData, 1);
            if stride > window_size
                stride = window_size; % Limitar el tamaño del stride al de la ventana
            end

            % Actualizar la ventana con los nuevos datos
            emg = circshift(emg, -stride, 1); % Mueve los datos antiguos hacia arriba
            emg(end - stride + 1:end, :) = newData(end - stride + 1:end, :); % Añade los nuevos datos al final

            % Devolver la ventana actualizada
            data = emg;
        end

        %% Terminar la conexión con Myo
        function terminateMyo(obj)
            obj.isConnected = false;

            try
                % Detener streaming y eliminar objeto Myo
                obj.myoObject.myoData.stopStreaming();
                pause(0.1);  % Dar un pequeño tiempo para la finalización
                obj.myoObject.delete;
                obj.isConnected = false;
            catch me
                disp(me.message);
                try
                    % Intentar detener el streaming si hubo un error
                    obj.myoObject.myoData.stopStreaming();
                    obj.myoObject.delete;
                catch me
                    disp(me.message);
                end
            end
        end
    end
end
