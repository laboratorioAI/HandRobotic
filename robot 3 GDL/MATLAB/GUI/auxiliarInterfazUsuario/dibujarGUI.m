% dibujarGUI
% script para dibujar en la interfaz de usuario

function [datosUsuario] =dibujarGUI(handles,datosUsuario,myoObject ,reconocimientoConfiguracion ,emg)

global axesGesto flags YPRang



% Proceso para EMG

if flags.dibujarEMG
    
    %% EMG
    if ~flags.reconocer % Esperando reconocimiento
        emgPlot= myoObject.myoData.emg_log; % Esperando reconocimiento
        myoObject.myoData.clearLogs();  % Limpiar los logs de EMG
        
    else % en el caso de que esté reconociendo
        emgPlot = emg ; % Datos EMG que se están reconociendo
    end
    
    % Actualización de los datos EMG
    samplesLoop=size(emgPlot,1);
    
    if samplesLoop == 0
        samplesLoop = 40 ;
        emgPlot = zeros( 40 , 8 ) ; % Si no hay datos, inicializa como vacío
        
        flags.kPerdidasDibujarGUI = flags.kPerdidasDibujarGUI + 1 ;
        set ( handles.perdidasText , 'String' , ['NoData!' num2str( flags.kPerdidasDibujarGUI ) ] ) ;
        
    elseif samplesLoop > 200 * 0.2 %% eliminamos log!
        samplesLoop = 40 ;
        
    end
    
    % Actualización de los datos de EMG en el vector de usuario
    flags.kEjecucionesDibujarGUI = flags.kEjecucionesDibujarGUI + 1 ; % cuenta cuántas veces se dibujó!
    
    datosUsuario.emgVector = circshift(datosUsuario.emgVector ,-samplesLoop);
    datosUsuario.emgVector(end-samplesLoop+1:end,:) = emgPlot(end-samplesLoop+1:end,:);
    
    emgVector=datosUsuario.emgVector;
    
    
    
    
    %% matriz de rotación
    R = myoObject.myoData.rot;
    matrizRotacion = R .* ( [1 1 -1;1 1 -1;-1 -1 1] );
    
    %% dibujar la orientación y los datos EMG
    actualizarOrientacionGrafico(matrizRotacion,emgVector)
    
    
else
    
    %% textos
    if flags.muestrasPerdidas % no tiene nada el emg
        set ( handles.perdidasText , 'String' , ['NoData!' num2str( flags.kExeXSamPerdidasRecog ) ] ) ;
    end
    
    if flags.tiempoAlerta % si hay problemas de tiempo
        set( handles.auxiliarText , 'String' , [ '!. ' num2str( flags.tClass ) '%' ] )
    end
    
    
    %% robot
    if flags.isRobotMoving
        YPR = YPRang;
        handles.yawText.String = num2str(YPR(1));
        handles.pitchText.String = num2str( - YPR(2));
        handles.rollText.String = num2str(YPR(3));
    else
        handles.yawText.String = '';
        handles.pitchText.String = '';
        handles.rollText.String = '';
    end

    %% gesto
    % dibujar el gesto cuando se está reconociendo un gesto específico.
    if flags.dibujarGestoReconocido
        flags.dibujarGestoReconocido = false ;
        gestoRespuesta = datosUsuario.gestoRespuestaPendiente;
        isPendiente = gestoRespuesta ~= datosUsuario.gestoRespuesta ;
        
        if isPendiente
            flags.kCasiNoDibujadosGestos = flags.kCasiNoDibujadosGestos + 1 ;
            set( handles.perdidasText , 'String' , ['almost ' num2str( flags.kCasiNoDibujadosGestos ) ]);
        end
        
    else
        gestoRespuesta = datosUsuario.gestoRespuesta;
    end
    
    %% no gesto
    % Si el gesto reconocido es de tipo "no gesto", 
    % limpia el área de dibujo y muestra la imagen asociada a un gesto "no reconocido"
    if gestoRespuesta==6 || gestoRespuesta==0 % variantes del no gesto
        % escribiendo gesto...
        puntosDibujar = rem( flags.kEjecucionesLoop , 4 ) ;
        switch puntosDibujar
            case 0
                inicioP = '' ;
                puntos = '' ;
            case 1
                inicioP = ' ' ;
                puntos = '.' ;
            case 2
                inicioP = '  ' ;
                puntos = '..' ;
            case 3
                inicioP = '   ' ;
                puntos = '...' ;
            otherwise
                puntos = '??????????????' ;
        end
        set(handles.tituloGestoText,'String', [ inicioP 'Reconociendo' puntos ] ) % nombre del gesto
        
        if flags.LimpiarAxes % solo una  vez...
            % limpiamos, poniendo la imagen del noGesto
            nombreGestoRespuesta=reconocimientoConfiguracion.nameGestures{6}; % Gesto no reconocido
            imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);
            
            axesGesto.CData=imagenGesto; % Gesto no reconocido
            
            flags.LimpiarAxes=0;
        end
        
        datosUsuario.gestoDibujado = false ; % variable para saber si ya se dibujó o no
        
        
        
    else
        %% GESTO
        % Si el gesto aún no ha sido dibujado
        if ~datosUsuario.gestoDibujado
            % dibujando gesto una vez
            nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{ gestoRespuesta } ; % Obtener el nombre del gesto
            imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta); % Cargar la imagen del gesto
            
            set(handles.tituloGestoText,'String',nombreGestoRespuesta) % Actualizar el título con el nombre del gesto
            
            axesGesto.CData=imagenGesto; % Actualizar el título con el nombre del gesto
            
            flags.LimpiarAxes = 1;
            datosUsuario.gestoDibujado = true ;
            flags.kGestosDibujados = flags.kGestosDibujados + 1 ;
        else
            flags.kGestosRepetidos = flags.kGestosRepetidos + 1 ;
            nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{ gestoRespuesta } ;
            
            set(handles.perdidasText , 'String' , nombreGestoRespuesta ) % Mostrar el nombre del gesto repetido
        end
    end
    
    
end
end

