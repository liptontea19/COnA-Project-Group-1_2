#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MAX_SIZE 10000

void quick_sort(int x[], int first, int last);
int partition (int x[],int first, int last);

int main()
{
    int x[MAX_SIZE]; //array to be sorted 
    int num_items;   //number of elements in array
    int i;           //loop counter

    clock_t t = clock(); //start the clock

    //print the quick sort text & number of items in the listed that needed to be sorted text
    printf("\n**Quick Sort**\n");
    printf("\nNumber of element in list to be sorted %d: ",MAX_SIZE);

    //set the num_items to the MAX_SIZE
    num_items=MAX_SIZE;

    //Set each array x to a random number & print out the unsorted array elements repectively
    for (i=0;i<num_items;++i)
    {
        printf("\nEnter x[%d]: ",i);
        x[i]=rand();
        printf("%d",x[i]);
    }
    
    //call the quick sort function
    quick_sort(x,0,num_items-1);

    //print the sorted array text
    printf("\n\nsorted array:");

    //print 
    for (i=0;i<num_items;++i)
    {
        printf("\n%d. %d ",i+1, x[i]);

        //once i reaches more than num_items, stop this loop
        if (i>num_items){
            break;
        }
    }

    //calculate the seconds taken for the quick sort algo in milliseconds
    t = clock() - t;
    double time_taken = ((double)t) * CLOCKS_PER_SEC;

    //print the time it took to sort the values
    printf("\n\nTime in sorting %d values using quicksort algorithm is %f miliseconds",MAX_SIZE, time_taken);
    return 0;
}

void quick_sort(int x[], int first, int last)
{
    int pivot;              /*pivot element*/
    if(first<last)
    {
        pivot=partition(x,first,last);
        quick_sort(x,first,pivot-1);
        quick_sort(x,pivot+1,last);
    }
}

int partition(int x[], int first, int last)
{
    int pivot;           /*position of the pivot element*/
    int  pivot_value;    /*value of pivot element*/
    int temp;            /*temporary storage*/
    int i;
    pivot=first;
    pivot_value=x[first];
    for(i=first;i<=last;++i)
    {
        /*compare element with pivot element*/
        if (x[i]<pivot_value)
        {
            ++pivot; /*adjust index of pivot element*/
            if (i !=pivot)
            {
                /*interchange element with pivot element */
                temp=x[pivot];
                x[pivot]=x[i];
                x[i]=temp;
            }
        }
     
    }
    /* move pivot element to point in list that separate the*/
    /* smaller elements from the larger elements*/
    temp=x[pivot];
    x[pivot]=x[first];
    x[first]=temp;

    return (pivot);
}