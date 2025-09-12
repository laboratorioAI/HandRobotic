classdef Myo < handle
    % Myo class to communicate with Myo
    % Esta clase interactúa con el dispositivo Myo para leer datos EMG y realizar otras tareas.

    properties (GetAccess = public, SetAccess = private)
        % isConnectedMyo = false;
        myoObject
    end

    methods
        %% Constructor
        function obj = Myo()
            % El constructor debería no conectar el Myo, solo utilizar el objeto ya conectado
            global myoObject
            
            if isempty(myoObject)
                error('El objeto myoObject no está conectado.');
            else
                obj.myoObject = myoObject;  % Utiliza el myoObject global
                disp('Objeto Myo conectado.');
            end
        end

        %% Resetear los datos del buffer
        function resetBuffer(obj)
            obj.myoObject.myoData.clearLogs();
        end

        

        %% Leer datos EMG
        function emg = readEmg(obj)
            % Retorna las señales EMG
            if obj.myoObject.myoData.isStreaming
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

        %% Obtener matriz de rotación
        function rot = getRotation(obj)
            % Retorna la matriz de rotación
            if obj.myoObject.myoData.isStreaming
                rot = obj.myoObject.myoData.rot; % Recupera la matriz de rotación
                if isempty(rot)
                    error('La matriz de rotación está vacía.');
                else
                    disp('Matriz de rotación obtenida'); 
                end
            else
                error('Myo no está conectado.');
            end
        end
        
    end
end
