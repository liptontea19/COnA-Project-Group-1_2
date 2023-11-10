#include <stdio.h>
#include <time.h>
int hcf(int n1, int n2);
clock_t start, end;
   double cpu_time_used;
int main() {
   
   int n1, n2;
   printf("Enter two positive integers: ");
   scanf("%d %d", &n1, &n2);
   start = clock(); // record start time
   printf("GCD of %d and %d is %d.", n1, n2, hcf(n1, n2));
   end = clock(); // record the end time
   cpu_time_used = ((double) (end-start))/CLOCKS_PER_SEC    ;
   printf("\nCPU time used: %f seconds\n",cpu_time_used);
   return 0;
}

int hcf(int n1, int n2) {
    if (n2 !=0)
    return hcf(n2, n1 %n2);
    else
    return n1;
}

