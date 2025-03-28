function dibujarGUI_CNN(handles, gestoReconocido, flags, myoObject)
    global axesGesto YPRang

    % Dibujar gesto en la interfaz de usuario
    % Dependiendo del gesto, mostrar la imagen y el nombre del gesto
    disp('Reconociendo gesto...');
    disp(['Gesto reconocido: ', num2str(gestoReconocido)]);

    % Verificar si el gesto es un número válido
    if isnumeric(gestoReconocido) && gestoReconocido ~= 0
        % Obtener el nombre del gesto y verificar la imagen
        % nombreGestoRespuesta = reconocimientoConfiguracion.nameGestures{gestoReconocido};
        nombreGestoRespuesta=reconocimientoConfiguracion.nameGestures{6};

        % Mostrar el nombre del gesto
        disp(['Nombre del gesto: ', nombreGestoRespuesta]);

        % Intentar cargar la imagen asociada al gesto
        try
            % Cargar la imagen del gesto
            %imagenGesto = reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);
            imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);

            % Verificar si la imagen está cargada correctamente
            if isempty(imagenGesto)
                error('La imagen para el gesto no está definida correctamente.');
            else
                % Verificar si la imagen está en formato correcto
                if size(imagenGesto, 3) == 1
                    % Si es en escala de grises, convertir a RGB
                    imagenGesto = repmat(imagenGesto, [1, 1, 3]);
                end

                % Actualizar la interfaz con el nombre y la imagen
                set(handles.tituloGestoText, 'String', nombreGestoRespuesta);
                axesGesto.CData = imagenGesto;  % Mostrar la imagen en el gráfico
            end
        catch ME
            % Manejo de errores si la imagen no se puede cargar
            disp(['Error al cargar la imagen: ', ME.message]);

            % Mostrar una imagen vacía (negra) si hay un error
            axesGesto.CData = zeros(size(axesGesto.CData));
            set(handles.tituloGestoText, 'String', 'Error al cargar imagen');
        end

        % Actualizar la variable de datos de usuario con el gesto reconocido
        flags.gestoRespuesta = gestoReconocido;
        flags.gestoDibujado = true;
    else
        % Si no se ha reconocido un gesto, mostrar "Reconociendo..."
        set(handles.tituloGestoText, 'String', 'Reconociendo...');
        axesGesto.CData = zeros(size(axesGesto.CData)); % Imagen vacía
    end
end
