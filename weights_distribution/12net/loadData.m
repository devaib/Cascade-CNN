clear all; close all; clc;

file1 = 'convWeights.csv';
file2 = 'convBias.csv';
file3 = 'fcWeights1.csv';
file4 = 'fcBias1.csv';
file5 = 'fcWeights2.csv';
file6 = 'fcBias2.csv';

convWeights = csvread(file1);   convWeights = convWeights(:);
convBias = csvread(file2);      convBias = convBias(:);
fcWeights1 = csvread(file3);    fcWeights1 = fcWeights1(:);
fcBias1 = csvread(file4);       fcBias1 = fcBias1(:);
fcWeights2 = csvread(file5);    fcWeights2 = fcWeights2(:);
fcBias2 = csvread(file6);       fcBias2 = fcBias2(:);

figure(1), hist(convWeights, 25), title(['convWeights    #',num2str(size(convWeights,1))])
xmin =  min(convWeights);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-1,strmin,'HorizontalAlignment','left');
xmax =  max(convWeights);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-1,strmin,'HorizontalAlignment','left');

figure(2), hist(convBias, 5), title(['convBias    #',num2str(size(convBias,1))])
xmin =  min(convBias);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-.5,strmin,'HorizontalAlignment','left');
xmax =  max(convBias);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-.5,strmin,'HorizontalAlignment','left');

figure(3), hist(fcWeights1, 200), title(['fcWeights1    #',num2str(size(fcWeights1,1))])
xmin =  min(fcWeights1);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-15,strmin,'HorizontalAlignment','left');
xmax =  max(fcWeights1);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-15,strmin,'HorizontalAlignment','left');

figure(4), hist(fcBias1, 5), title(['fcBias1    #',num2str(size(fcBias1,1))])
xmin =  min(fcBias1);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-.25,strmin,'HorizontalAlignment','left');
xmax =  max(fcBias1);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-.25,strmin,'HorizontalAlignment','left');

figure(5), hist(fcWeights2, 5), title(['fcWeights2    #',num2str(size(fcWeights2,1))])
xmin =  min(fcWeights2);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-1,strmin,'HorizontalAlignment','left');
xmax =  max(fcWeights2);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-1,strmin,'HorizontalAlignment','left');

figure(6), hist(fcBias2, 5), title(['fcBias2    #',num2str(size(fcBias2,1))])
xmin =  min(fcBias2);
strmin = ['Minimum = ',num2str(xmin)];
text(xmin,-.05,strmin,'HorizontalAlignment','left');
xmax =  max(fcBias2);
strmin = ['Minimum = ',num2str(xmax)];
text(xmax,-.05,strmin,'HorizontalAlignment','left');






