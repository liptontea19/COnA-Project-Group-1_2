#include <stdio.h>
#include <time.h>

int main() {
    int num; 

    printf("Enter an integer: "); //enter a number
    scanf("%d", &num);
    clock_t t = clock(); //start the timer

    // check if it is divisable by 2, if so, it is even, else it is odd
    if(num % 2 == 0) {
        t = clock() - t;
        double time_taken = ((double)t) / CLOCKS_PER_SEC;
        printf("%d is even & it took %f miliseconds to compute", num, time_taken);
    }
    else {
        t = clock() - t;
        double time_taken = ((double)t) / CLOCKS_PER_SEC;
        printf("%d is odd & it took %f miliseconds to compute", num, time_taken);
    }
    return 0;
}
