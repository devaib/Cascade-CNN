close all; clear all; clc;
pkg load image;

simplestColorBalance('./38.png', './38_enhanced.png', .01, 1);
pause
