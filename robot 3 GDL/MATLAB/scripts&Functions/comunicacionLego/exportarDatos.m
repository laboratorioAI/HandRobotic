function vectorDeseado = exportarDatos(elDatoAExportar)
%% exportando datos

%
% %% conexion
% EV3.writeMailBox('inicio','text','iniciar');
%
%
% [title,msg] = EV3.readMailBox('text')
% desde modos!!!!!!!!!!

% pedido para exportar datos!
global EV3
EV3.writeMailBox('modos','text','exportarDatos');

% case del dato a exportar
switch elDatoAExportar
    case 'garra'
        
        %% garra
        EV3.writeMailBox('exportar','text','garra');
        [title,garraPosicion] = EV3.readMailBox('numeric')
        
        if garraPosicion == 1500
            disp('garra cerrada')
        elseif garraPosicion == 0
            disp('garra abierta')
        else
            disp('mal posicion garra, exportar datos!')
        end
        vectorDeseado = garraPosicion;
        
        
    case 'roll'
        
        %% roll
        EV3.writeMailBox('exportar','text','roll');
        
        refRoll=leyendoCadenaDatos();
        roll=leyendoCadenaDatos();
        powerRoll=leyendoCadenaDatos();
        
        vectorDeseado.ref=refRoll;
        vectorDeseado.real=roll;
        vectorDeseado.power=powerRoll;
        
    case 'pitch'
        
        %% pitch
        EV3.writeMailBox('exportar','text','pitch');
        
        refPitch=leyendoCadenaDatos();
        pitch=leyendoCadenaDatos();
        powerPitch=leyendoCadenaDatos();
        
        vectorDeseado.ref=refPitch;
        vectorDeseado.real=pitch;
        vectorDeseado.power=powerPitch;
    case 'yaw'
        
        %% yaw
        EV3.writeMailBox('exportar','text','yaw');
        
        refYaw=leyendoCadenaDatos();
        yaw=leyendoCadenaDatos();
        powerYaw=leyendoCadenaDatos();
        
        vectorDeseado.ref=refYaw;
        vectorDeseado.real=yaw;
        vectorDeseado.power=powerYaw;
        
    case 'timeLoop'
        %% timeloop. todos necesitan el tiemLoop
        EV3.writeMailBox('exportar','text','timeLoop');
        timeLoop=leyendoCadenaDatos();
        
        vectorDeseado=timeLoop;
        
    otherwise
        disp('caso desconocido, no sea gil en exportarDatos')
end
end
% % aux lego
% %% conexion
% EV3.writeMailBox('inicio','text','iniciar');
% [title,msg] = EV3.readMailBox('text')
% %% modos cerrar
% EV3.writeMailBox('modos','text','cerrarGarra')
% EV3.writeMailBox('modos','text','abrirGarra')
% EV3.writeMailBox('modos','text','robot3GDL')
% [title,msg] = EV3.readMailBox('logic')
%  [title,msg] = EV3.readMailBox('text')