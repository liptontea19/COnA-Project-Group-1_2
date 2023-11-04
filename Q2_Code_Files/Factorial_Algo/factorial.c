#include<stdio.h>
#include<time.h>

int MultiplyNumbers(int n);
int PositiveInt(int n);

//multiply the corresponding numbers
int MultiplyNumbers(int n) {
    //when n==0, give back 1
    if (n==0)
    {
        return (1);
    }
    else //print out n=(corresponding number), continue to give back the number until it hits 0
    {
        printf("\n n=%d", n);
        return (n*MultiplyNumbers(n-1));
    }
}

//check if it is a postive integer
int PositiveInt(int n){
    if (n<=0){
        printf("\n Please put in a postive integer");
        printf("\n\nEnter a positive integer: ");
        scanf("%d",&n);
        if (n<=0){ //when it is still not a positive integer ask the user to key in again
            PositiveInt(n);
        }
    } else { //if all is correct, give back n
        return n;
    }
}

int main() {
    int n;
    int result;

    //ask user to give out a positive integer
    printf("Enter a positive integer: ");
    scanf("%d",&n);

    //return positiveint as n
    n = PositiveInt(n);

    clock_t t = clock(); //start the clock
    result = MultiplyNumbers(n); //have result be calculated

    //calculate the seconds taken for the quick sort algo in milliseconds
    t = clock() - t;
    double time_taken = ((double)t) / CLOCKS_PER_SEC;

    //print the factorial and time taken to compute
    printf("Factorial of %d = %ld, and it took %f miliseconds", n, result, time_taken);
    return 0;
}
