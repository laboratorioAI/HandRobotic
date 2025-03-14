clc;
close all;
clear all;
warning off all;

fs = 1000; % Hz
t = 0.1; % seconds
t = linspace(0, t, 500*t*fs); % time vector

% Reference signal
fr = 100;
sr = sin(2*pi*fr*t);

% Signal 1
f1 = 200;
s1 = sin(2*pi*f1*t);

% Signal 2
f2 = 250;
s2 = sin(2*pi*f2*t);

figure(1);
subplot(3, 1, 1);
plot(t, sr);
title('sr');

subplot(3, 1, 2);
plot(t, s1);
title('s1');

subplot(3, 1, 3);
plot(t, s2);
title('s2');
