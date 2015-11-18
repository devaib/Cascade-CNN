#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>
#include "/Users/wbh/cnn/resize/firstLayer.c"
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
    do{ //Move back and insert digits
        *--p = digit[i%10];
        i = i/10;
    }while(i);
    return b;
}

int main( void ){ 
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;
    float mean_x = 0.0;
    float mean_x2 = 0.0;
    float std = 0.0;
    int faces = 0;
    int nonfaces = 0;

    char path[50];
    char file[50];
    strcpy(path, "/Users/wbh/cnn/test/c_faces/pic");
    // strcpy(path, "/Users/wbh/cnn/test/nonfaces/4");

    char *suffix = ".jpg";
    char imgNum[10];
    char *num;
    strcat(path, imgNum);

    int loop;
    int digits;

    for (loop = 1; loop < 14266; loop++){
    // for (loop = 1; loop < 8620; loop++){

    strcpy(file, path);
    digits = (int)log10f((float)loop);
    
    // add the zeros in the filename(for c_faces)
    while (digits < 5 - 1){
        num = itos(0, imgNum);
        strcat(file, num);
        digits++;
    }

    /*
    // add zeros in the filename(for nonfaces)
    while (digits < 4 - 1){
        num = itos(0, imgNum);
        strcat(file, num);
        digits++;
    }
    */

    num = itos(loop, imgNum);
    strcat(file, num); 
    strcat(file, suffix); 
    printf("%d%% tested, testing on %s\n", (int)((float)loop/14266*100), file);

    // load an image
    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    dstImg = cvCreateImage(cvSize(12, 12), IPL_DEPTH_8U, 1);
    if (!srcImg){
        printf("Could not load image file: %s\n", file); 
        continue;
    }

    // void cvPyrDown(srcImg, dstImg, IPL_GAUSSIAN_5*5);
    cvResize(srcImg, dstImg, CV_INTER_AREA);
    step = dstImg -> widthStep;
    channels = srcImg -> nChannels;
    data = (uchar*) dstImg-> imageData;
    float img[12][12];
    for (i = 0; i < 12; i++){
        for (j = 0; j < 12; j++){
            img[i][j] = data[i*step + j*channels] / 255.0;
            mean_x += img[i][j];
            mean_x2 += pow(img[i][j], 2);
        }
    }
    mean_x /= 144.0;
    mean_x2 /= 144.0;
    std = sqrt(mean_x2 - pow(mean_x, 2));
    for (i = 0; i < 12; i++){
        for (j = 0; j < 12; j++){
            img[i][j] -= mean_x;
            img[i][j] /= std;
            // printf("img[%d][%d] = %f\n", i, j, img[i][j]);
        }
    }

    float res;
    res = firstLayer(img, 12, 12, channels);
    // cvSaveImage("/home/binghao/cnn/cat.jpg", dstImg, 0);
    
    if (res > 0.5){
        faces++;

    }else{
        nonfaces++;
    }
    }

    printf("-----------------------------\n");
    float ratio = (float)faces / ((float)faces + (float)nonfaces);
    printf("object detected: %d out of %d, correct ratio: %.2f%%", faces, faces + nonfaces, ratio*100);

    return 0;
}

