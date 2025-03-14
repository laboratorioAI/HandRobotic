clc;
close all;
clear all;
warning off all;

thresh = [1 1 1 1 1]
theshAux = [0, thresh, 0];
diffThresh = abs( diff(theshAux) )