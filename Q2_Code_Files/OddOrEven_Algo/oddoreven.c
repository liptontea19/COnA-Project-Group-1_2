#include <stdio.h>
#include <time.h>

int main() {
    int num; 

    printf("Enter an integer: "); //enter a number
    scanf("%d", &num);

    // check if it is divisable by 2, if so, it is even, else it is odd
    if(num % 2 == 0)
        printf("%d is even.", num);
    else
        printf("%d is odd.", num);
    
    return 0;
}
