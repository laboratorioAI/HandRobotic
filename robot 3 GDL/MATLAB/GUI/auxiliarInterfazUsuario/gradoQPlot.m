function gradoQPlot(timeLoopLego,gradoQ,anguloMedido,relacionEngranes,constantesPID)
% dibuja la maravilla de resultado sobre el gradoQ

diffTiempo=timeLoopLego(2:end)-timeLoopLego(1:end-1);
disp(mean(diffTiempo));
% 
% timeLoopLego=timeLoopLego(2:end-1)-timeLoopLego(2);
% 
% ref=anguloMedido.ref(2:end-1);
% power=anguloMedido.power(2:end-1);
% real=anguloMedido.real(2:end-1);

ref=anguloMedido.ref;
power=anguloMedido.power;
real=anguloMedido.real;

% Las tres señales mágicas!
plot(timeLoopLego,ref/relacionEngranes)
hold on
% plot(timeLoopLego,power)
plot(timeLoopLego,real/relacionEngranes)

% legend({['ref' gradoQ],['power' gradoQ],gradoQ})

% dentro del margen de lo aceptable, +-5
% plot(timeLoopLego,ref/relacionEngranes+5 ,'--')
% plot(timeLoopLego,ref/relacionEngranes-5 ,'--')
plot([timeLoopLego(1) timeLoopLego(end)],[0 0],':')

% cosas de forma!
xlabel('Tiempo [s]')

title([gradoQ '. Kp: ', num2str(constantesPID(1)),...
    ', Ki: ', num2str(constantesPID(2)) ', Kd: ', num2str(constantesPID(3))])

%% en el caso de querer más acción
% figure
% plot(diffTiempo)
% hold on
% plot([1 length(timeLoopLego)-1],[0.2 0.2])
% plot(timeLoopLego)
end