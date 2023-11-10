#include <stdio.h>
#include <time.h>  
  
int main() {    
    int n1, n2, i, gcd;
    clock_t start, end;  
    double cpu_time_used;  
  printf("Enter two integers: ");
    scanf("%d %d", &n1, &n2);
    start = clock(); // Record the start time  
  {
  

    
    
    for(i=1; i<=n1 && i<= n2; ++i)
    {
        // checks if i is factor of both integers
        if(n1%i==0 && n2%i==0)
        gcd = i;
    }

    printf("GCD of %d and %d is %d", n1, n2, gcd);
}
    // Your code to be timed here  
    end = clock(); // Record the end time  
  
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;  
  
    printf("\nCPU time used: %f seconds\n", cpu_time_used);  
  
    return 0;  
}

