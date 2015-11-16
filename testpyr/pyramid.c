#include <stdio.h>
#include <stdlib.h>
#include <cv.h>
#include <highgui.h>

IplImage* doPyrDown(IplImage *src){
    IplImage *result = cvCreateImage(cvSize(src -> width / 2, src -> height / 2), src -> depth, src -> nChannels);
    cvPyrDown(src, result, CV_GAUSSIAN_5x5);

    return result;
}

int main(int argc, char *argv[]){
    IplImage *src;
    IplImage *dst;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;

    src = cvLoadImage(argv[1], CV_LOAD_IMAGE_ANYCOLOR);
    if (!src){
        printf("Could not load image file: %s\n", argv[1]);
        exit(0);
    }


    const int MinImageSize = 10;
    while (src -> width >= MinImageSize){
        cvNamedWindow("win1", CV_WINDOW_AUTOSIZE);

        width = src -> width;
        height = src -> height;
        step = src -> widthStep;
        channels = src -> nChannels;
        data = (uchar*) src -> imageData;

        cvShowImage("win1", src);
        cvWaitKey(1000);

        cvDestroyWindow("win1");

        dst = doPyrDown(src);
        src = dst;
    }
    return 0;
}
