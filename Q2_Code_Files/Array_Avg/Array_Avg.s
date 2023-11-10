// array_avg.s
.data   // section for initialised variables and constants
welcome_string: .asciz "This program will find the average value of all the values you entered.\n"
element_num_prompt: .asciz "Input array size:\n"
value_prompt: .asciz "Value %d\n"
sum_str: .asciz "The total value of %d elements is: %d\n"
avg_str: .asciz "The average value of the elements is: %d\n"
fmt: .string "%d" // scanf integer input format
var: .word 0 // set integer variable 
count: .word 1
array_size: .word 0   // elem will contain array length
sum: .word 0 // sum stores all the values in the array
avg: .word 0 // declare array of 5 word size integers

.text
.global main    // start assembly code
.extern scanf, printf   // declares the printf and scanf functions to be used

main:
    LDR X0, =welcome_string
    BL printf // print welcome_string sentence
    LDR X0, =element_num_prompt   
    BL printf   // print X0 stored value informing user to input array size

    /*User input array size value as integer */
    LDR x0, =fmt    // load the %d string format into x0
    LDR X1, =array_size    // load the size input into array_size
    bl scanf   // store user input array size into r2

LOOP:   // for loop to get array values
    LDR X1, =count
    LDR X1, [X1]    // initialise count variable value in X1
    LDR X5, =array_size // X5 = &array_size
    LDR X5, [X5]    // X5 = array_size
    CMP X1, X5  // compare the values in R5 and R1
    BGT END // if X1(Count)>= X5(array_size), end loop

    /*Inform user what value theyre entering e.g. Value 1 */
    ldr X0, =value_prompt   // load "Value %d" string format into x0 argment
    LDR X1, =count//LDR X1, =count  // store current loop count into X1
    LDR X1, [X1]  // load x1 count value as input argument 
    //ADD X1, X1, #1	// X1 = X1 + 1
    BL printf   // print current value to add into

    /*Scan %d input value into X1*/
    ldr x0, =fmt    // load fmt mem address into x0
    ldr X1, =var // sets var address location to store input into
    bl scanf// prompt user for integer value input into x2


    /*Add input value into sum*/
    LDR x4, =sum    // load sum variable address into X4
    LDR X5, [X4]    // load sum value into x4
    //LDR X1, =var
    //LDR X1, [X1]    // load var value into X1
    ADD X5, X5, x1  // X4 = X4 + X1
    STR X5, [X4]	// store X5 value into sum

    /*Count = Count + 1*/
    LDR X2, =count  // load count address into X2
    LDR X1, [x2]    // load count value into x1
    ADD X1, X1, #1  // Iterate increase by 1, R1 = R1 + 1
    STR X1, [X2]    // store x1 value into count
    B LOOP  // restart loop 

END:
    /*Get average from sum/array size*/
    LDR X0, =sum    // X0 <- sum address
    LDR X0, [X0]    // load X0 <- sum value 
    LDR X1, =array_size	// X1 <- &array_size
    LDR X1, [X1] // X1 <- array_size
    SDIV X1, X0, X1// avg = sum / array_size store into X1
    LDR X2, =avg	// X2 <- &avg
    STR X1, [X2]	// avg <- X1

    /*Print sum*/
    LDR X0, =sum_str	// X0 <- &sum_str
    LDR X1, =array_size	// X1 <- &count
    LDR X1, [X1]	// X1 <- count
    LDR X2, =sum	// X2 <- &sum
    LDR X2, [X2]	// X2 <- sum
    BL printf		// print X0 format, input arg X1,X2

    /*Print average */
    LDR X0, =avg_str    //load X0 <- avg_str
    LDR X1, =avg
    LDR X1, [X1]	// X1 <- avg
    BL printf   // print R0 with R1 input argument
    RET   // end program, return address
