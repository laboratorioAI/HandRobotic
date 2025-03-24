%eval_realTime runs the model Model_spec_CNN_LSTM in real time without post-processing.

%{
Laboratorio de Inteligencia y Visión Artificial
ESCUELA POLITÉCNICA NACIONAL
Quito - Ecuador

autor: jonathan.zea
jonathan.a.zea@ieee.org

"I find that I don't understand things unless I try to program them."
-Donald E. Knuth

12 May 2023
%}

clear all
close all
clc
%% Configs
window_size = 300;
stride = 30;


%% Aux and dependent variables
% libs
addpath(genpath('MyoMex-master')) % or add your own path to MyoMex
period = 1/200* 30;

%%
myo = Myo();
model = Model_spec_CNN_LSTM();
% graph = EMG_plot(window_size);

%% loop
while true
    t = tic;
    emg = myo.load_EMG_window(window_size);
    class_pred = model.classify(emg);
    drawnow
    %     graph.update_emg(emg);
    drawnow
    rem = period - toc(t);
    Print(sprintf("%.2f %s\n", rem, class_pred(end)));
    
    pause(period - toc(t))
end