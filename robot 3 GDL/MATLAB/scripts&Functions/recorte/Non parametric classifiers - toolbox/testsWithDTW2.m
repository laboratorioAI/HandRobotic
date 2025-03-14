clc;
close all;
clear all;
warning off all;

tmax = 0.1;
fs = 20000;
t = linspace(0, tmax, round(fs*tmax));

s = sin(2*pi*10*t);
s1 = [zeros(1, 1000) s zeros(1, 200)]';
s2 = [zeros(1, 500) s zeros(1, 150)]';
s3 = [zeros(1, 150) s zeros(1, 500)]';

figure(1);
plot(s1);
hold all;
plot(s2);
plot(s3);
hold off;

w = 5e6;
dtw12 = dtw_c(s1, s2, w)*( max(CE(s1),CE(s2))/min(CE(s1),CE(s2)) );
dtw13 = dtw_c(s1, s3, w)*( max(CE(s1),CE(s3))/min(CE(s1),CE(s3)) );
dtw23 = dtw_c(s2, s3, w)*( max(CE(s2),CE(s3))/min(CE(s2),CE(s3)) );

strLegend{1} = 's1';
strLegend{2} = 's2';
strLegend{3} = 's3';
legend(strLegend);
strTitle{1} = ['dtw-12: ' num2str(dtw12)];
strTitle{2} = ['dtw-13: ' num2str(dtw13)];
strTitle{3} = ['dtw-23: ' num2str(dtw23)];
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