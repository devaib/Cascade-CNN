#include <stdlib.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include "/Users/wbh/cnn/24net/singletest/24Layer.c"

#define min(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a < _b ? _a : _b;})
#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})

int main(void){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    float mean_x;
    float mean_x2;
    float std = 0.0;
    float res;

    // load the image
    char file = "/Users/wbh/cnn/24net/singletest/1.jpg";
    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        exit(1);
    }

    width = srcImg -> width;
    height = srcImg -> height;
    step = srcImg -> widthStep;
    channels = srcImg -> nChannels;
    data = (uchar*) srcImg -> imageData;

    // processing a 12*12 image
    int row, col;
    float img[12][12];



}
