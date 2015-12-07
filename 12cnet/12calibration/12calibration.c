#include <stdlib.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
//#include "/Users/wbh/cnn/12cnet/12ctest/firstLayer.c"
#include "/Users/wbh/cnn/12cnet/12ctest/firstLayer.c"
//#include "/Users/wbh/cnn/12cnet/12ctest/12ConvLayer.c"

#define min(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a < _b ? _a : _b;})
#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})

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
    float mean_x;
    float mean_x2;
    float std = 0.0;
    float res;

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
    

    // ----------------------------------------------------------
    // for testing
    char file[] = "/Users/wbh/cnn/12cnet/img/2.jpg";
    printf("For testing: %s\n",file);
    // ----------------------------------------------------------

    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    // dstImg = cvCreateImage(cvSize(12, 12), IPL_DEPTH_8U, 1);
    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        continue;
    }

    // original size of the image
    IplImage *originalImg;
    originalImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);
    int WIDTH = originalImg->width;
    int HEIGHT = originalImg->height;
    

    // object coordinate information
    int object[10000][4];
    int num_object = 0;

    // image pyramid loop starts
    const int MinImageSize = 16;
    
    // ----------------------------------------------------------
    // for testing
    // const int MinImageSize = 12;
    // ----------------------------------------------------------

    while (srcImg -> height >= MinImageSize){     

        
        // get the image data
        width = srcImg -> width;
        height = srcImg -> height;
        step = srcImg -> widthStep;
        channels = srcImg -> nChannels;
        data = (uchar*) srcImg -> imageData;

        const int Stride = 4;
        int row, col;
        float img[12][12];
        
        // window sliding loop starts
        for (row = 0; row + 12 <= height; row += Stride){
            for (col = 0; col + 12 <= width; col += Stride){

                mean_x = 0.0;
                mean_x2 = 0.0;

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

                // printf("%d%% tested, testing on image %s\n", (int)((float)loop*100/14266), file);
                // printf("image size: %d, test on row: %d, col: %d\n", width, row, col);
                res = firstLayer(img, 12, 12, channels);
                if (res > 0.95){
                    // printf("\n\n---------- face detected at row: %d, col: %d ------------\n\n", row, col);
                    object[num_object][0] = width;
                    object[num_object][1] = height;
                    object[num_object][2] = row;
                    object[num_object][3] = col;
                    num_object++;
                }
                
            }
        }   // window sliding loop ends

        // down pyramid
        dstImg = doPyrDown(srcImg);
        srcImg = dstImg;

        } // image pyramid loop end

        // calibration

        int multiplicant;
        
        // real position and size of the detected window in original image
        int realPos_w, realPos_h , realWinSize_w, realWinSize_h;

        // different scales
        float s[5] = {0.83, 0.91, 1.0, 1.10, 1.21};
        float x[3] = {-0.17, 0.0, 0.17};
        float y[3] = {-0.17, 0.0, 0.17};

        while (num_object > 0){
            num_object--;
            // printf("face detected at image size: %d * %d, row: %d, col: %d\n", object[num_object][0], object[num_object][1], object[num_object][2], object[num_object][3]);
            
            // ratio of the pyramid and original image 
            multiplicant = WIDTH / object[num_object][0];

            realWinSize_w = 12 * multiplicant;
            realWinSize_h = 12 * multiplicant;
            realPos_w = object[num_object][2] * multiplicant;
            realPos_h = object[num_object][3] * multiplicant;

            printf("real window size: %d * %d,  position row: %d, col: %d\n", realWinSize_w, realWinSize_h, realPos_w, realPos_h);
            
            int sn, xn, yn;
            int cali_x, cali_y, cali_w, cali_h;

                IplImage *origImg = cvCloneImage(originalImg);
                cvNamedWindow("win3", CV_WINDOW_AUTOSIZE);
                cvMoveWindow("win3", 0, 100);
                cvRectangle(origImg, cvPoint(realPos_w, realPos_h), cvPoint(realPos_w + realWinSize_w, realPos_h + realWinSize_h), cvScalar(255, 0, 0, 0), 2, 4, 0);
                cvShowImage("win3", origImg);
            // loop over 45 calibrations
            for (sn = 0; sn < 5; sn++){
                for (xn = 0; xn < 3; xn++){
                    for (yn = 0; yn < 3; yn++){
                cali_x = (int)(realPos_w - x[xn] * realWinSize_w / s[sn]);
                cali_y = (int)(realPos_h - y[yn] * realWinSize_h / s[sn]);
                cali_w = (int)(realWinSize_w / s[sn]);
                cali_h = (int)(realWinSize_h / s[sn]);

                // make sure the calibration image not beyond the boundary
                if (cali_x >= WIDTH || cali_y >= HEIGHT){
                    continue;
                }
                cali_x = max(cali_x, 0);
                cali_y = max(cali_y, 0);
                cali_w = min(cali_w, WIDTH - cali_x);
                cali_h = min(cali_h, HEIGHT - cali_y);

                IplImage *calibImg;
                calibImg = cvCreateImage(cvSize(cali_w, cali_h), IPL_DEPTH_8U, 1);

                // originalImg->imageData = (uchar*) originalImg->imageData;
                // calibImg->imageData = (uchar*) originalImg->imageData;

                int row, col;
                float img[12][12];

                for (row = 0; row < cali_h; row++){
                    for (col = 0; col < cali_w; col++){
                        calibImg->imageData[row*calibImg->widthStep + col*calibImg->nChannels] = originalImg->imageData[(row+cali_y)*originalImg->widthStep + (col+cali_x)*originalImg->nChannels];
                    }
                }
                        printf("x: %d, y: %d, w: %d, h: %d\n", cali_x, cali_y, cali_w, cali_h);
                
                IplImage *resizedImg;
                resizedImg = cvCreateImage(cvSize(12, 12), IPL_DEPTH_8U, 1);
                cvResize(calibImg, resizedImg, CV_INTER_AREA);

                IplImage *tmpImg;
                tmpImg = cvCreateImage(cvSize(100, 100), IPL_DEPTH_8U, 1);
                cvResize(resizedImg, tmpImg, CV_INTER_AREA);

                cvNamedWindow("win1", CV_WINDOW_AUTOSIZE);
                cvShowImage("win1", calibImg);
                cvMoveWindow("win1", 550, 100);
                cvNamedWindow("win2", CV_WINDOW_AUTOSIZE);
                cvShowImage("win2", tmpImg);
                cvMoveWindow("win2", 900, 100);
                cvWaitKey(50);

                /*
                // get the image data
                width = tmpImg -> width;
                height = tmpImg -> height;
                step = tmpImg -> widthStep;
                channels = tmpImg -> nChannels;
                data = (uchar*) tmpImg -> imageData;

                        mean_x = 0.0;
                        mean_x2 = 0.0;

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
                                printf("img[%d][%d] = %f\n", i, j, img[i][j]);
                            }
                        }

                        //printf("%f, %f, %f, %f\n", cali_x, cali_y, cali_w, cali_h);
                        
                        // resize();
                    */
                    }
                }
            } // loop over 45 calibration end

            
        } // loop over single image end

                exit(0);

    } // image testset loop ends

    return 0;
}

