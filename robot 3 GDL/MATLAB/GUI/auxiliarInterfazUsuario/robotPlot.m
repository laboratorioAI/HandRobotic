function robotPlot(handles)
% for k=1
global EV3
%v26/06
% dibuja y exporta los archivos del lego

% cambio de directorio para almacenamiento de datos
cd('.\Mindstorm brick\files')

EV3.fileDownload('/home/root/lms2012/prjs/robot3GDL/modo.rtf',...
    'modo.rtf',500)

% EV3.fileDownload('/home/root/lms2012/prjs/calibracionPID/modo.rtf',...
%     'modo.rtf',500)

modoLego = importdata('modo.rtf');

constantesPID.yaw= [1 0.01 0.1];
constantesPID.pitch=[1 0.01 0.1];
constantesPID.roll=[1 0.01 0.1];

relacionEngranes.yaw=6.75;
relacionEngranes.pitch=-7.785;
relacionEngranes.roll=-1.667;


%% switch
switch char(modoLego)
    case 'robot3GDL'
        timeLoop=exportarDatos('timeLoop');
        
        % se necesitan todos!
        yaw=exportarDatos('yaw');
        pitch =exportarDatos('pitch');
        roll =exportarDatos('roll');
        
        % habilitando los axes ocultos, esos ocultosdesde el inicio
        set(handles.robotAxesLeft,'Visible','on')
        set(handles.robotAxesRight,'Visible','on')
        
        % dibujando, existe una mega función!
        axes(handles.robotAxesLeft)
        gradoQPlot(timeLoop,'yaw',yaw,relacionEngranes.yaw,constantesPID.yaw)
        
        axes(handles.robotAxes)
        gradoQPlot(timeLoop,'pitch',pitch,relacionEngranes.pitch,constantesPID.pitch)
        
        axes(handles.robotAxesRight)
        gradoQPlot(timeLoop,'roll',roll,relacionEngranes.roll,constantesPID.roll)
        
        
    case 'moverGradoQ'
        
        % exportando el dato del switch
        EV3.fileDownload('/home/root/lms2012/prjs/robot3GDL/gradoQ.rtf',...
            'gradoQ.rtf',500)
        %
        %         EV3.fileDownload('/home/root/lms2012/prjs/calibracionPID/gradoQ.rtf',...
        %             'gradoQ.rtf',500)
        gradoLego = importdata('gradoQ.rtf');
        
        timeLoop=exportarDatos('timeLoop');
        
        %% cosas del dibujo!
        set(handles.robotAxesLeft,'Visible','Off')
        set(handles.robotAxesRight,'Visible','Off')
        
        %% switch del gradoQ
        gradoQ=char(gradoLego);
        switch gradoQ
            case 'yaw'
                anguloMedido=exportarDatos('yaw');
                
            case 'pitch'
                anguloMedido =exportarDatos('pitch');
                anguloMedido.power=-anguloMedido.power;
                
            case 'roll'
                anguloMedido =exportarDatos('roll');
        end
        
        engranes= relacionEngranes.(gradoQ);
        constantesPID=constantesPID.(gradoQ);
        
        %% dibujando!
        axes(handles.robotAxes)
        gradoQPlot(timeLoop,gradoQ,anguloMedido,engranes,constantesPID)
        
    otherwise
        disp(modoLego)
        disp('Modo desconocido en robotPlot!')
end

cd('C:\Users\z_tja\OneDrive\TESIS\LEGO MYO')

end
