#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include "/Users/wbh/cnn/12test/firstLayer.c"
// #include "/home/binghao/cnn/resize/firstLayer.c"

char* itos(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
        i = i/10;
    }while(i);
    return b;
}

int main(void){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;

    /*
    if ( argc < 2 ){
        printf("No image file\n");
        exit(0);
    }
    */

    // load an image
    // srcImg = cvLoadImage(argv[1], CV_LOAD_IMAGE_ANYCOLOR);
    // dstImg = cvLoadImage(argv[1], CV_LOAD_IMAGE_ANYCOLOR);
    char path[50];
    char file[50];
    strcpy(path, "/Users/wbh/cnn/test/c_faces/pic");

    char *suffix = ".jpg";
    char imgNum[10];
    char *num;
    strcat(path, imgNum);

    // loop over test data set
    int loop;
    int digits;
    for (loop = 1; loop < 14266; loop++){
        strcpy(file, path);
        // add the zeros in the filename
        digits = (int)log10f((float)loop);
        while (digits < 5 - 1){
            num = itos(0, imgNum);
            strcat(file, num);
            digits++;
        }
        num = itos(loop, imgNum);
        strcat(file, num); 
        strcat(file, suffix); 
        printf("%s\n", file);
    

    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    dstImg = cvCreateImage(cvSize(12, 12), IPL_DEPTH_8U, 1);
    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        continue;
    }

    /*
    // get the image data
    width = srcImg -> width;
    height = srcImg -> height;
    step = srcImg -> widthStep;
    channels = srcImg -> nChannels;
    data = (uchar*) srcImg -> imageData;
    printf("Image size: %d x %d, channels: %d, step: %d\n", width, height, channels, step);
    */

    /*
    // create a window
    cvNamedWindow("mainWin1", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("mainWin1", 100, 100);
    cvNamedWindow("mainWin2", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("mainWin2", 500, 100);
    */

    /*
    // invert the image (loop order: height ==> width ==> channels)
    for (i = 0; i < height; i++)
        for (j = 0; j < width; j++)
            for (k = 0; k < channels; k++)
                dstImg -> imageData[i*step + j*channels + k] = data[i*step + j*channels + k] - 30;
    */

    // void cvPyrDown(srcImg, dstImg, IPL_GAUSSIAN_5*5);
    cvResize(srcImg, dstImg, CV_INTER_AREA);
    step = dstImg -> widthStep;
    channels = srcImg -> nChannels;
    data = (uchar*) dstImg-> imageData;
    int img[12][12];
    for (i = 0; i < 12; i++){
        for (j = 0; j < 12; j++){
            img[i][j] = data[i*step + j*channels];
        }
    }
    int res;
    res = firstLayer(img, 12, 12, channels);
    // cvSaveImage("/home/binghao/cnn/cat.jpg", dstImg, 0);


    /*
    // show the image
    cvShowImage("mainWin1", srcImg);
    cvShowImage("mainWin2", dstImg);
    
    // wait for a key
    // cvWaitKey(0);

    // release the images
    cvReleaseImage(&srcImg);
    cvReleaseImage(&dstImg);

    // destroy the windows
    cvDestroyWindow("mainWin1");
    cvDestroyWindow("mainWin2");
    */

    break;
    }

    return 0;
}

