#include "global.h"

// ***************** parameters settings start *************************
// home folder
const char FILE_PATH[] = "/home/binghao/";

// test image path
const char TEST_IMAGE[] = "cnn/test/img/faces3.jpg";

// minimum size(pixels) of detection object
const int MinFaceSize = 108;

// ***************** parameters settings end ***************************

// function declarations
// layers
float Layer12(float **img, int width, int height, int channels);
float* CaliLayer12(float **img, int width, int height, int channels);
float Layer24(float **img, int width, int height, int channels);
float* CaliLayer24(float **img, int width, int height, int channels);
float Layer48(float **img, int width, int height, int channels);
float* CaliLayer48(float **img, int width, int height, int channels);

// image pyramid down by rate
IplImage* doPyrDown(IplImage *src, int rate);

// preprocess image data
void preprocess(float **img, unsigned char *data, int row, int col, int step, int channels, int size);

// free two-dimensonal array with n rows
void freeArray(float **img, int n);

int main(void){
    // loop counter
    int i, j, k;
    int row, col;
    int counter = 0;

    // image information
    int height, width, step, channels;
    uchar *data;

    // scores of the 12 layer
    float res_12Layer;

    // window sliding stride
    const int Stride = 4;

    // image pyramid rate
    const int pyr_rate = MinFaceSize / 12;

    // file path
    char file[50];
    strcpy(file, FILE_PATH);
    strcat(file, TEST_IMAGE);

    // alloc memory for 12x12 image
    float **img = malloc(12 * sizeof(float*));
    for (i = 0; i < 12; i++){
        img[i] = malloc(12 * sizeof(float));
    }


    printf("Testing on: %s\n", file);

    // load image
    IplImage *srcImg, *dstImg;
    srcImg = cvLoadImage(file, CV_LOAD_IMAGE_GRAYSCALE);

    if (!srcImg){
        printf("Could not load image file: %s\n", file);
        exit(1);
    }

    // image pyramid loop starts
    while (1){
        // struct of information windows
        struct Windows{
            int x1, y1, x2, y2;
            float score;
        }window[300];

        // image pyramid down
        dstImg = cvCreateImage(cvSize(srcImg->width/pyr_rate, srcImg->height/pyr_rate), IPL_DEPTH_8U, 1);
        cvResize(srcImg, dstImg, CV_INTER_AREA);;

        // get the image data
        width = dstImg -> width;
        height = dstImg -> height;
        step = dstImg -> widthStep;
        channels = dstImg -> nChannels;
        data = (uchar*)dstImg -> imageData;

        IplImage *detectedImg_12Layer = cvCloneImage(dstImg);

        IplImage *origin = cvCloneImage(dstImg);

        // window sliding loop starts
        for (row = 0; row + 12 <= height; row += Stride){
            for (col = 0; col + 12 <= width; col += Stride){
                preprocess(img, data, row, col, step, channels, 12);

                // 12 layer start
                res_12Layer = Layer12(img, 12, 12, channels);

                if (res_12Layer > 0.5){
                    /*
                    int static counter = 0;
                    printf("%f, #%d\n", res_12Layer, counter);
                    counter++;
                    */
                    window[counter].x1 = col;            // x
                    window[counter].y1 = row;            // y
                    window[counter].x2 = col + 12;            //
                    window[counter].y2 = row + 12;            //
                    window[counter].score = res_12Layer;    // 12 layer score

                    printf("[#%d] x1: %d, y1: %d, x2: %d, y2: %d, score: %f\n", counter, window[counter].x1, window[counter].y1, window[counter].x2, window[counter].y2, window[counter].score);
                    counter++;
                    /*
                    cvNamedWindow("12 layer", CV_WINDOW_AUTOSIZE);
                    cvRectangle(detectedImg_12Layer, cvPoint(col, row), cvPoint(col+12, row+12), cvScalar(255,0,0,0), 2, 4, 0);
                    cvShowImage("12 layer", detectedImg_12Layer);
                    cvMoveWindow("12 layer", 10, 10);

                    cvSetImageROI(origin, cvRect(col, row, 12, 12));
                    IplImage *output12Img= cvCreateImage(cvSize(50, 50), IPL_DEPTH_8U, 1);
                    cvResize(origin, output12Img, CV_INTER_AREA);
                    cvNamedWindow("12", CV_WINDOW_AUTOSIZE);
                    cvShowImage("12", output12Img);
                    cvMoveWindow("12", 400, 10);
                    cvResetImageROI(origin);
                    */
                }
                // 12 layer end
            }
        }
        // window sliding loop ends

        // display survivors after 12 layer
        for (i = 0; i < counter; i++){
            cvNamedWindow("12 layer", CV_WINDOW_AUTOSIZE);
            cvRectangle(detectedImg_12Layer, cvPoint(window[i].x1, window[i].y1), cvPoint(window[i].x2, window[i].y2), cvScalar(255,0,0,0), 2, 4, 0);
        }
        cvShowImage("12 layer", detectedImg_12Layer);
        cvMoveWindow("12 layer", 10, 10);
        
        cvWaitKey(0);
        exit(0);
    }
    // image pyramid loop ends

    freeArray(img, 12);

    return 0;
}
