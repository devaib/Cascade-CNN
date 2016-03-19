clear all; close all; clc;
%load pkg image;

srcFiles = dir('/Users/wbh/Desktop/img/*.jpg');

engs = [];
entros = [];
contras = [];
homos = [];

for i = 1 : length(srcFiles)
    filename = strcat('/Users/wbh/Desktop/img/', srcFiles(i).name);
    
    img = imread(filename);
    img = rgb2gray(img);
    imshow(img)
    img = cast(img, 'double');

    eng = energy(img);
    entro = entropy(img);
    contra = myContrast(img);
    homo = homogeneity(img);
    
    engs = [engs eng];
    entros = [entros entro];
    contras = [contras contra];
    homos = [homos homo];
    
end

close all; 
