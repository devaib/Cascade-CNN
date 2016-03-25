close all
clear all
a1=csvread('distsCLASS1.csv')';
a2=csvread('distsCLASS2.csv')';
a3=csvread('distsCLASS3.csv')';
a4=csvread('distsCLASS4.csv')';
a5=csvread('distsCLASS5.csv')';
a6=csvread('distsCLASS6.csv')';

a1=exp(a1);
a2=exp(a2);
a3=exp(a3);
a4=exp(a4);
a5=exp(a5);
a6=exp(a6);

labelstring={'Closed','Down','Left','Open','Right','Up'}
nbins=100;
figure
subplot (6,1,1)
hist(a1,100)
title('Closed')
subplot (6,1,2)
hist(a2,100)
title('Down')
subplot (6,1,3)
hist(a3,100)
title('Left')
subplot (6,1,4)
hist(a4,100)
title('Open')
subplot (6,1,5)
hist(a5,100)
title('Right')
subplot (6,1,6)
hist(a6,100)
title('Up')


R=reshape(csvread('feature1R.csv'),38,45,1);
G=reshape(csvread('feature1G.csv'),38,45,1);
B=reshape(csvread('feature1B.csv'),38,45,1);
im=cat(3,R,G);
im=cat(3,im,B);
figure
imagesc(10*(im-min(min(min(im)))))