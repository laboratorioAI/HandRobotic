function angulosEnviarRobot()
% se ejecuta una vez al lazo
global flags datosUsuario EV3 myoObject YPRang


if flags.isRobotMoving && flags.moverIMULego

    % cálculo de orientación relativa
    R=myoObject.myoData.rot;        
    
    [datosUsuario.orientacion] = rotMatrix2angNoProble(R,datosUsuario.orientacion);
    
    [yaw,pitch,roll] = salidaAngulos(datosUsuario.orientacion);
    YPRang =[yaw,pitch,roll];
    datosUsuario.real = [datosUsuario.real ; [yaw,pitch,roll]] ;
    
    datosUsuario.angulos = 200*400*(yaw+180)+400*(pitch+90)+(roll+180);
    
    EV3.writeMailBox('angulos','numeric',datosUsuario.angulos )
    
    
    flags.kDatosLegoEnviados = flags.kDatosLegoEnviados + 1;
end


end

