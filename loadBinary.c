#include <stdio.h>
#include <stdlib.h>

#define PATH "/home/binghao/cnn/model.net"

int main(){
    FILE *f;
    int i;
    float k;
    
    f = fopen(PATH, "r+");
    if (f == NULL){
        printf("Error");
        exit(1);
    }

    i = 0;
    while (!feof(f)){
        fread(&k, sizeof(double), 1, f);
        printf("%f", k);
        i++;
    }

    fclose(f);
    return 0;

}
