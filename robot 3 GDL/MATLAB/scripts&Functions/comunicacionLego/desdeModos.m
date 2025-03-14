function isConnectedLego = desdeModos()
global EV3
isConnectedLego = connectLegoTemp;

%% conexion
if isConnectedLego
    EV3.writeMailBox('inicio','text','iniciar');
    
    nombreUsuario = getenv('computername');
    
    EV3.writeMailBox('PC','text', nombreUsuario );
    try
        [title,msg] = EV3.readMailBox('text')
        disp('desde modos!!!!!!!!!!')
    catch
        isConnectedLego = 0;
        disp('EJEcuta l programa en EV3!!!!!!!!!!!')
    end
else
    disp('desde modos, no conectado a Lego')
end
end