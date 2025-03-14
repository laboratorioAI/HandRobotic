% Real-time loop with gesture classification and robot control

clear all
close all
clc

%% Configuración
window_size = 300;
stride = 30;

%% Librerías y variables auxiliares
addpath(genpath('MyoMex-master')) % O agrega tu propia ruta a MyoMex
period = 1/200 * 30;

%% Inicialización del Myo y modelo
myo = Myo();
model = Model_spec_CNN_LSTM();

%% Inicialización de variables globales (esto debe estar en algún lugar accesible)
global flags datosUsuario myoObject EV3
flags = struct();
datosUsuario = struct();
myoObject = myo;  % Usamos 'myo' como el objeto de Myo
EV3 = LegoEV3();  % Asumiendo que 'LegoEV3' es la clase para la comunicación con el robot
EV3.open();  % Establece la comunicacion con el robot

%% Ciclo en tiempo real
while true
    t = tic;
    
    % Obtener datos EMG
    emg = myo.load_EMG_window(window_size);
    
    % Clasificar el gesto usando el modelo
    class_pred = model.classify(emg);
    
    % Almacenar el gesto predicho en la variable global
    datosUsuario.gestoRespuesta = class_pred(end);  % Última predicción
   
    disp(['Gesto Reconocido: ', num2str(datosUsuario.gestoRespuesta)]);
    
    % Actualizar el texto de la interfaz con el gesto reconocido
    set(handles.mensajesTextBox, 'String', ['Gesto Reconocido: ', num2str(datosUsuario.gestoRespuesta)]);
    
    % Llamar a la función de control del robot según el gesto detectado
    gestos2MandoRobot(handles);  % Controlar el robot basado en el gesto
    
    % Dibujar en la interfaz (si es necesario)
    drawnow
    
    % Asegurar que la frecuencia del ciclo sea consistente
    rem = period - toc(t);
    Print(sprintf("%.2f %s\n", rem, class_pred(end)));
    
    % Pausa para mantener la frecuencia de muestreo
    pause(period - toc(t))
end

