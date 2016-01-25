#include <math.h>

float* preprocess(int* data, int size){
    float* img;

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
        }
    }

    return img;
}
