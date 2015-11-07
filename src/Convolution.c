#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float MultiplyByElement(float *, float *, int);

int main(void){
    int i,j;
    float *m1;
    float *m2;
    float res;

    for (i = 0; i < 3; i++){
        for (j = 0; j < 3; j++){
            m1[i][j] = i;
            m2[i][j] = j;
        }
    }

    res  = MultiplyByElement(m1, m2, 3);

    return 0;
}

float MultiplyByElement(float *m1, float *m2, int size){
    int i,j;
    float result;

    for (i = 0; i < size; i++){
        for (j = 0; j < size; j++){
            result = m1[i][j] * m2[i][j];
        }
    }

    return result;
}
