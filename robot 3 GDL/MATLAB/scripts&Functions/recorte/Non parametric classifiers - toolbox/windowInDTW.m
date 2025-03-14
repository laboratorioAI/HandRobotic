clc;
close all;
clear all;
warning off all;

m = 400; % window observation length
n = 200; % reference signal length
w = 50;  % window for DTW
w = max(w, abs(m - n));

img = zeros(m, n);
for i = 1:m
    for j = 1:n
        if abs(i - j) <= w
            img(i, j) = 1;
        end
        if i == j
            img(i, j) = 0;
        end
    end
end
figure(1);
imshow(img);
xlabel('Reference signal');
ylabel('Window observation length');