/* 
=== HOW TO RUN ===
Step 1: cd into C file location
Step 2: gcc -o student student.c -lwiringPi
Step 3: ./student

=== PRE-REQUISITES ===
Install wiringPi: https://learn.sparkfun.com/tutorials/raspberry-gpio/c-wiringpi-setup
softPwm is installed with wiringPi

=== USEFUL COMMANDS ===
Check wiringPi version: gpio -v
Check GPIO status: gpio readall

=== GPIO PIN CONNECTION ===
27 GREEN LED
13 RED LED
GROUND

GPIO14 to Monitor GPIO15
GPIO15 to Monitor GPIO14
GROUND

=== RASPBERRY PI VERSION ===
Check Version Command: cat /etc/os-release

PRETTY_NAME="Raspbian GNU/Linux 10 (buster)"
NAME="Raspbian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
*/

#include <wiringPi.h> // Only in raspberry pi system
#include <softPwm.h> // Only in raspberry pi system
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wiringSerial.h> // Only in raspberry pi system
#include <unistd.h>

/* DEFINITIONS */
#define RED 27      // GPIO Pin 27
#define GREEN 13    // GPIO Pin 13

// Program States
#define TURN_OFF 0
#define TURN_ON 1
#define LOW 0   // LED Waveform 'LOW' State of value 0
#define HIGH 1  // LED Waveform 'High' State of value 1
#define BLINK 2
#define EXIT 3

// LED Blink Selection
#define BLINK_GREEN 1
#define BLINK_RED 2
#define CONFIRM 1

// MONITORING
#define STUDENTID "2300977"     // the student ID is not needed in the group project of 2023

// Waveform output file name and file pointer
#define FILENAME "waveform.csv" // name of file to generate waveform
FILE *waveFile; // waveform.txt file reference

// CSV Buffer Variables
#define MAXCONFIG 2 // sets the maximum number of blink configurations
char configBuffer[MAXCONFIG][8];   // stores the waveform configuration values in a 2D array
char dataPointBuffer[MAXCONFIG][1000];

/* FUNCTION PROTOTYPES */
void setupProgram();
void startProgram();
int getUserSelection();
void turnOffLeds();
void turnOnLeds();
void blink();
int getBlinkLed();
int getBlinkFrequency();
int getBlinkBrightness();
int confirmBlinkSelection();
int connectToMonitorDevice();
void blinkLedWithConfig();
void endProgram();


/* MAIN PROGRAM */
int main(void) {
    setupProgram();
    startProgram();
    endProgram();
    return 0;
}

/* 
Sets up the LED GPIO pins as output and PWM
Opens the file to be used for outputting the recorded waveform values
*/
void setupProgram() {
    wiringPiSetupGpio();
    pinMode(RED, OUTPUT);
    pinMode(GREEN, OUTPUT);
    softPwmCreate(GREEN, 0, 100); //creates a 10ms long pulse cycle for the RED led
    softPwmCreate(RED, 0, 100);   //creates a 10ms long pulse cycle for the GREEN led
    system("clear");
}

/* 
Takes the input of the user selection and directs it to different states of the program
1. Turn OFF the LEDs
2. Turn ON the LEDs
3. Blinks the LEDs according to the user specifications
4. Exits the program
*/
void startProgram() {

    int selection;
    do {
        selection = getUserSelection(); //prompts user for the LED to stay on, off, blink or end program

        switch(selection) { // sets configuration values

            case TURN_OFF:
                turnOffLeds();
                break;
            case TURN_ON:
                turnOnLeds();
                break;
            case BLINK:
                blink();
                break;
            case EXIT:
                break;
            default:
                printf("\nInvalid Input. Try Again...\n");
                break;
        }

    } while (selection != EXIT);
    
    return;
}

/* 
The main menu that determines what the user wants to do
*/
int getUserSelection() {

    int selection;

    printf("\n===== LAD STUDENT DEVICE =====\n");
    printf("\n[0] Turn off both LEDs\n");
    printf("[1] Turn on both LEDs\n");
    printf("[2] Blink LED\n");
    printf("[3] Exit\n");
    printf("\nYour Selection: ");

    scanf("%d", &selection);

    return selection;
}

/* 
For troubleshooting, turning off LEDs and PWM
Change the LED configuration values to the OFF state
DC = 100%, f = 0Hz, State Value (y<LED>) = 0 (low)
*/
void turnOffLeds() {
    system("clear");
    printf("\nTurning off both LEDs...\n");
    digitalWrite(GREEN, LOW);
    softPwmWrite(GREEN, 0); // 0% DC (0ms/10ms ON)
    digitalWrite(RED, LOW);
    softPwmWrite(RED, 0); 
    // buffer config and data value write for 100% DC LED OFF
    strncpy(configBuffer[0],"R,0,100",8);
    strncpy(configBuffer[1],"G,0,100",8);
    for (int i = 0; i < MAXCONFIG; i++) 
    {
        dataPointBuffer[i][0] = '0'; 
    }
}

/* 
For troubleshooting, turning on LEDs and PWM at 100
*/
void turnOnLeds() {
    system("clear");
    printf("\nTurning on both LEDs...\n");
    digitalWrite(GREEN, HIGH);
    softPwmWrite(GREEN, 100);   // 100% DC (10ms/10ms ON)
    digitalWrite(RED, HIGH);
    softPwmWrite(RED, 100);
    // buffer config and data value write for 100% DC LED ON
    strncpy(configBuffer[0],"R,0,100",8);
    strncpy(configBuffer[1],"G,0,100",8);
    for (int i = 0; i < MAXCONFIG; i++) 
    {
        dataPointBuffer[i][0] = '1'; 
    }
}

/* 
When user wants to blink LED, this function will get all the blinking configuration
It gets from the user the LED to blink, frequency and brightness.
Then, it will call a function to attempt handshake with Monitor before executing the blink
*/
void blink() {
    system("clear");
    printf("\nBlink...\n");
    
    int blinkLed = getBlinkLed();   // Prompts user to choose which LED to blink
    int frequency = getBlinkFrequency();    // Prompts user to choose wave frequency between 0 and 10 Hz    
    int brightness = getBlinkBrightness();  // Prompts user to choose the brightness of the LED (0-100%) which changes the duty cycle in the PWM fn

    if (confirmBlinkSelection(blinkLed, frequency, brightness) == CONFIRM) {

        /*if (connectToMonitorDevice(blinkLed, frequency, brightness) < 0) {
            printf("Connection failed, please make sure monitor device is ready.\n");
        } else {
            blinkLedWithConfig(blinkLed, frequency, brightness);
            system("clear");
        }*/
        blinkLedWithConfig(blinkLed, frequency, brightness);
        system("clear");

    } else return;

}

/* 
Menu to get user selction on LED to blink
*/
int getBlinkLed() {

    int selection;

    printf("\nSelect LED to blink.\n\n");
    printf("[1] Green LED\n");
    printf("[2] Red LED\n");
    printf("\nYour Selection: ");

    scanf("%d", &selection);

    if (selection != BLINK_GREEN && selection != BLINK_RED) {
        system("clear");
        printf("Invalid Input. Try Again...\n\n");
        getBlinkLed();
    } else {
        system("clear");
        return selection;
    }
}

/* 
Menu to get user selection on Frequency to blink
*/
int getBlinkFrequency() {

    int selection;

    printf("Enter frequency to blink.\n\n");
    printf("Enter whole numbers between 0 to 10\n");
    printf("\nFrequency (Hz): ");

    scanf("%d", &selection);

    if (selection < 0 || selection > 10) {
        system("clear");
        printf("Invalid Input. Try Again...\n\n");
        getBlinkFrequency();
    } else {
        system("clear");
        return selection;
    }
}

/* 
Menu to get user selection on LED brightness
Brightness value is between 0 and 100
*/
int getBlinkBrightness() {

    int selection;

    printf("Select LED brightness during blink.\n\n");
    printf("Enter whole numbers between 0 to 100\n");
    printf("Brightness (%%): ");

    scanf("%d", &selection);

    if (selection < 0 || selection > 100) {
        system("clear");
        printf("Invalid Input. Try Again...\n\n");
        getBlinkBrightness();
    } else {
        system("clear");
        return selection;
    }

}

/* 
Menu for user to acknowldge the blink configurations input
*/
int confirmBlinkSelection(int blinkLed, int blinkFrequency, int blinkBrightness) {
    
    int selection;
    char blinkLedString[] = "Green";

    if (blinkLed == BLINK_RED) {
        strcpy(blinkLedString, "Red");
    }

    printf("Confirm your blink configrations.\n\n");
    printf("LED to blink: %s\n", blinkLedString);
    printf("Blink Frequency: %dHz\n", blinkFrequency);
    printf("Blink Brightness: %d%%\n\n", blinkBrightness);
    printf("[1] Confirm Configuration\n");
    printf("[0] Return to Home\n");
    printf("\nYour Selection: ");

    scanf("%d", &selection);

    if (selection < 0 || selection > 1) {
        system("clear");
        printf("Invalid Input. Try Again...\n\n");
        confirmBlinkSelection(blinkLed, blinkFrequency, blinkBrightness);
    } else {
        return selection;
    }
}

/* Handshake Algo to connect wiringPi functions to respective Pi hardware*/
/*
int connectToMonitorDevice(int blinkLed, int blinkFrequency, int blinkBrightness) {
    system("clear");
    printf("Connecting to Monitor Device...\n");
    
    int serial_port;
    char studentid[] = STUDENTID;

    char blinkLedString[1];
    char blinkFrequencyString[2];
    char blinkBrightnessString[3];

    sprintf(blinkLedString, "%d", blinkLed);
    sprintf(blinkFrequencyString, "%d", blinkFrequency);
    sprintf(blinkBrightnessString, "%d", blinkBrightness);

    // Open the serial port
    serial_port = serialOpen("/dev/ttyAMA0", 9600);
    if (serial_port < 0) {
        fprintf(stderr, "Error opening serial port\n");
        return -1;
    }

    // Write data to the serial port
    serialPuts(serial_port, studentid);

    // Read data from the serial port
    char buffer[256];
    int n = read(serial_port, buffer, sizeof(buffer));
    buffer[n] = '\0';

    if (strlen(buffer) == 7) {
        printf("Acknowledge Student ID: %s\n", buffer);
    } else return -1;    

    // Send Blink Configuration
    serialPuts(serial_port, blinkLedString);
    n = read(serial_port, buffer, sizeof(buffer));
    buffer[n] = '\0';
    printf("%s\n", buffer);

    serialPuts(serial_port, blinkFrequencyString);
    n = read(serial_port, buffer, sizeof(buffer));
    buffer[n] = '\0';
    printf("%s\n", buffer);

    serialPuts(serial_port, blinkBrightnessString);
    n = read(serial_port, buffer, sizeof(buffer));
    buffer[n] = '\0';
    printf("%s\n", buffer);

    serialClose(serial_port);
    printf("Connection Successful!\n");
    delay(5000);
    return 1;
}
*/

/* 
INPUT VARIABLES:
int blinkLed: choice of LED
int blinkFrequency: frequency of wave (0-10Hz)
int blinkBrightness: uptime percentage of waveform each pulse (0-100%)
Blinks the LED according to the user configuration
1.  Convert the blinkFreq argument into the period of the waveform
2.  Picks the LED IO Pin, Green 13 or Red 27 to blink
3.  Writes a header line of the LED wave configuration (Colour, frequency, Duty Cycle)
4.  Runs a FOR LOOP that blinks the LED 20 times
    Data Recording Portion
    a_1 Checks if 20ms has passed since the previous time
    a_2 Records the data point
    Actual Physical Blink Portion
    b_1. if time elapsed is longer than one cycle of wave
    b_2. Toggles the LED state 
    b_2. Triggers softPwmWrite command to set Duty cycle based on brightness
    b_4. Calls digitalWrite() to instruct IO pin to follow softPwmWrite    
*/
void blinkLedWithConfig(int blinkLed, int blinkFrequency, int blinkBrightness) {

    printf("\nBlinking...\n");
    
    char *ptr_dpArray;   // pointer to store address of array to record data pointer into 
    // Setting Frequency
    float onOffTime = 1.0f / blinkFrequency * 1000; // period of waveform (T = 1/f)

    // Setting Blink LED to Red or Green based on blinkLed choice
    // Writes LED configuration settings into the buffer based on colour
    if (blinkLed == BLINK_GREEN) {
        printf("Green LED blinking.\n");
        blinkLed = GREEN;
        sprintf(configBuffer[1], "G,%d,%d", blinkFrequency, blinkBrightness);   // Writes Green LED Blink Configuration into the 2nd line of the buffer
        ptr_dpArray = &dataPointBuffer[1][0];    
    } else {
        printf("Red LED blinking.\n");
        blinkLed = RED;
        sprintf(configBuffer[0], "R,%d,%d", blinkFrequency, blinkBrightness);
        ptr_dpArray = &dataPointBuffer[0][0];
    }

    // Blinking
    unsigned long previousMillis = 0;   // sets initial historical time value to 0 milliseconds
    unsigned long mil20counter = millis();
    int ledState = LOW; //sets initial LED state to 0
    int timeStamp = 0;
    int bufferIter = 0; // buffer iterator that adds a spacer to reflect the correct address value to store the datapoint into

    for (int blink = 0; blink < 20;)    // Instructs LED to blink 20 times
    {
        unsigned long currentMillis = millis(); // gets the current millisecond time value
        if (currentMillis - mil20counter >= 20) { // function that runs when 20ms has elapsed since the previous time
	        mil20counter = currentMillis;
            printf("Write Count: %d Current Writing Address:%u\nTime Elapsed:%d ms\n",bufferIter,ptr_dpArray+bufferIter, timeStamp);
            timeStamp = timeStamp + 20;     
            *(ptr_dpArray + bufferIter) = ledState + '0';
            ++bufferIter; 
        }

        if (currentMillis - previousMillis >= onOffTime) {  // run if statement at the start of each wave
            previousMillis = currentMillis;
            if (ledState == LOW) {
                ledState = HIGH;
                softPwmWrite(blinkLed, blinkBrightness);  // blinkbrightness changes the percentage uptime of LED being ON
            } else {
                ledState = LOW;
                softPwmWrite(blinkLed, 0);
            }
	        printf("Blink: %d\n",blink+1);  // inform user of current blink count progress
            blink++;
            digitalWrite(blinkLed, ledState);   // instructs GPIO pin to follow current LedState
        }
    }
    printf("Completed blink function.\n");  
}

/* 
Resetting and cleaning up before safely exiting the program.
Turns off any currently ON LEDs
Writes stored buffer values into a CSV file
*/
void endProgram() {
    system("clear");
    printf("\nCleaning Up...\n");
    // Turn Off LEDs
    digitalWrite(GREEN, LOW);
    digitalWrite(RED, LOW);

    // Turn Off LED Software PWM
    softPwmWrite(GREEN, 0);
    softPwmWrite(RED, 0);

    // Reset Pins to Original INPUT State
    pinMode(GREEN, INPUT);
    pinMode(RED, INPUT); 

    // Write Config Buffer values into the CSV File
    waveFile = fopen(FILENAME, "w+"); //opens or creates a file named waveform.txt
    if (waveFile == NULL)   // checks if the specified file exists in the system
    {
        printf("Unable to open file: %s", FILENAME);
    }

    // Write Datapoint Buffer value into CSV file
    for(int i = 0; i < MAXCONFIG; i++)
    {
        fprintf(waveFile, "%s\n", configBuffer[i]);
	    printf("Line %d: %s\n", i+1, configBuffer[i]);
    }

    for (int t = 0; t < 1000; t++) // iterate through buffer and print values into CSV file
    {
        fprintf(waveFile, "%c,%c\n", dataPointBuffer[0][t], dataPointBuffer[1][t]);
    }

    fclose(waveFile);
    printf("Sending waveform file to PC.\n");
    printf("Bye!\n\n");
}
