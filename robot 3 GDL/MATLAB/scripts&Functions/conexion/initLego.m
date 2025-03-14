% Intenta conexión con Lego, si falla, isConnectedLego se vuelve cero!
% isLegoRunning es una bandera para detectar si el programa está
% ejecutándose en EV3
function isConnectedLego = initLego(handles)
global EV3 isLegoProgramRunning

isConnectedLego=0;
isLegoProgramRunning=0;

try
    isConnectedLego = connectLego(handles);
    
    
    EV3.writeMailBox('inicio','text','iniciar');
    nombreUsuario = getenv('computername');
    
    EV3.writeMailBox('PC','text', nombreUsuario );
    
    try        
        set( handles.auxiliarText , 'String' , '!Lego');
        [title,msg] = EV3.readMailBox('text');
        set( handles.auxiliarText , 'String' , 'L ok')
        isLegoProgramRunning = 1;
        
    catch
        isConnectedLego = 0;
        
    end
    
catch
    set( handles.auxiliarText , 'String' , ' What Lego')
    
end


