#include <stdio.h>

int main (void)
{
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
    return 0;
}
