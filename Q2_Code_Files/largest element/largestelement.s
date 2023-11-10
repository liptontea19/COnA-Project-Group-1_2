        .arch armv8-a // Set the architecture to ARMv8-A
        .text // Text section begins
        // Read-only data section
        .section        .rodata
        .align  3
prompt_num_elements: //define local label
        .string "Enter the number of elements (1 to 100): " //Format string for input prompt
        .align  3
format_string_int: //define local label
        .string "%d" //Format string for reading an integer with scanf
        .align  3
prompt_element_value: //define local label
        .string "Enter number%d: " //Format string for reading numbers with scanf, expects an integer to format the prompt
        .align  3
format_string_double: //define local label
        .string "%lf" //Format string for reading a double with scanf
        .align  3
output_largest_element: //define local label
        .string "Largest element = %.2lf" //Format string for printing the largest element, formatted as a double with 2 decimal places
        .align  3
output_cpu_time: //define local label
        .string "\nCPU time used: %f seconds\n"//Format string for printing CPU time used in seconds
        .text
        .align  2
        .global main
        .type   main, %function
main:
.LFB0: //Local function label.
        .cfi_startproc //Begin prologue for call frame information.
        sub     sp, sp, #864 //allocating 864 bytes of stack space
        .cfi_def_cfa_offset 864 
        stp     x29, x30, [sp] //Store the frame pointer and return address on the stack
        .cfi_offset 29, -864 
        .cfi_offset 30, -856
        mov     x29, sp //Set up the frame pointer for the current frame
        bl      clock //Call the 'clock' function to get the current processor time
        str     x0, [sp, 848] //Store the returned processor time at SP + 848
        adrp    x0, prompt_num_elements //Load the address of the input prompt string into x0
        add     x0, x0, :lo12:prompt_num_elements //Add the lower 12 bits of the label address to the high address in x0
        bl      printf //Call 'printf' to print the input prompt
        add     x0, sp, 828 //Add 828 to the stack pointer to get the address for storing input
        mov     x1, x0 //Move that address into x1, for the 'scanf' function
        adrp    x0, format_string_int //Load the address of the format string for 'scanf' into x0
        add     x0, x0, :lo12:format_string_int //Add the lower 12 bits of the label address to the high address in x0
        bl      __isoc99_scanf //Call 'scanf' to read an integer from the user
        str     wzr, [sp, 860] //Initialize the variable at SP + 860 to 0 (using zero register wzr)
        b       .L2 //branch to the L2 label
.L3: //Local label for the loop.
        ldr     w0, [sp, 860] //Load the value stored in memory at offset 860 into w0.
        add     w0, w0, 1 //Increment the value in w0.
        mov     w1, w0 //Copy the incremented value to w1.
        adrp    x0, prompt_element_value //Load the address of prompt_element_value into x0.
        add     x0, x0, :lo12:prompt_element_value //Add the low 12 bits of prompt_element_value's address to x0.
        bl      printf //Call the "printf" function to print an input prompt.
        add     x1, sp, 24 //Set x1 to the base address of the array of numbers.
        ldrsw   x0, [sp, 860] //Load the loop counter value into x0 (sign-extended).
        lsl     x0, x0, 3 //Multiply x0 by 8 (shift left by 3) to calculate the array index.
        add     x0, x1, x0 //Add the base address to the calculated index to access the array element.
        mov     x1, x0 //Copy the address of the array element to x1.
        adrp    x0, format_string_double //Load the address of format_string_double into x0.
        add     x0, x0, :lo12:format_string_double //Add the low 12 bits of format_string_double's address to x0.
        bl      __isoc99_scanf //Call the "__isoc99_scanf" function to read a double from the user.
        ldr     w0, [sp, 860] //Load the loop counter value into w0.
        add     w0, w0, 1 //Increment the loop counter.
        str     w0, [sp, 860] //Store the updated loop counter in memory.
.L2: //label for loop continuation.
        ldr     w0, [sp, 828] //Load the total number of elements into w0.
        ldr     w1, [sp, 860] //Load the loop counter value into w1.
        cmp     w1, w0 //Compare the loop counter to the total number of elements.
        blt     .L3 //If the loop counter is less than the total number, branch to .L3.
        mov     w0, 1 // Set w0 to 1.
        str     w0, [sp, 856] //Store the result in memory
        b       .L4 //Branch to .L4 label to continue the program.
.L7: //Local label for another loop
        ldr     d1, [sp, 24] //Load the largest element found so far into d1 (64-bit float).
        ldrsw   x0, [sp, 856] //Load the loop counter value into x0 (sign-extended).
        lsl     x0, x0, 3 //Multiply x0 by 8 (shift left by 3) to calculate the array index.
        add     x1, sp, 24 //Set x1 to the base address of the array of numbers.
        ldr     d0, [x1, x0] //Load the current array element into d0 (64-bit float).
        fcmpe   d1, d0 //Compare d1 (largest element) with d0 (current element).
        bmi     .L9 //If d1 < d0, branch to .L9 to update the largest element.
        b       .L5 //Otherwise, branch to .L5.
.L9: //Local label for updating the largest element.
        ldrsw   x0, [sp, 856] //Local label for updating the largest element.
        lsl     x0, x0, 3 //Load the loop counter value into x0 (sign-extended).
        add     x1, sp, 24 //Set x1 to the base address of the array of numbers.
        ldr     d0, [x1, x0] //Load the current array element into d0 (64-bit float).
        str     d0, [sp, 24] //Store the new largest element in memory.
.L5: //Local label for loop continuation.
        ldr     w0, [sp, 856] //Load the loop counter value into w0.
        add     w0, w0, 1 //Increment the loop counter.
        str     w0, [sp, 856] //Store the updated loop counter in memory.
.L4: //Local label for loop continuation
        ldr     w0, [sp, 828] //Load the total number of elements into w0.
        ldr     w1, [sp, 856] //Load the loop counter value into w1.
        cmp     w1, w0 //Compare the loop counter to the total number of elements.
        blt     .L7 //If the loop counter is less than the total number, branch to .L7.
        ldr     d0, [sp, 24] //Load the largest element found into d0.
        adrp    x0, output_largest_element //Load the address of output_largest_element into x0.
        add     x0, x0, :lo12:output_largest_element //Add the low 12 bits of output_largest_element's address to x0.
        bl      printf //Call the "printf" function to print the largest element message.
        bl      clock //Call the "clock" function to record the ending time.
        str     x0, [sp, 840] //Store the result of the "clock" function in memory.
        ldr     x1, [sp, 840] //Load the ending time into x1.
        ldr     x0, [sp, 848] //Load the starting time into x0.
        sub     x0, x1, x0 //Subtract the starting time from the ending time to calculate the time elapsed.
        fmov    d0, x0 //Convert the result to a 64-bit floating-point value in d0.
        scvtf   d0, d0 //Convert the integer value in d0 to a floating-point value in d0.
        mov     x0, 145685290680320 //Load a constant integer value into x0.
        movk    x0, 0x412e, lsl 48 //Load a 64-bit constant integer value into x0.
        fmov    d1, x0 //Convert the constant integer in x0 to a 64-bit floating-point value in d1.
        fdiv    d0, d0, d1 //Divide d0 by d1 and store the result in d0.
        str     d0, [sp, 832] //Store the result in memory.
        ldr     d0, [sp, 832] //Load the time elapsed into d0.
        adrp    x0, output_cpu_time //Load the address of output_cpu_time into x0.
        add     x0, x0, :lo12:output_cpu_time //Add the low 12 bits of output_cpu_time's address to x0.
        bl      printf //Call the "printf" function to print the time message.
        mov     w0, 0 //Set w0 to 0.
        ldp     x29, x30, [sp] //Restore the previous frame pointer and link register from the stack.
        add     sp, sp, 864 //Deallocate the stack space.
        .cfi_restore 29
        .cfi_restore 30
        .cfi_def_cfa_offset 0
        ret //Return from the "main" function.
        .cfi_endproc //End of the call frame information.
.LFE0: //Local function end label.
        