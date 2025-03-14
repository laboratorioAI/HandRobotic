function usuarioButtonGUI (handles)
global datosUsuario isConnectedMyo flags
flags.reconocer=0;

if isConnectedMyo
    usuarioGUI=usuario;
    uiwait(usuarioGUI)
    
    
    
    if datosUsuario.usuarioValidoFlag==0
        uiwait(msgbox({'Problemas con el usuario.','Intente de nuevo'},'Mensaje','modal'));
        
        
    else
        datosUsuario=rmfield(datosUsuario,'usuarioValidoFlag'); % remuevo campo intermediario
        set(handles.usuarioText,'String',['Bienvenido ' char(datosUsuario.nombreUsuario)])
        set ( handles.mensajesTextBox , 'String' , 'Usuario encontrado')
        set(handles.verUsuarioButton,'Enable','on')
        set(handles.usuarioButton,'String','Cambiar Usuario')
        
        % habilitando clasificación!
        set(handles.iniciarButton,'Enable','on')
        
    end
    
    
    
else
    errordlg('Myo Armband no conectado!', 'Error MYO', 'modal');
    
end

end
