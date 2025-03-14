clc;
close all;
clear all;
warning off all;

numChannels = 8;
numSamplesSignal = 180;
numSamplesWindow = 200;
numRepetitions = 1e4;
w = 50;

tMtx = 0;
tVect = 0;
t = linspace(0, 1, 1e5);
for iteration = 1:numRepetitions
    signal1 = sin(2*pi*randn*t);
    signal2 = sin(2*pi*randn*t);
    
    t0 = tic;
    dtwMtx = dtw_c(signal1, signal2, w);
    tMtx = tMtx + toc(t0);
    
    t0 = tic;
    dtwVect = 0;
    for channNum = 1:numChannels
        dtwVect = dtwVect + dtw_c(signal1(:, channNum), signal2(:, channNum), w);     
    end
    tVect = tVect + toc(t0);
end

fprintf('Time of processing the signals as a matrices: %f \n', tMtx);
fprintf('Time of processing the signals channel by channel: %f \n', tVect);
