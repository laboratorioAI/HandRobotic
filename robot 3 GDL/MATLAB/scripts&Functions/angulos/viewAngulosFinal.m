% ánalisis de conversion! basado en medicionAngulosMov! se incluye vista de
% la matriz de rotación
% problemas con la rotación de ejes!
% clear all, close all

% problemas de tiempo!
tiempoMovSegundos = 10; % para los tres mov!!!
% tiempoMuestreo = 0.1; % para los tres mov!!!

%% def
grados = {'yaw','pitch','roll'};


%% origen
ubicacionFolder = '.\scripts&Functions\medicionAngulosControl\';
nombreArchivoOrigen = 'finalMov.mat';

% nombreArchivoOrigen = 'movMainlyPitch.mat';

%% load movimiento.mat

load([ubicacionFolder nombreArchivoOrigen]);

%%

%% loop
kEjecuciones = size(movimiento.rot,3);




% conversión a gradoQ sin rotación de ref.
for kMuestra = 1:kEjecuciones
    matrizRot = movimiento.rot(:,:,kMuestra);
    
    if kMuestra == 1
        kMuestra
        orientacion = initOrientacion(matrizRot);
    end
    %% peter
    %     [q1 ,q2, q3] = matrizRot2ang(matrizRot,'RxyzPeter');
    %     vectorQ = [q1 ,q2, q3];
    %t
    [orientacion] = rotMatrix2angNoProble(matrizRot,orientacion);
    
    [yaw,pitch,roll] = salidaAngulos ( orientacion ) ;
    angulo.raw.yaw(kMuestra) = yaw ;
    angulo.raw.pitch(kMuestra) = pitch ;
    angulo.raw.roll(kMuestra) = roll ;
end




%% dibujar!

% acomodo del tiempo
tiempoVector = (1:kEjecuciones) / kEjecuciones * tiempoMovSegundos;

curvaMovFig = figure;
% subplot(1,2,1)

% acomodo del tiempo
plot(tiempoVector,angulo.raw.yaw)
hold on
plot(tiempoVector,angulo.raw.pitch)
plot(tiempoVector,angulo.raw.roll)


% curvaMovAxes.Title.String = 'movimiento del brazo';
grid on
xlabel('Tiempo [segundos]');
legend('yaw','pitch','roll')
%
%
% subplot(1,2,2)
%
% % acomodo del tiempo
% plot(tiempoVector,angulo.rotacionEjes.yaw)
% hold on
% plot(tiempoVector,angulo.rotacionEjes.pitch)
% plot(tiempoVector,angulo.rotacionEjes.roll)
%
%
% curvaMovAxes.Title.String = 'movimiento del brazo';
% grid on
% xlabel('Tiempo [segundos]');
% legend('yaw','pitch','roll')
