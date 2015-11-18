#include <stdlib.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include "/Users/wbh/cnn/12test/firstLayer.c"
// #include "/home/binghao/cnn/12test/firstLayer.c"

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

// image pyramid
IplImage* doPyrDown(IplImage *src){
    IplImage* result = cvCreateImage(cvSize(src -> width / 2, src -> height / 2), src -> depth, src -> nChannels);
    cvPyrDown(src, result, CV_GAUSSIAN_5x5);

    return result;
}

int main(void){
    IplImage *srcImg;
    IplImage *dstImg;
    int height, width, step, channels;
    uchar *data;
    int i, j, k;
    float mean_x = 0.0;
    float mean_x2 = 0.0;
    float std = 0.0;

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

        // add zeros in the filename(for nonfaces)
        /*
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

        const int Stride = 4;
        int row, col;
        float img[12][12];
        mean_x = 0.0;
        mean_x2 = 0.0;
        
        // window sliding loop starts
        for (row = 0; row + 12 <= height; row += Stride){
            for (col = 0; col + 12 <= width; col += Stride){
                for (i = 0; i < 12; i++){
                    for (j = 0; j < 12; j++){
                        img[i][j] = data[(i+row)*step + (j+col)*channels] / 255.0;
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
                        //printf("img[%d][%d] = %f\n", i, j, img[i][j]);
                    }
                }
                printf("here\n");

                float res;
                printf("%d%% tested, testing on image %s\n", (int)((float)loop*100/14266), file);
                printf("image size: %d, test on row: %d, col: %d\n", srcImg -> width, row, col);
                res = firstLayer(img, 12, 12, channels);
                
            }
        }   // window sliding loop ends

        // down pyramid
        dstImg = doPyrDown(srcImg);
        srcImg = dstImg;

        } // image pyramid loop ends

    } // image testset loop ends

    return 0;
}

