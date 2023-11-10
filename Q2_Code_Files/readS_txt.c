#include <stdio.h>
#include <stdlib.h> 
#include <time.h>

int main() {
    char c[1000];
    clock_t start, end; 
    double cpu_time_used; 
    start = clock();
    FILE *fptr;
    if ((fptr = fopen("E://data.txt", "r")) == NULL) {
        printf("Error! File cannot be opened.");
        // Program exits if the file pointer returns NULL.
        exit(1);
    }

    // reads text until newline is encountered
    fscanf(fptr, "%[^\n]", c);
    printf("Data from the file:\n%s", c);
    fclose(fptr);
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; 
 
    printf("CPU time used: %f seconds\n", cpu_time_used);
    return 0;
}