

%% dibujar!

% acomodo del tiempo
tiempoVector = (1:kEjecuciones-1) / kEjecuciones * tiempoMovSegundos;

curvaMovFig = figure;
% subplot(1,2,1)

% acomodo del tiempo
yaw = angulo.raw.yaw;
pitch = angulo.raw.pitch;
roll=angulo.raw.roll;
plot(tiempoVector,yaw(1:end-1)-yaw(2:end))
hold on
plot(tiempoVector,pitch(1:end-1)-pitch(2:end))
plot(tiempoVector,roll(1:end-1)-roll(2:end))


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