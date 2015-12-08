#include <stdlib.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
// #include "/Users/wbh/cnn/24cnet/singletest/24CLayer.c"
// #include "/home/binghao/cnn/24net/singletest/24Layer.c"

#define min(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a < _b ? _a : _b;})
#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})

float* CaliLayer24(float img[][24], int height, int width, int channels);

int main(void){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    float mean_x;
    float mean_x2;
    float std = 0.0;
    float res;
    int i, j, k;

    // load the image
    // char file[] = "/Users/wbh/cnn/test/c_faces/pic00008.jpg";
    char file[] = "/home/binghao/cnn/test/1/14_1_111.jpg";
    
    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        exit(1);
    }

    // initialize dstImg
    dstImg = cvCreateImage(cvSize(24, 24), IPL_DEPTH_8U, 1);
    cvResize (srcImg, dstImg, CV_INTER_AREA);

    width = dstImg -> width;
    height = dstImg -> height;
    step = dstImg -> widthStep;
    channels = dstImg -> nChannels;
    data = (uchar*) dstImg -> imageData;

    // processing a 12*12 image
    float img[24][24];
    mean_x = 0.0;
    mean_x2 = 0.0;

    for (i = 0; i < 24; i++){
        for (j = 0; j < 24; j++){
            img[i][j] = (float)data[(i)*step + (j)*channels] / 255.0;
            mean_x += img[i][j];
            mean_x2 += pow(img[i][j], 2);
        }
    }

    mean_x /= 576.0;
    mean_x2 /= 576.0;
    std = sqrt(mean_x2 - pow(mean_x, 2));
    for (i = 0; i < 24; i++){
        for (j = 0; j < 24; j++){
            img[i][j] -= mean_x;
            img[i][j] /= std;
            // printf("img[%d][%d] = %f\n", i, j, img[i][j]);
        }
    }
    
    float *out_24c;
    out_24c = CaliLayer24(img, height, width, channels);

    printf("out1: %f, out2: %f, out3: %f\n", out_24c[0], out_24c[1], out_24c[2]);

    free(out_24c);

    cvNamedWindow("win1", CV_WINDOW_AUTOSIZE);
    cvShowImage("win1", dstImg);
    cvWaitKey(0);

    return 0;
}
