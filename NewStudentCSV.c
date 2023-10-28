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

// Waveform output file and used variables
#define FILENAME "waveform.csv" // name of file to generate waveform
FILE *waveFile; // waveform.txt file reference
int yRed, yGreen; // y-axis values for Red and Green LEDs ('1' or '0')
int dcRed, dcGreen; //DC values for the two LEDs (0-100%)
int fRed, fGreen; // frequency values for the two LEDs (0-10Hz)
// CSV Buffer Variables
// #define MAXBUFFER 510
#define MAXCONFIG 2 // sets the maximum number of blink configurations
// char *buffer[MAXBUFFER]; // global buffer used to store all the blink wave configurations and values
char configBuffer[MAXCONFIG];   // stores the waveform configuration values
int dpRedWaveBuffer[500]; // stores the integer datapoints for Red LED recorded over a period of 20 blinks
int dpGreenWaveBuffer[500];

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
    /*waveFile = fopen(FILENAME, "w+"); //opens or creates a file named waveform.txt
    if (waveFile == NULL)   // checks if the specified file exists in the system
    {
        printf("Unable to open file: %s", FILENAME);
    }*/
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
    //fprintf(waveFile, "G,0,0\n");
    //fprintf(waveFile, "R,0,0\n");
    /*dcGreen = 100; // Since the state does not change, DC value is 100%
    fGreen = 0; // DC = 100%, f = 0Hz, State Value (yGreen) = 0 (low)
    yGreen = 0; // State Value: LOW, '0'
    dcRed = 100;
    fRed = 0;
    yRed = 0;*/
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
    /*dcGreen = 100; // change the LED configuration values to the ON state
    fGreen = 0; // DC = 100%, f = 0Hz, State Value (yGreen) = 0 (low)
    yGreen = 0; // State Value: LOW, '0'
    dcRed = 100;
    fRed = 0;
    yRed = 0;*/
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
    if (blinkLed == 1) // Green LED configuration is chosen
    {
        fGreen = frequency;
        dcGreen = brightness;
    }
    else 
    {
        fRed = frequency;
        dcRed = brightness;
    }

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
    
    int *ptr_dpArray;
    // Setting Frequency
    float onOffTime = 1.0f / blinkFrequency * 1000; // period of waveform (T = 1/f)
    char chosenLed; //character to represent which LED colour 'G' or 'R'

    // Setting Blink LED to Red or Green based on blinkLed choice
    if (blinkLed == BLINK_GREEN) {
        blinkLed = GREEN;
        chosenLed = 'G';
        configBuffer[1] = "%c,%d,%d\n", chosenLed, blinkFrequency, blinkBrightness;
        ptr_dpArray = &dpGreenWaveBuffer;   // informs the program which integer array address it should write the values into
    } else {
        blinkLed = RED;
        chosenLed = 'R';
        configBuffer[0] = "%c,%d,%d\n", chosenLed, blinkFrequency, blinkBrightness;
        ptr_dpArray = &dpRedWaveBuffer;
    }

    // Blinking
    unsigned long previousMillis = 0;   // sets initial historical time value to 0 milliseconds
    int ledState = LOW; //sets initial LED state to 0
    int timeStamp = 0;
    int bufferIter = 0;

    for (int blink = 0; blink < 20;)    // Instructs LED to blink 20 times
    {
        unsigned long currentMillis = millis(); // gets the current millisecond time value
        if (currentMillis - previousMillis >= 20) { // function that runs when 20ms has elapsed since the previous time
            printf("%d ms has passed\n", timeStamp);
            timeStamp = timeStamp + 20;     
            ptr_dpArray + bufferIter = "%d\n", ledState; // Adds a new datapoint line to reflect the current LED's ON or OFF stat  
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
            blink++;
            digitalWrite(blinkLed, ledState);   // instructs GPIO pin to follow current LedState
            //fprintf(waveFile, "Time:%d\n", currentMillis);   // print the current output time
        }
        printf("%d Blink\n", blink+1);  // inform user that the program is blinking the LEDs
    }  
}

/* 
Resetting and cleaning up before safely exiting the program.
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

    // Write Buffer values into the CSV File
    waveFile = fopen(FILENAME, "w+"); //opens or creates a file named waveform.txt
    if (waveFile == NULL)   // checks if the specified file exists in the system
    {
        printf("Unable to open file: %s", FILENAME);
    }

    for(int i = 0; i < MAXCONFIG; i++)
    {
        fprintf(waveFile, "%s\n", configBuffer[i]);
    }

    for (t = 0; t < MAXBUFFER; t++) // iterate through buffer and print values into CSV file
    {
        fprintf(waveFile, "%d,%d", dpRedWaveBuffer[t], dpGreenWaveBuffer[t]);
    }

    fclose(waveFile);
    printf("Sending waveform file to PC.\n");
    printf("Bye!\n\n");
}
