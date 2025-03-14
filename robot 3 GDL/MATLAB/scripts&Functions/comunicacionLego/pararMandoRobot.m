% enviar cero
function pararMandoRobot(datosUsuario,EV3)
global flags
angulos = datosUsuario.angulos;
EV3.writeMailBox('angulos','numeric',angulos)

% sale del modo brazoRobot3GDL!
EV3.writeMailBox('movimiento','text','parar')
flags.isRobotMoving = 0;
end