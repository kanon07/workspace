#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void main(int argc, char *argv[] ){
    long double time;
    long double currenttime = atoi(argv[1]);
    long double starttime = atoi(argv[2]);

    time = currenttime - starttime;
    time /= 1000000;

    printf("%Lf", time);

    }
