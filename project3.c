#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    //open the data file for reading
    FILE *fp = fopen("E:\\waveform.csv", "r");

    //check if the file was opened successfully or not
    if (!fp) {
        printf("Can't open file\n");
        return 1;
    }

    //Define variables for parsing data
    char buffer[1024];
    int row = 0;
    int column = 0;
    float freqR = 0;
    float DutyG = 0;
    float DutyR = 0;
    float freqG = 0;
    float time_step = 0.02;
    int amplitude = 1;
    int duration = 1000; // Duration of each square wave cycle (in data points)

    // Variables to store data for LED R and LED G
    float time[1024]; // Assuming a maximum of 1024 data points
    float LED_R[1024];
    float LED_G[1024];

    //Read data from the file and process it
    while (fgets(buffer, 1024, fp)) {
        column = 0;
        row++;

        // Splitting the data by comma and space
        char* value = strtok(buffer, ", ");

        while (value) {
            // Process the header rows
            // reads the first 2 rows of the data
            if (row == 1) {
                if (column == 0) {
                    printf("LED: %s\n", value);
                }
                if (column == 1) {
                    printf("Frequency: %s\n", value);
                    freqR = atof(value);
                }
                if (column == 2) {
                    printf("Duty Cycle: %s\n", value);
                    DutyR = atof(value);
                }
            }
            
            if (row == 2) {
                if (column == 0) {
                    printf("LED: %s\n", value);
                }
                if (column == 1) {
                    printf("Frequency: %s\n", value);
                    freqG = atof(value);
                }
                if (column == 2) {
                    printf("Duty Cycle: %s\n", value);
                    DutyG = atof(value);
                }
            }
            //once its reaches the 3rd row then it starts taking in data for both the LEDs
            //it ignores the first 2 rows 
            // Process the data
            else if (row > 2) {
                if (column == 0) {
                    printf("LED R: %s\n", value);
                    LED_R[row - 3] = atof(value);
                }
                if (column == 1) {
                    printf("LED G: %s\n", value);
                    LED_G[row - 3] = atof(value);
                }
                printf("\n");
            }
            value = strtok(NULL, ", ");
            column++;
        }
    }
    //close the data file
    fclose(fp);

    // open a gnuplot process for plotting
    FILE* gnuplotPipe = popen("gnuplot -persistent", "w");

    //checks if the gnuplot process was opened successfully
    if (gnuplotPipe == NULL) {
        perror("Error opening Gnuplot pipe");
        return 1;
    }
    // Set the terminal size to windows 
    fprintf(gnuplotPipe, "set term windows 0\n");

    // set up the multiplot layout with 2 rows and 1 column
    fprintf(gnuplotPipe, "set multiplot layout 2,1 rowsfirst \n");

    // --- Plot for "Red LED" (top)
    fprintf(gnuplotPipe, "set title 'LED R' \n");
    fprintf(gnuplotPipe, "set label 1 'Frequency: %.2f Hz   Duty Cycle: %.2f %%' at graph 0.1,0.96 font ',10'\n", freqR, DutyR);
    fprintf(gnuplotPipe, "set xtics 0.5\n");
    fprintf(gnuplotPipe, "set xrange [0:%f]\n", (row - 2) * time_step);
    fprintf(gnuplotPipe, "set yrange [-0.5:1.5]\n");
    fprintf(gnuplotPipe, "set xlabel 'Time (s)'\n");
    fprintf(gnuplotPipe, "set ylabel 'Amplitude'\n");
    fprintf(gnuplotPipe, "plot '-' title 'R' with steps linecolor rgb 'red' linewidth 2\n");

    // Generate square wave data for LED_R based on LED_R values
    int cycle_count = 0;
    for (int i = 0; i < row - 2; i++) {
        if (i >= (cycle_count + 1) * duration) {
            cycle_count++;
        }
        float current_time = i * time_step;
        if (LED_R[i] > 0) {
            fprintf(gnuplotPipe, "%f 1\n", current_time);
        } else {
            fprintf(gnuplotPipe, "%f 0\n", current_time);
        }
    }
    fprintf(gnuplotPipe, "e\n");

    // --- Plot for "Green LED" (bottom)
    fprintf(gnuplotPipe, "set title 'LED G' \n", freqG, DutyG);
    fprintf(gnuplotPipe, "set label 1 'Frequency: %.2f Hz   Duty Cycle: %.2f %%' at graph 0.1,0.96 font ',10'\n", freqG, DutyG);
    fprintf(gnuplotPipe, "set xtics 0.5\n");
    fprintf(gnuplotPipe, "set xrange [0:%f]\n", (row - 2) * time_step);
    fprintf(gnuplotPipe, "set yrange [-0.5:1.5]\n");
    fprintf(gnuplotPipe, "set xlabel 'Time (s)'\n");
    fprintf(gnuplotPipe, "set ylabel 'Amplitude'\n");
    fprintf(gnuplotPipe, "plot '-' title 'G' with steps linecolor rgb 'green' linewidth 2\n");

    // Generate square wave data for LED_G based on LED_G values
    cycle_count = 0;
    for (int i = 0; i < row - 2; i++) {
        if (i >= (cycle_count + 1) * duration) {
            cycle_count++;
        }

        float current_time = i * time_step;
        if (LED_G[i] > 0) {
            fprintf(gnuplotPipe, "%f 1\n", current_time);
        } else {
            fprintf(gnuplotPipe, "%f 0\n", current_time);
        }
    }
    fprintf(gnuplotPipe, "e\n");

    //end the multiplot
    fprintf(gnuplotPipe, "unset multiplot\n");

    pclose(gnuplotPipe);  // Close the Gnuplot pipe

    return 0;
}