#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
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

IplImage* doPyrDown(IplImage* src){
    IplImage* result = cvCreateImage(cvSize(src -> width/2, src -> height/2), src -> depth, src -> nChannels);
    cvPyrDown(src, result, CV_GAUSSIAN_5x5);

    return result;
}

int main(void){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;

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

    // image test loop starts
    for (loop = 1; loop < 14266; loop++){           // c_faces
    // for (loop = 1; loop < 8620; loop++){         // nonfaces
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
        printf("%s\n",file);
    

    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    // dstImg = cvCreateImage(cvSize(12, 12), IPL_DEPTH_8U, 1);
    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        continue;
    }

    // image pyramid loop starts
    const int MinImageSize = 16;
    while (srcImg -> width >= MinImageSize){     
        
        // get the image data
        width = srcImg -> width;
        height = srcImg -> height;
        step = srcImg -> widthStep;
        channels = srcImg -> nChannels;
        data = (uchar*) srcImg -> imageData;

        const int PixelSpacing = 4;
        int row, col;
        int img[12][12];
        
        // window sliding loop starts
        for (row = 0; row + 12 <= width; row += PixelSpacing){
            for (col = 0; col + 12 <= height; col += PixelSpacing){
                for (i = 0; i < 12; i++){
                    for (j = 0; j < 12; j++){
                        img[i][j] = data[(i+row)*step + (j+col)*channels];
                    }
                }
                int res;
                printf("%d%% tested, testing on image %s\n", (int)((float)loop*100/14266), file);
                printf("image size: %d, test on row: %d, col: %d\n", srcImg -> width, row, col);
                res = firstLayer(img, 12, 12, channels);
                // cvSaveImage("/home/binghao/cnn/cat.jpg", dstImg, 0);
            }
        }   // window sliding loop ends

        // pyramid down
        dstImg = doPyrDown(srcImg);
        srcImg = dstImg;

        } // image pyramid loop ends

    } // image testset loop ends

    return 0;
}

