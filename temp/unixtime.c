#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void main(int argc, char *argv[] ){
    long double time;
    long long int currenttime = atol(argv[1]);
    long long int starttime = atol(argv[2]);

    time = (long double)currenttime - starttime;
    time /= 1000000;

    printf("%Lf",time);

    }
