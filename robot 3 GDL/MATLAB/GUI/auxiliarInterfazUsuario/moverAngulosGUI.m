% SWITCH PANEL!
global EV3 flags datosUsuario

ROBOT
flags.moverIMULego=1;


PAUSA
flags.moverIMULego=0;
%
swicth


% ROLL

anguloMover=inputdlg({'Angulo a mover grado de libertad seleccionado.'},'Angulo de prueba',1,{'30'});
anguloMover=str2double(char(anguloMover));
if ~isempty((anguloMover)) && abs(anguloMover)<91
    angulos=datosUsuario.angulos;
    flagMovimientoRobot=0;
    
    flags.moverIMULego=0;
    
    EV3.writeMailBox('angulos','numeric',angulos)
    
    EV3.writeMailBox('movimiento','text','parar')
    flags.movimientoRobot=flagMovimientoRobot;
    
    
    EV3.writeMailBox('modos','text','moverGradoQ')
    EV3.writeMailBox('gradoQ','text','roll')
    EV3.writeMailBox('anguloQ','numeric',anguloMover)
    
    
else
    errordlg('Ingrese un angulo valido!', 'ANGULO INCORRECTO', 'modal');
end



% PITCH

anguloMover=inputdlg({'Angulo a mover grado de libertad seleccionado.'},'Angulo de prueba',1,{'30'});
anguloMover=str2double(char(anguloMover));
if ~isempty((anguloMover)) && abs(anguloMover)<91
    angulos=datosUsuario.angulos;
    flagMovimientoRobot=0;
    
    flags.moverIMULego=0;
    
    
    EV3.writeMailBox('angulos','numeric',angulos)
    
    EV3.writeMailBox('movimiento','text','parar')
    flags.movimientoRobot=flagMovimientoRobot;
    
    
    EV3.writeMailBox('modos','text','moverGradoQ')
    EV3.writeMailBox('gradoQ','text','pitch')
    EV3.writeMailBox('anguloQ','numeric',anguloMover)
else
    errordlg('Ingrese un angulo valido!', 'ANGULO INCORRECTO', 'modal');
end





% YAW
anguloMover=inputdlg({'Angulo a mover grado de libertad seleccionado.'},'Angulo de prueba',1,{'30'});
anguloMover=str2double(char(anguloMover));
if ~isempty((anguloMover)) && abs(anguloMover)<91
    angulos=datosUsuario.angulos;
    flagMovimientoRobot=0;
    
    flags.moverIMULego=0;
    
    EV3.writeMailBox('angulos','numeric',angulos)
    
    EV3.writeMailBox('movimiento','text','parar')
    flags.movimientoRobot=flagMovimientoRobot;
    
    EV3.writeMailBox('modos','text','moverGradoQ')
    EV3.writeMailBox('gradoQ','text','yaw')
    EV3.writeMailBox('anguloQ','numeric',anguloMover)
    
else
    errordlg('Ingrese un Angulo valido!', 'ANGULO INCORRECTO', 'modal');
end