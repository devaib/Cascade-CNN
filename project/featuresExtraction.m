clear all; close all; clc;
pkg load image;

img = imread('./2.png');
img = rgb2gray(img);
imshow(img)
img = cast(img, 'double');

eng = energy(img)
entro = entropy(img)
contra = myContrast(img)
homo = homogeneity(img)

pause

