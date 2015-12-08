#include <stdlib.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <string.h>
#include <math.h>
#include <unistd.h>

#define min(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a < _b ? _a : _b;})
#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})

float Layer12(float img[][12], int width, int height, int channels);
float* CaliLayer12(float img[][12], int width, int height, int channels);
float Layer24(float img[][24], int width, int height, int channels);
float* CaliLayer24(float img[][24], int width, int height, int channels);

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
    // strcpy(path, "/Users/wbh/cnn/test/c_faces/pic");
    strcpy(path, "/home/binghao/cnn/test/c_faces/pic");
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
    char file[] = "/home/binghao/cnn/test/img/lena.jpg";
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
                
                // send the 12 * 12 detection window to 12 calibration if it's detected as a face
                res = Layer12(img, 12, 12, channels);
                if (res > 0.5){
                    // printf("\n\n---------- face detected at row: %d, col: %d ------------\n\n", row, col);

                    float *out_12c;
                    out_12c = CaliLayer12(img, 12, 12, channels);

                    // printf("detection: %f, %f, %f\n", out_12c[0], out_12c[1], out_12c[2]);
                    float s, x, y;
                    s = out_12c[0];
                    x = out_12c[1];
                    y = out_12c[2];

                    free(out_12c);
                    
                    // real position and size of the detected window in original image
                    int multiplicant;
                    int realPos_w, realPos_h , realWinSize_w, realWinSize_h;

                    multiplicant = WIDTH / width; 

                    realWinSize_w = 12 * multiplicant;
                    realWinSize_h = 12 * multiplicant;
                    realPos_w = row * multiplicant;
                    realPos_h = col * multiplicant;

                    // calibration 
                    int cali_x, cali_y, cali_w, cali_h;
 
                    cali_x = (int)(realPos_w - x * realWinSize_w / s);
                    cali_y = (int)(realPos_h - y * realWinSize_h / s);
                    cali_w = (int)(realWinSize_w / s);
                    cali_h = (int)(realWinSize_h / s);
                    
                    // make sure the calibration image not beyond the boundary
                    if (cali_x >= WIDTH || cali_y >= HEIGHT){
                        continue;
                    }
                    cali_x = max(cali_x, 0);
                    cali_y = max(cali_y, 0);
                    cali_w = min(cali_w, WIDTH - cali_x);
                    cali_h = min(cali_h, HEIGHT - cali_y);

                    // ----------- for testing -----------------
                    // skip the small windows
                    if (width > 100)
                        continue;
                    // -----------------------------------------

                    printf("real window size: %d * %d,  position row: %d, col: %d\n", realWinSize_w, realWinSize_h, realPos_w, realPos_h);
                    printf("x: %f, y: %f, s: %f\n", x, y, s);
                    printf("cali window position: %d, %d,  cali position width: %d, height: %d\n", cali_x, cali_y, cali_w, cali_h);

                    
                    IplImage *origImg = cvCloneImage(originalImg);
                    cvNamedWindow("12 net", CV_WINDOW_AUTOSIZE);
                    cvMoveWindow("12 net", 0, 100);
                    cvRectangle(origImg, cvPoint(realPos_w, realPos_h), cvPoint(realPos_w + realWinSize_w, realPos_h + realWinSize_h), cvScalar(255, 0, 0, 0), 2, 4, 0);
                    cvShowImage("12 net", origImg);

                    IplImage *origImg_cali = cvCloneImage(originalImg);
                    cvNamedWindow("12 calibration", CV_WINDOW_AUTOSIZE);
                    cvMoveWindow("12 calibration", 550, 100);
                    cvRectangle(origImg_cali, cvPoint(cali_x, cali_y), cvPoint(cali_x + cali_w, cali_y + cali_h), cvScalar(255, 0, 0, 0), 2, 4, 0);
                    cvShowImage("12 calibration", origImg_cali);
                    

                    float img24[24][24];
                    
                    // 24 net
                    // resize the detected window of original image after 12 calibration net
                    cvSetImageROI(originalImg, cvRect(cali_x, cali_y, cali_w, cali_h));
                    IplImage *input24Img = cvCreateImage(cvSize(24, 24), IPL_DEPTH_8U, 1);
                    cvResize(originalImg, input24Img, CV_INTER_AREA);;

                    IplImage *tempImg = cvCreateImage(cvSize(100, 100), IPL_DEPTH_8U, 1);
                    cvResize(input24Img, tempImg, CV_INTER_AREA);;
                    cvNamedWindow("24 net", CV_WINDOW_AUTOSIZE);
                    cvMoveWindow("24 net", 1150, 100);
                    cvShowImage("24 net", tempImg);

                    mean_x = 0.0;
                    mean_x2 = 0.0;

                    uchar *data24;
                    data24 = (uchar*) input24Img -> imageData;

                    for (i = 0; i < 24; i++){
                        for (j = 0; j < 24; j++){
                            img24[i][j] = data24[i * input24Img->widthStep+ j * input24Img->nChannels] / 255.0;
                            mean_x += img24[i][j];
                            mean_x2 += pow(img24[i][j], 2);
                        }
                    }

                    mean_x /= 576.0;
                    mean_x2 /= 576.0;
                    std = sqrt(mean_x2 - pow(mean_x, 2));
                    for (i = 0; i < 24; i++){
                        for (j = 0; j < 24; j++){
                            img24[i][j] -= mean_x;
                            img24[i][j] /= std;
                            // printf("img[%d][%d] = %f\n", i, j, img24[i][j]);
                        }
                    }

                    res = Layer24(img24, 24, 24, input24Img->nChannels);
                    printf("\nres = %f\n", res);

                    // pass the 24 net
                    if (res > 0.5){
                        printf("object detected\n\n");

                        float *out_24c;
                        out_24c = CaliLayer24(img24, 24, 24, input24Img->nChannels);
                        float s_24, x_24, y_24;
                        s_24 = out_24c[0];
                        x_24 = out_24c[1];
                        y_24 = out_24c[2];
                        free(out_24c);
                        printf("s: %f, x: %f, y: %f\n", s_24, x_24, y_24);

                        // 24 calibration
                        int cali24_x, cali24_y, cali24_w, cali24_h;

                        cali24_x = (int)(cali_x - x_24 * cali_w / s_24);
                        cali24_y = (int)(cali_y - y_24 * cali_h / s_24);
                        cali24_w = (int)(cali_w / s_24);
                        cali24_h = (int)(cali_h / s_24);

                        printf("24_x: %d, 24_y: %d, 24_w: %d, 24_h: %d\n", cali24_x, cali24_y, cali24_w, cali24_h);

                        cvResetImageROI(originalImg);

                        IplImage *origImg_cali24 = cvCloneImage(originalImg);
                        cvNamedWindow("24 calibration", CV_WINDOW_AUTOSIZE);
                        cvMoveWindow("24 calibration", 0, 300);
                        cvRectangle(origImg_cali24, cvPoint(cali24_x, cali24_y), cvPoint(cali24_x + cali24_w, cali24_y + cali24_h), cvScalar(255, 0, 0, 0), 2, 4, 0);
                        cvShowImage("24 calibration", origImg_cali24);
                        

                        

                        
                        
                    }




                    cvWaitKey(0);

                    cvDestroyWindow("24 calibration");

                    // reset to original image
                    cvResetImageROI(originalImg);
                }
                
            }
        }   // window sliding loop ends

        // down pyramid
        dstImg = doPyrDown(srcImg);
        srcImg = dstImg;

        } // image pyramid loop end

        exit(0);

    } // image testset loop ends

    return 0;
}

