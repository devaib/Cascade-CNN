#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

float MultiplyByElement(float m1[][3], float m2[][3], int size){
    int i,j;
    float result = 0.0;
    float output[16][10][10];

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            result = m1[i][j] * m2[i][j] + result;
            // printf("%f * %f = %f\n", m1[i][j], m2[i][j], m1[i][j] * m2[i][j]);
        }
    }

    return result;
}

int Convolution(int img[][12], int height, int width, int channels){
    int i, j, k;
    float img_segment[3][3];
    float filter[16][3][3];
    float output[16][10][10];

    // output the image data
    printf("image data start");
    for (i = 0; i < height; i++){
        for (j = 0; j < width; j++){
            printf("img[%d][%d] = %d\n", i, j, img[i][j]);
        }
    }
    printf("image data end");

    // read the weight and bias
    const int Depth = 16;
    const int Filter = 9;

    float *weight = malloc(Depth * Filter * sizeof(*weight));
    float *bias = malloc(Depth * sizeof(*bias));

    FILE *f = fopen("/home/binghao/cnn/module1.bin", "rb");
    // FILE *f = fopen("/Users/wbh/cnn/module1.bin", "rb");
    assert(fread(weight, sizeof(*weight), Depth*Filter, f) == Depth*Filter );
    assert(fread(bias, sizeof(*bias), Depth, f) == Depth);
    fclose(f);

    // output the weight and bias
    for (i = 0; i < Depth; i++){
        for (j = 0; j < Filter; j++){
            printf("weight[%d, %d] = %f\n", i, j, weight[Filter * i + j]);
        }
        printf("bias[%d] = %f\n", i, bias[i]);
    }

    // output the filters
    for (k = 0; k < 16; k++){
        for (i = 0; i < 3; i++){
            for (j = 0; j < 3; j++){
                printf("filter[%d][%d][%d] =  %f\n", k, i, j, weight[9*k + i + 3*j]);
                filter[k][i][j] = weight[i + 3*j];
            }
        }
    }

    // the first image segmentation
    int row, col, filter_num;
    double res;
    for (filter_num = 0; filter_num < 16; filter_num++){
        for (row = 0; row < 10; row++){
            for (col = 0; col < 10; col++){
                for (i = 0; i < 3; i++){
                    for (j = 0; j < 3; j++){
                        img_segment[i][j] = img[i+row][j+col];
                    }
                }

                res = MultiplyByElement(filter[filter_num], img_segment, 3);
                res += bias[filter_num];

                output[filter_num][row][col] = res;
            }
        }
    }

    for (filter_num = 0; filter_num < 16; filter_num++){
        for (row = 0; row < 10; row++){
            printf("-----------------------\n");
            for (col = 0; col < 10; col++){
                printf("value of filter_num %d at row %d, col %d is : %f\n", filter_num, row, col, output[filter_num][row][col]);
            }
        }
    }
    printf("output size: %d * %d *%d", row, col, filter_num);
    
    return 0;
}


