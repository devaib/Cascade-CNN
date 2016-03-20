clear all; close all; clc;
%pkg load image

srcImage = imread('./38.png');
figure(1)
imshow(srcImage)

for factor = -255:10:255
    figure(2)
    dstImage = contrastEnhance(srcImage, factor);
%     dstImage = brightnessEnhance(srcImage, factor);
    imshow(dstImage)
    title(['factor = ', num2str(factor)])
    pause(.5)
end



%pause
