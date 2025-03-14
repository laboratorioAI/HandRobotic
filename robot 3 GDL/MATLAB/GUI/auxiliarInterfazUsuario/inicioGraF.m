% función para dibujar la primera vez  GUI
function inicioGraF(handles)
%% gesto cargado como noGesto
global axesGesto reconocimientoConfiguracion

nombreGestoRespuesta=reconocimientoConfiguracion.nameGestures{6};
imagenGesto=reconocimientoConfiguracion.imagenGesto.(nombreGestoRespuesta);

axes(handles.mainAxes)
axesGesto=image(imagenGesto,'Parent',handles.mainAxes);
axis off;


%% EMG
global myoObject datosUsuario
% lectura
emgPlot= myoObject.myoData.emg_log;
myoObject.myoData.clearLogs();

% recorte...
samplesLoop=length(emgPlot);

if samplesLoop>200*0.25 % se recorta la señal a .25 segundos
    samplesLoop=50;
end

% creando emgVector
datosUsuario.emgVector(end-samplesLoop+1:end,:) = emgPlot(end-samplesLoop+1:end,:);


% creando axes EMG
global emgAxes
emgAxes=cell(1,8);

for kCanal=1:8
    nombreAxes=['emg' num2str(kCanal) 'Axes'];
    emgAxes{kCanal}=plot(handles.(nombreAxes),datosUsuario.emgVector(:,kCanal));
    
    ylim(handles.(nombreAxes),[-1 1]);
    handles.(nombreAxes).XTick = [];
end


%% matriz de rotación
matrizRot = myoObject.myoData.rot;
[datosUsuario.orientacion] = rotMatrix2angNoProble(matrizRot,datosUsuario.orientacion);
matrizRotacion = datosUsuario.orientacion.matrizRot ;


% calculos
magX = sqrt(sum(matrizRotacion(:,1).^2));
magY = sqrt(sum(matrizRotacion(:,2).^2));
magZ = sqrt(sum(matrizRotacion(:,3).^2));
ux = matrizRotacion(1,1)/magX;
vx = matrizRotacion(2,1)/magX;
wx = matrizRotacion(3,1)/magX;
uy = matrizRotacion(1,2)/magY;
vy = matrizRotacion(2,2)/magY;
wy = matrizRotacion(3,2)/magY;
uz = matrizRotacion(1,3)/magZ;
vz = matrizRotacion(2,3)/magZ;
wz = matrizRotacion(3,3)/magZ;

% base
axes(handles.orientacionAxes)

plot3(0, 0, 0, 'ko','LineWidth',10);
hold on;
ejeX=quiver3(0, 0, 0, ux, vx, wx, 1, 'r', 'ShowArrowHead', 'off','LineWidth',3);
ejeY=quiver3(0, 0, 0, uy, vy, wy,  1,'g', 'ShowArrowHead', 'off','LineWidth',3);
ejeZ=quiver3(0, 0, 0, uz, vz, wz,  1,'b', 'ShowArrowHead', 'off','LineWidth',3);

% proyecciones
% proyección en plano z
xdeProZ=plot3([0 ux],[0 vx],[-3 -3],'r','linestyle','--');
ydeProZ=plot3([0 uy],[0 vy],[-3 -3],'g','linestyle','--');
zdeProZ=plot3([0 uz],[0 vz],[-3 -3],'b','linestyle','--');

% proyección en plano y
xdeProY=plot3([0 ux],[-3 -3],[0 wx],'r','linestyle','--');
ydeProY=plot3([0 uy],[-3 -3],[0 wy],'g','linestyle','--');
zdeProY=plot3([0 uz],[-3 -3],[0 wz],'b','linestyle','--');

% proyección en plano x
xdeProX=plot3([3 3],[0 vx],[0 wx],'r','linestyle','--');
ydeProX=plot3([3 3],[0 vy],[0 wy],'g','linestyle','--');
zdeProX=plot3([3 3],[0 vz],[0 wz],'b','linestyle','--');

% estructura
global orientacionGrafico
orientacionGrafico={ejeX,ejeY,ejeZ...
    ,xdeProX,xdeProY,xdeProZ...
    ,ydeProX,ydeProY,ydeProZ...
    ,zdeProX,zdeProY,zdeProZ...
    };

%% view
view([-120 30]); % funcional
% view([-90 30]); % funcional
grid on;
hold off;

axis([-3 3 -3 3 -3 3]);
xlabel('x_o')
ylabel('y_o')
zlabel('z_o','Rotation',0)
handles.orientacionAxes.XTick= [-3 -2 -1 0 1 2 3];
handles.orientacionAxes.YTick =[-3 -2 -1 0 1 2 3];
handles.orientacionAxes.ZTick= [-3 -2 -1 0 1 2 3];
%
handles.orientacionAxes.XTickLabel = {'','','-u','','u','',''};
handles.orientacionAxes.YTickLabel = {'','','-u','','u','',''};
handles.orientacionAxes.ZTickLabel = {'','','-u','','u','',''};

end

