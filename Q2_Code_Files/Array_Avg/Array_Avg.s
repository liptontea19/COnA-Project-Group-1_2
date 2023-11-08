// array_avg.s
.data   // section for initialised variables and constants
welcome_string: .asciz "This program will find the average value of all the 5 values you entered.\n"
element_num_prompt: .asciz "Input array size:\n"
value_prompt: .asciz "Value %d\n"
avg_str: .asciz "The average value of the elements is:%d\n"
fmt: .string "%d" // scanf integer input format
var: .int 0 // set integer variable 
elem: .word 0   // elem will contain array length
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
    ldr x0, =fmt    // load the %d string format into x0
    ldr X1, =var    // load the integer expected value into x1
    bl scanf   // store user input array size into r2
    //LDR X4, =array  // R4 store array address
    //mov X1, #5 // set R1 to 0
    mov X5, #0  // set R5 to 0
loop:   // for loop to get array values
    CMP X5, X1  // compare the values in R5 and R1
    bge END // if R5 iterator >=  R1, end loop
    
    ldr X0, =value_prompt   // load "Value %d" into x0
    ldr X2, X5  // load x5 value into input argument 
    bl printf   // print current value to add into
    ldr x0, =fmt    // load fmt mem address into x0
    ldr X2, =var // sets X2 to store the input value
    bl scanf// prompt user for integer value input into x2
    //str x2, [x4,//str R2, [sp, [R5]]  // store value into array[iteration]
    //LDR R3, =sum    // load sum address into r3
    ADD X3, X3, X2 // R3 = R3] R2
    ADD X5, X5, #1  // Iterate increase by 1, R5 = R5 + 1
    b loop  // restart loop 
END:
    // avg = sum / ele_count
    //LDR R0, =avg_str// load avg_str string into R0
    //LDR R2, 
    //BL printf   // print average value
    RET   // end program, return address
