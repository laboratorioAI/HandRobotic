function isConnectedMyo = connectMyo(handles)
% Función para conectarse al Myo. Utiliza librería Myo Mex. No se realiza
% ninguna acción en el caso de que el dispositivo ya esté
% conectado. La estructura que contiene los datos del Myo se llama
% myoObject; esta es usada como variable global.

global myoObject

isConnectedMyo = 1; % Bandera que indica estado de conexión

try
    % Revisando si existe conexión existente
    isConnectedMyo = myoObject.myoData.isStreaming;
    set( handles.auxiliarText , 'String' , 'm Ok');
    
    if isnan(myoObject.myoData.rateEMG)
        set( handles.auxiliarText , 'String' , 'rateEMG');
        terminateMyo
        isConnectedMyo = 0;
    end
catch
    % En el caso de que no haya conexión detectada.
    
    try
        % Nueva conexión
        myoObject = MyoMex();
        beep
        % fprintf('Conexión con MYO exitosa!!!\n');
    catch
        % No conexión posible
        set( handles.auxiliarText , 'String' , 'Connect\n');
        isConnectedMyo=0;
    end
end


end

