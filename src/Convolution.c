#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

float MultiplyByElement(float *, float *, int);

int main(void){
    int i,j;
    float m1[3][3];
    float m2[3][3];
    float res;

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

    // output the first filter
    for (i = 0; i < 3; i++){
        for (j = 0; j < 3; j++){
            printf("filter1[%d][%d] =  %f\n", i, j, weight[i + 3*j]);
        }
    }

    for (i = 0; i < 3; i++){
        for (j = 0; j < 3; j++){
            m1[i][j] = i;
            m2[i][j] = j;
            printf("%f * %f \n", m1[i][j], m2[i][j]);
        }
    }

    res  = MultiplyByElement(&m1, &m2, 3);
    printf("%f\n", res);

    return 0;
}

float MultiplyByElement(float *m1, float *m2, int size){
    int i,j;
    float result = 0.0;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            result = *m1 * *m2 + result;
            printf("%f * %f = %f\n", *m1, *m2, *m1 * *m2);
            m1++;
            m2++;
        }
    }

    return result;
}
