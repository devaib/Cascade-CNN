#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(void)
{
    // Network structure
    const int N = 16; 
    const int M = 9;

    // Weights
    float *w = malloc(N*M*sizeof(*w)); 
    // Biases
    float *b = malloc(N*sizeof(*b));   

    // Binary file operations
    FILE *f = fopen("/Users/wbh/cnn/module1.bin", "rb");
    assert(fread(w, sizeof(*w), N*M, f) == N*M);
    assert(fread(b, sizeof(*b), N, f) == N);
    fclose(f);

    // Output the weights
    int i, j;
    for (i = 0; i < N; i++)
        for (j = 0; j < M; j++){
            printf("w[%d,%d] = %f\n", i, j, w[M * i + j]);
        }

    // Output the biases
    for (i = 0; i < N; i++){
        printf("b[%d] = %f\n", i, b[i]);
    }

    free(w);
    free(b);

    return 0;
}
