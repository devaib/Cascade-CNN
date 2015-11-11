#include <stdio.h>
#define max(a, b) \
    ( {__typeof__ (a) _a = (a); \
        __typeof__ (b) _b = (b); \
        _a > _b ? _a : _b; })
int main(void){
    float a = 5.0; 
    float b = 10.0;
    printf("%f\n", max(a, b));

    return 0;
}
