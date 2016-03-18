clear all; close all; clc;
pkg load image;

function eng = energy(im)
    eng = sum(sum(im.^2))
endfunction

function entro = entropy(im)
    entro = sum(sum(im.*log(im)))
endfunction

function contra = contrast(im)
    summ = 0;
    for i = 1 : size(im, 1)
        for j = 1 : size(im, 2)
            summ = summ + (i-j).^2 * im(i, j)
        end
    end
    contra = summ
endfucntion

%{
function homo = homogeneity(im)
    summ = 0;
    for i = 1 : size(im, 1)
        for j = 1 : size(im, 2)
            summ = summ + double(im(i, j)) / (1 + abs(i-j))
        end
    end
    homo = summ
endfunction
%}

img = imread('./0.png');
img = rgb2gray(img);
imshow(img)
img = cast(img, 'double');

eng = energy(img)
entro = entropy(img)
contra = contrast(img)
% homo = homogeneity(img)

pause()

