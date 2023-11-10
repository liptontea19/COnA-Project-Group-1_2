#include <stdio.h>

int main (void)
{
    char c[1000];
    clock_t start, end; 
    double cpu_time_used; 
    start = clock();
    int ele_count, sum = 0;
    float avg = 0;
    printf("This program will find the average value of all the values you entered.\n");
    printf("First input the number of elements you want your array to have:\n");
    scanf("%d", &ele_count);

    int array[ele_count];
    printf("Next, enter your %d values, one at a time.\n", ele_count);

    for (int i=0; i < ele_count; i++) // gets the values for the array
    {
        printf("Value %d:\n", i+1);
        scanf("%d", &array[i]);
        sum = sum + array[i];
    }

    avg = sum / ele_count;
    printf("The average value of the array is:%.2f", avg);

    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; 
 
    printf("CPU time used: %f seconds\n", cpu_time_used);
    return 0;
}