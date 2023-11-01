//hello_world.s; printf"Hello World!" in assembly code;
//data sector is for initialized variables and constants
.data
string: .asciz "\nHello World!\n" // for printf calls, by GNU assembler’s ".asciz";
//text sector is for the actual code;
.text
.global main //start the assembly code;
.extern printf //external function printf;

main:
    SUB sp,sp,#16 // Store the return address, i.e. link reg. (lr), and
    STR X30, [sp] // Save the return lr to stack.
    
    LDR X0, =string // Load string into X0 to perform procedural call.
    BL printf // branch link to printf, like 'printf("...")' in C.
    
    LDR X30, [sp] // Access the OS
    ADD sp, sp, #16 // get back the lr (link reg.) value, return;
    RET
    