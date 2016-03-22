close all; clear all; clc;
pkg load image;

simplestColorBalance('./38.png', './38_enhanced.png', 0.3, 1);
pause
