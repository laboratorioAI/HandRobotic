function gestos2MandoRobot(handles)
% Decisión de movimientos. Se ejecuta únicamente cuando el sistema detecta
% un gesto!
global flags datosUsuario myoObject EV3

flags.kdiscernirGesto2Robot = flags.kdiscernirGesto2Robot + 1;
gestoRespuesta = datosUsuario.gestoRespuesta;

% Asociamos el gesto a su descripción
switch gestoRespuesta
    case 1
        % Wave In (Play/Pause)
        disp('Movimiento detectado: Wave In - Play/Pausa');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: Wave In - Play/Pausa');
        
        if ~flags.isRobotMoving % Bandera para el toggle de play/pause
            % Alistándose
            flags.isRobotMoving = true;
            set(handles.mensajesTextBox, 'String', 'MANDO DEL BRAZO ROBOTICO')
            
            % Obtener la posición inicial del myo
            Ro = myoObject.myoData.rot;
            datosUsuario.orientacion = initOrientacion(Ro);
            
            % Enviar comando de inicio al robot
            EV3.writeMailBox('modos', 'text', 'robot3GDL')
            EV3.writeMailBox('movimiento', 'text', 'iniciar')
            
        else
            % Ya en movimiento, parar el robot
            flags.isRobotMoving = false;
            set(handles.mensajesTextBox, 'String', 'Robot Pausado!!!')
            pararMandoRobot(datosUsuario, EV3);
        end
        
    case 2
        % Wave Out (Detener ejecución)
        disp('Movimiento detectado: Wave Out - Detener ejecución');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: Wave Out - Detener ejecución');
        
        set(handles.pausaRadio, 'Value', 1)
        pararMandoRobot(datosUsuario, EV3);
        
        % Pausar
        if flags.isRobotMoving
            pararMandoRobot(datosUsuario, EV3);
        end
        
        flags.moverIMULego = 0;
        flags.iniciado = false;
        set(handles.iniciarButton, 'String', 'Reanudar')
        flags.reconocer = false;
        set(handles.tituloGestoText, 'String', '')
        
        flags.dibujarEMG = true;
        beep
        
    case 3
        % Fist (Cerrar garra)
        disp('Movimiento detectado: Fist - Cerrar garra');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: Fist - Cerrar garra');
        
        if flags.isRobotMoving
            pararMandoRobot(datosUsuario, EV3);
        end
        set(handles.mensajesTextBox, 'String', 'CERRANDO PINZA ROBOTICA!!!')
        
        EV3.writeMailBox('modos', 'text', 'cerrarGarra')
        scatter(handles.pinzaAxes, 0, 0, 30, 'r', 'filled');
        axis(handles.pinzaAxes, 'off');
        handles.pinzaText.String = 'Estado cerrado';
        
    case 4
        % Open (Abrir garra)
        disp('Movimiento detectado: Open - Abrir garra');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: Open - Abrir garra');
        
        if flags.isRobotMoving
            pararMandoRobot(datosUsuario, EV3);
        end
        set(handles.mensajesTextBox, 'String', 'ABRIENDO PINZA ROBOTICA!!!')
        
        EV3.writeMailBox('modos', 'text', 'abrirGarra')
        scatter(handles.pinzaAxes, 0, 0, 30, 'g', 'filled');
        axis(handles.pinzaAxes, 'off');
        handles.pinzaText.String = 'Estado abierto';
        
    case 5
        % Pinch (Posición inicial)
        disp('Movimiento detectado: Pinch - Posición inicial');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: Pinch - Posición inicial');
        
        if flags.isRobotMoving
            pararMandoRobot(datosUsuario, EV3);
        end
        set(handles.mensajesTextBox, 'String', 'Posición inicial')
        EV3.writeMailBox('modos', 'text', 'posicionInicial')
        
    case {6, 0}
        % Variantes del no gesto o gesto no reconocido
        disp('Movimiento detectado: No gesto o gesto no reconocido');
        set(handles.mensajesTextBox, 'String', 'Movimiento detectado: No gesto o gesto no reconocido');
        
    otherwise
        disp(['Gesto no reconocido: ', num2str(gestoRespuesta)]);
        set(handles.mensajesTextBox, 'String', ['Gesto no reconocido: ', num2str(gestoRespuesta)]);
end
end
