// preprocess image data
#include <math.h>
#include "global.h"

void preprocess(float **img, unsigned char *data, int row, int col, int step, int channels, int size){
    /*
    int i, j;
    float mean_x, mean_x2, std;

    mean_x = 0.0;
    mean_x2 = 0.0;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            img[i][j] = (float)data[(i+row)*step + (j+col)*channels] / 255.0;
            mean_x += img[i][j];
            mean_x2 += pow(img[i][j], 2);
        }
    }

    mean_x /= (size * size);
    mean_x2 /= (size * size);
    std = sqrt(mean_x2 - pow(mean_x, 2));
    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            img[i][j] -= mean_x;
            img[i][j] /= std;
        }
    }
    */
    int i, j;
    float mean, std, n;
    mean = .0f;
    std = .0f;
    n = (float)size * size;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            img[i][j] = (float)data[(i+row)*step + (j+col)*channels] / 255.0;
            mean += img[i][j];
        }
    }

    mean = mean / n;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            std += pow((img[i][j] - mean), 2);
        }
    }

    std = sqrt(std/(n - 1));

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            img[i][j] -= mean;
            img[i][j] /= std;
            // printf("img[%d][%d] = %f\t", i, j, img[i][j]);
        }
    }

}
