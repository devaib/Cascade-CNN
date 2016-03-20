clear all; close all; clc;
pkg load image;

x = 0:255;
y = 20 .* (x - 128) + 128;
plot(x, y)

pause
