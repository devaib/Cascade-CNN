#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(void){
    char path[] = "/Users/wbh/cnn/module.bin";

    // read the weight and bias
    const int Depth = 16;
    const int Filter = 400;

    int i,j;

    float *weight = malloc(Depth * Filter * sizeof(*weight));
    float *bias = malloc(Depth * sizeof(*bias));
    // shift over modules[1].weight and modules[1].bias
    float *shift = malloc(16 * 10 * sizeof(*shift));
    
    FILE *f = fopen(path, "rb");
    fread(shift, sizeof(*shift), 16 * 10, f);
    assert(fread(weight, sizeof(*weight), Depth*Filter, f) == Depth*Filter );
    assert(fread(bias, sizeof(*bias), Depth, f) == Depth);
    fclose(f);

    // output the weight and bias
    for (i = 0; i < Depth; i++){
        for (j = 0; j < Filter; j++){
            if (i == 15)
            printf("weight[%d, %d] = %f\n", i, j, weight[Filter * i + j]);
        }
        printf("bias[%d] = %f\n", i, bias[i]);
    }

}
