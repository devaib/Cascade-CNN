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
    int height, width, src_step, dst_step, channels;
    uchar *data;
    int i, j, k;
    const int Stride = 200;     // slide stride
    const int Size = 200;       // dst image size

    src = cvLoadImage(argv[1], CV_LOAD_IMAGE_ANYCOLOR);
    if (!src){
        printf("Could not load image file: %s\n", argv[1]);
        exit(0);
    }

    width = src -> width;
    height = src -> height;
    src_step= src -> widthStep;
    channels = src -> nChannels;
    data = (uchar*) src -> imageData;


    dst = cvCreateImage(cvSize(Size, Size), src -> depth, src -> nChannels);
    dst_step= dst -> widthStep;

    int row, col;
    int img[Size][Size];
    for (row = 0; row + Size <= height; row += Stride){
        for (col = 0; col + Size <= width; col += Stride){
            for (i = 0; i < Size; i++){
                for (j = 0; j < Size; j++){
                    for (k = 0; k < channels; k++){
                        dst -> imageData[i*dst_step + j*channels + k] = data[(i+row)*src_step + (j+col)*channels + k];
                    }
                }
            }
            printf("row: %d, col: %d, width: %d, height: %d\n", row, col, width, height);

            cvNamedWindow("win1", CV_WINDOW_AUTOSIZE);
            cvMoveWindow("win1", 100, 100);
            cvRectangle(src, cvPoint(col, row), cvPoint(col+200, row+200), cvScalar(255, 0, 0, 0), 2, 4, 0);
            cvShowImage("win1", src);

            cvNamedWindow("win2", CV_WINDOW_AUTOSIZE);
            cvMoveWindow("win2", 500, 500);
            cvShowImage("win2", dst);

            cvWaitKey(500);

        }
    }
    cvDestroyWindow("win1");
    cvDestroyWindow("win2");

    return 0;
}
