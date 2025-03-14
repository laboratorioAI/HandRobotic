function tiemposPlot()
global datosUsuario
% script para dibujar el vector de tiempos
plot(datosUsuario.tiempoClasificacionVector(2:end-1)) % tiempo clasificación
hold on
plot(datosUsuario.tiempoOcioVector(2:end-1)+datosUsuario.tiempoClasificacionVector(2:end-1)) % total! incluida la espera

plot([1 length(datosUsuario.tiempoOcioVector(2:end-1))], 0.3 * [1 1] ) % 300 milisegundos

legend({'TIEMPO CLASIFICACION','TIEMPO TOTAL'})
axis([1 length(datosUsuario.tiempoOcioVector(2:end-1 )) 0 0.5])
end