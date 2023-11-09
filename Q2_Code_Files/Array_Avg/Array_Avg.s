// array_avg.s
.data   // section for initialised variables and constants
welcome_string: .asciz "This program will find the average value of all the 5 values you entered.\n"
element_num_prompt: .asciz "Input array size:\n"
value_prompt: .asciz "Value %d\n"
avg_str: .asciz "The average value of the elements is:%d\n"
fmt: .string "%d" // scanf integer input format
var: .int 0 // set integer variable 
count: .word 0
array_size: .word 0   // elem will contain array length
sum: .word 0 // sum stores all the values in the array
array: .word 0,0,0,0,0  // declare array of 5 word size integers

.text
.global main    // start assembly code
.extern scanf, printf   // declares the printf and scanf functions to be used

main:
    ldr X0, =welcome_string
    BL printf // print welcome_string sentence
    ldr X0, =element_num_prompt   
    bl printf   // print X0 stored value informing user to input array size

    /*User input array size value as integer */
    ldr x0, =fmt    // load the %d string format into x0
    ldr X1, =array_size    // load the size input into array_size
    bl scanf   // store user input array size into r2

    /*Load array size value into X5*/
    LDR X2, =array_size // x2 = array_size address
    LDR X5, [X2]    // X5 = array_size value
loop:   // for loop to get array values
    LDR X1,=count
    LDR X1, [X1]    // initialise count variable value in X1
    CMP X1, X5  // compare the values in R5 and R1
    bge END // if R5 iterator >=  R1, end loop
    
    /*Inform user what value theyre entering e.g. Value 1 */
    ldr X0, =value_prompt   // load "Value %d" string format into x0 argment
    LDR X1, =count//LDR X1, =count  // store current loop count into X1
    LDR X1, [X1]  // load x1 count value as input argument 
    bl printf   // print current value to add into

    /*Scan %d input value into X1*/
    ldr x0, =fmt    // load fmt mem address into x0
    ldr X1, =var // sets var address location to store input into
    bl scanf// prompt user for integer value input into x2

    /*Add input value into sum*/
    LDR x4, =sum    // load sum variable address into X4
    LDR X4, [X4]    // load sum value into x4
    LDR X1, [X1]    // load var value into X1
    ADD X4, X4, x1  // X4 = X4 + X1

    /*Count = Count + 1*/
    LDR X2, =count  // load count address into X2
    ldr X1, [x2]    // load count value into x1
    ADD X1, X1, #1  // Iterate increase by 1, R1 = R1 + 1
    STR X1, [X2]    // store x1 value into count
    b loop  // restart loop 
END:
    /*Get average from sum/array size*/
    LDR X0, =sum    // X0 <- sum address
    LDR X0, [X0]    // load X0 <- sum value 
    LDR X1, =array_size
    LDR X1, [X1]
    SDIV X1, X0, X1// avg = sum / array_size store into X1

    /*Print average */
    LDR R0, =avg_str    //load R0 <- avg_str
    BL printf   // print R0 with R1 input argument
    RET   // end program, return address
