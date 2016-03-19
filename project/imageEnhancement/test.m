pkg load image

srcImage = imread('/home/binghao/Desktop/0.png');
imshow(srcImage)
dstImage = contrastEnhance(srcImage, 200);
imwrite(dstImage, '/home/binghao/Desktop/0_1.png')


pause
