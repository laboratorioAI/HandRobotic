function datosUsuario=construccionDatabase(datosUsuario,reconocimientoConfiguracion)
%  VERSION GUI final, 8/jun/2017
% Construye una matriz con las señales EMG filtradas conteniendo todos los
% gestos grabados. Los gestos son grabados en el mismo archivo del nombre
% del usuario.Los valores del filtro son leídos de la variable reconocimientoConfiguracion
% La base de datos se almacena como un campo de la estructura datosUsuario.
% en la carpeta usersData. 


%% Valores predefinidos
    numRepeticiones=datosUsuario.numRepeticiones; % número de repeticiones del usuario
    nombreUsuario=datosUsuario.nombreUsuario; % número de repeticiones del usuario
    
    numGestos=reconocimientoConfiguracion.numGestures; % número de gestos grbados
    nombreGestos=reconocimientoConfiguracion.nameGestures; % celda con los nombres de los gestos
    Fb=reconocimientoConfiguracion.Fb; % valores del filtro
    Fa=reconocimientoConfiguracion.Fa;

    database=cell(numGestos*numRepeticiones,8);

    
for i=1:numGestos
    % Lazo por gesto
    kNombreGesto=char(nombreGestos(i));
%     signalGesto=datosUsuario.gestos.(kNombreGesto).emg;
%     load([nameUser kNombreGesto '.mat']);
    
    for j=1:numRepeticiones
        % Loop per number of repetitions
        signalGesto=datosUsuario.gestos.(kNombreGesto).emg{j};       
        
        
        %% building database
        for k=1:8
            % Loop per channel
            unknownGesture = filtfilt(Fb, Fa,abs(signalGesto(:,k)) ); % filtered absolute value
            database{(i-1)*5+j,k}=unknownGesture;
        end
    end
end
datosUsuario.database=database;
save (['usersData\' nombreUsuario '.mat'],'datosUsuario')
beep
end