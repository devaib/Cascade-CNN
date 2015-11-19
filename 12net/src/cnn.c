#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>
#include "/Users/wbh/cnn/12net/src/firstLayer.c"
// #include "/home/binghao/cnn/src/firstLayer.c"

int main( int argc, char *argv[] ){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;
    float mean_x = 0.0;
    float mean_x2 = 0.0;
    float std = 0.0;

    if ( argc < 2 ){
        printf("No image file\n");
        exit(0);
    }

    // load an image
    srcImg = cvLoadImage(argv[1], CV_LOAD_IMAGE_GRAYSCALE);
    dstImg = cvLoadImage(argv[1], CV_LOAD_IMAGE_GRAYSCALE);
    if ( !srcImg){
        printf("Could not load image file: %s\n", argv[1]);
        exit(0);
    }

    // get the image data
    width = srcImg -> width;
    height = srcImg -> height;
    step = srcImg -> widthStep;
    channels = srcImg -> nChannels;
    data = (uchar*) srcImg -> imageData;

    float img[width][height];

    // create a window
    cvNamedWindow("mainWin1", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("mainWin1", 100, 100);
    cvNamedWindow("mainWin2", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("mainWin2", 500, 100);

    // read the image into img
    for (i = 0; i < height; i++){
        for (j = 0; j < width; j++){
            img[i][j] = data[ i*step + j*channels] / 255.0;
            mean_x += img[i][j];
            mean_x2 += pow(img[i][j], 2);
        }
    }
    mean_x /= 144.0;
    mean_x2 /= 144.0;
    std = sqrt(mean_x2 - pow(mean_x, 2));
    for (i = 0; i < height; i++){
        for (j = 0; j < width; j++){
            img[i][j] -= mean_x;
            img[i][j] /= std;
            // printf("img[%d][%d] = %f\n", i, j, img[i][j]);
        }
    }

    /*
    for (i = 0; i < height; i++){
        for (j = 0; j < width; j++){
            printf("img[%d][%d] = %d\n", i, j, img[i][j]);
        }
    }
    */

    float res;
    res = firstLayer(img, height, width, channels);

    // printf("Image size: %d x %d, channels: %d, step: %d\n", width, height, channels, step);

    // show the image
    cvShowImage("mainWin1", srcImg);
    cvShowImage("mainWin2", dstImg);
    
    // wait for a key
    cvWaitKey(0);

    // release the images
    cvReleaseImage(&srcImg);
    cvReleaseImage(&dstImg);

    // destroy the windows
    cvDestroyWindow("mainWin1");
    cvDestroyWindow("mainWin2");

    return 0;
}

