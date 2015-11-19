#include <stdio.h>
#include <stdlib.h>

#define PATH "/home/binghao/model1.net"

int main(){
    FILE *f;
    int i;
    unsigned char buffer[100];
    
    f = fopen(PATH, "rb");
    if (f == NULL){
        printf("Unable to open file!");
        exit(1);
    }

    i = 0;
    fread(buffer, sizeof(buffer), 1, f);
    for (int i = 0; i < 100; i++){
        printf("#%d is: %x\n", i, buffer[i]);
    }

    fclose(f);
    return 0;

}
