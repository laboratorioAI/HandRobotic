% dibujarGUI
% script para dibujar en la interfaz de usuario

function [datosUsuario] =dibujarGUI(handles,datosUsuario,myoObject ,reconocimientoConfiguracion ,emg)

global axesGesto flags YPRang


if flags.dibujarEMG
    
    %% EMG
    if ~flags.reconocer % en el caso de que esté esperando!
        emgPlot= myoObject.myoData.emg_log;
        myoObject.myoData.clearLogs();
        
    else % en el caso de que esté reconociendo
        emgPlot = emg ;
    end
    
    samplesLoop=size(emgPlot,1);
    
    if samplesLoop == 0
        samplesLoop = 40 ;
        emgPlot = zeros( 40 , 8 ) ;
        
        flags.kPerdidasDibujarGUI = flags.kPerdidasDibujarGUI + 1 ;
        
        set ( handles.perdidasText , 'String' , ['NoData!' num2str( flags.kPerdidasDibujarGUI ) ] ) ;
        
    elseif samplesLoop > 200 * 0.2 %% eliminamos log!
        samplesLoop = 40 ;
        
    end
    
    flags.kEjecucionesDibujarGUI = flags.kEjecucionesDibujarGUI + 1 ; % cuenta cuántas veces se dibujó!
    
    datosUsuario.emgVector = circshift(datosUsuario.emgVector ,-samplesLoop);
    datosUsuario.emgVector(end-samplesLoop+1:end,:) = emgPlot(end-samplesLoop+1:end,:);
    
    emgVector=datosUsuario.emgVector;
    
    
    
    
    %% matriz de rotación
    R = myoObject.myoData.rot;
    matrizRotacion = R .* ( [1 1 -1;1 1 -1;-1 -1 1] );
    
    %% dibujar
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
    % switch por gestos olvidados
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
            nombreGestoRespuesta=reconocimientoConfiguracion.nameGestures{6};
            imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);
            
            axesGesto.CData=imagenGesto;
            
            flags.LimpiarAxes=0;
        end
        
        datosUsuario.gestoDibujado = false ; % variable para saber si ya se dibujó o no
        
        
        
    else
        %% GESTO
        
        if ~datosUsuario.gestoDibujado
            % dibujando gesto una vez
            nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{ gestoRespuesta } ;
            imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);
            
            set(handles.tituloGestoText,'String',nombreGestoRespuesta) % nombre del gesto
            
            axesGesto.CData=imagenGesto;
            
            flags.LimpiarAxes = 1;
            datosUsuario.gestoDibujado = true ;
            flags.kGestosDibujados = flags.kGestosDibujados + 1 ;
        else
            flags.kGestosRepetidos = flags.kGestosRepetidos + 1 ;
            nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{ gestoRespuesta } ;
            
            set(handles.perdidasText , 'String' , nombreGestoRespuesta ) % nombre del gesto
        end
    end
    
    
end
end

