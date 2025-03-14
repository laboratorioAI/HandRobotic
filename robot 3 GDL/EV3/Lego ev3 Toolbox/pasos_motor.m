% clear all;close all; warning off all; 
clc;

%% Para conectar uncomment las siguientes líneas.
% b = Brick('ioType','instrbt','btDevice','EV3','btChannel',1)
% beep to indicate connection

b.beep();


angleA = [10 -10 20 -20 30 -30];
speedA = 20;

angleB = [10 -10 20 -20 30 -30];
speedB = 20;

for ii=1:length(angleA)
    % move motor A
    b.outputStepSpeed(0,Device.MotorA,sign(angleA(ii))*speedA,0,angleA(ii),0,Device.Brake)
    % move motor B    
   
    % wait until motor A has moved
    while(b.outputTest(0,Device.MotorA))
        pause(1)
    end 
    b.outputStepSpeed(0,Device.MotorB,sign(angleB(ii))*speedB,0,angleB(ii),0,Device.Brake) 
     while(b.outputTest(0,Device.MotorB))
        pause(0.1)
    end 
end