#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

#define max(a, b) ({__typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b;})

float MultiplyByElement(float m1[][3], float m2[][3], int size){
    int i,j;
    float result = 0.0;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            result = m1[i][j] * m2[i][j] + result;
            // printf("%f * %f = %f\n", m1[i][j], m2[i][j], m1[i][j] * m2[i][j]);
        }
    }
    // printf("result: %f\n", result);
    //exit(0);

    return result;
}

int firstLayer(int img[][12], int height, int width, int channels){
    int i, j, k;
    float img_segment[3][3];
    float filter[16][3][3];
    float output1[16][10][10];

    char path[] = "/home/binghao/cnn/module1.bin";
    // char path[] = "/Users/wbh/cnn/module1.bin";

    char conv_layer_output_path[] = "/home/binghao/cnn/conv_layer_output.txt";
    // char conv_layer_output_path[] = "/Users/wbh/cnn/conv_layer_output.txt";

    char pooling_output_path[] = "/home/binghao/cnn/pooling_ouput.txt";
    // char pooling_output_path[] = "/Users/wbh/cnn/pooling_ouput.txt";

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

    
    FILE *f = fopen(path, "rb");
    assert(fread(weight, sizeof(*weight), Depth*Filter, f) == Depth*Filter );
    assert(fread(bias, sizeof(*bias), Depth, f) == Depth);
    fclose(f);

    // output the weight and bias
    for (i = 0; i < Depth; i++){
        for (j = 0; j < Filter; j++){
            // printf("weight[%d, %d] = %f\n", i, j, weight[Filter * i + j]);
        }
        // printf("bias[%d] = %f\n", i, bias[i]);
    }

    // output the filters
    for (k = 0; k < 16; k++){
        for (i = 0; i < 3; i++){
            for (j = 0; j < 3; j++){
                // printf("filter[%d][%d][%d] =  %f\n", k, i, j, weight[9*k + i + 3*j]);
                // filter[k][i][j] = weight[9*k + i + 3*j];
                // printf("filter[%d][%d][%d] =  %f\n", k, i, j, weight[9*k + 3*i + j]);
                filter[k][i][j] = weight[9*k + 3*i + j];
            }
        }
    }

    // convolution
    int row, col, filter_num;
    double res;
    for (filter_num = 0; filter_num < 16; filter_num++){
        for (row = 0; row < 10; row++){
            for (col = 0; col < 10; col++){
                for (i = 0; i < 3; i++){
                    for (j = 0; j < 3; j++){
                        img_segment[i][j] = img[i+row][j+col] / 255.0;
                    }
                }

                res = MultiplyByElement(filter[filter_num], img_segment, 3);
                res += bias[filter_num];

                output1[filter_num][row][col] = res;
            }
        }
    }

    // padding
    float input2[16][12][12];
    for (k = 0; k < 16; k++){
        for (i = 0; i < 12; i++){
            for (j = 0; j < 12; j++){
                if (i == 0 || i == 11 || j == 0 || j == 11){
                    input2[k][i][j] = 0;
                } else {
                    input2[k][i][j] = output1[k][i-1][j-1]; 
                }
            }
        }
    }

    // polling and RELU
    float output2[16][5][5];
    int stride2 = 2;
    float maxpool;
    for (k = 0; k < 16; k++){
        for (row = 0; row < 5; row++){
            for (col = 0; col < 5; col++){
                maxpool = 0.0;
                for (i = 0; i < 3; i++){
                    for (j = 0; j < 3;j++){
                        maxpool = max(maxpool, input2[k][i+row*stride2][j+col*stride2]);
                        // printf("maxpool: %f, input[%d][%d]: %f\n", maxpool, i + row*2, j + col*2, input2[k][i+row*stride2][j+col*stride2]);
                    }
                }
                output2[k][row][col] = maxpool;
                // printf("result: %f\n", maxpool);    exit(0);
            }
        }
    }

    FILE *ffp = fopen(pooling_output_path,"w");
    for (k = 0; k < 16; k++){
        for (i = 0; i < 5; i++){
            for (j = 0; j < 5; j++){
                printf("output2[%d][%d][%d]: %f\n", k, i, j, output2[k][i][j]);
                fprintf(ffp, "output2[%d][%d][%d]: %f\n", k, i, j, output2[k][i][j]);
            }
        }
        fprintf(ffp, "---------------------------------\n");
        // printf("---------------------------------\n");
    }

    fclose(ffp);

    FILE *fp = fopen(conv_layer_output_path,"w");
    if (f == NULL){
        printf("Error opening file!\n");
        exit(1);
    }

    for (filter_num = 0; filter_num < 16; filter_num++){
        for (row = 0; row < 10; row++){
            // printf("-----------------------\n");
            fprintf(fp, "-----------------------\n");
            for (col = 0; col < 10; col++){
                // printf("value of filter_num %d at row %d, col %d is : %f\n", filter_num, row, col, output[filter_num][row][col]);
                fprintf(fp, "value of filter_num %d at row %d, col %d is : %f\n", filter_num, row, col, output1[filter_num][row][col]);
            }
        }
    }
    printf("output size: %d * %d *%d", row, col, filter_num);

    fclose(fp);
    
    return 0;
}


