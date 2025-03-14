clc;
close all;
clear all;
warning off all;

% Time and sampling frequency
tmax = 0.25;
fs = 20000;
t = linspace(0, tmax, round(fs*tmax));

% Signals
s1 = sin(2*pi*10*t + pi/8);
s2 = sin(2*pi*10*t);
s3 = sin(2*pi*10*t + pi);


% DTW distance in C
w = 5e10;
tic;
dtw12_c = dtw_c(s1, s2, w)%*( max(CE(s1),CE(s2))/min(CE(s1),CE(s2)) );
t_progC = toc
dtw13_c = dtw_c(s1, s3, w);%*( max(CE(s1),CE(s3))/min(CE(s1),CE(s3)) );
dtw23_c = dtw_c(s2, s3, w);%*( max(CE(s2),CE(s3))/min(CE(s2),CE(s3)) );

% My DTW distance
tic;
dtw12_m = myDTW(s1, s2)%*( max(CE(s1),CE(s2))/min(CE(s1),CE(s2)) );
t_progM1 = toc
dtw13_m = myDTW(s1, s3);%*( max(CE(s1),CE(s3))/min(CE(s1),CE(s3)) );
dtw23_m = myDTW(s2, s3);%*( max(CE(s2),CE(s3))/min(CE(s2),CE(s3)) );

tic;
d = dtw_m(s1, s2, w)
t_progM2 = toc

% Plotting the signals and showing the distance values
figure;
plot(t, s1);
hold all;
plot(t, s2);
plot(t, s3);
hold off;
strLegend{1} = 's1';
strLegend{2} = 's2';
strLegend{3} = 's3';
legend(strLegend);
strTitle{1} = ['dtw-12_c: ' num2str(dtw12_c) ', dtw-12_m: ' num2str(dtw12_m)];
strTitle{2} = ['dtw-13_c: ' num2str(dtw13_c) ', dtw-13_m: ' num2str(dtw13_m)];
strTitle{3} = ['dtw-23_c: ' num2str(dtw23_c) ', dtw-23_m: ' num2str(dtw23_m)];
title(strTitle);

figure;
dtw(s1, s2, 'absolute')
title('s_1 vs. s_2');

figure;
dtw(s1, s3, 'absolute')
title('s_1 vs. s_3');

figure;
dtw(s2, s3, 'absolute')
title('s_2 vs. s_3');