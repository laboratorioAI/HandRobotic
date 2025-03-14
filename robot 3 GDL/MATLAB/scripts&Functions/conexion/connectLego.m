function isConnectedLego=connectLego(handles)
% función para conectar al Lego EV3 vía Bluetooth. Como argumento de salida
% se tiene una bandera. isConnectedLego. La función detecta si existe o no
% una conexión existente.


global EV3
isConnectedLego = 1;

try
    beep(EV3)
    set( handles.auxiliarText, 'String' , 'L ok');
catch
    %% borramos todas las conexiones que haya    
    
    try
        EV3= Brick('ioType','instrbt','btDevice','EV3','btChannel',1);
        beep(EV3)
        set( handles.auxiliarText , 'String' , 'L start!');
    catch
        fclose( instrfindall ) ;
        delete(instrfindall);
        set( handles.auxiliarTex , 'String' , '!L');
        isConnectedLego=0;
    end
end
end
