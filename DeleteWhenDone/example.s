    // first_asm.s; Defines a main function to add 2 numbers; 
    // data sector is for initialized variables and constants
    .data
    // text sector is for the actual code;
    .text
    .global  main                         // start the assembly code;

     main: 
                  MOV      X1, #8         // put the first value  in register R1;
                  MOV      X2, #9         // put the second value in register R2;
                  ADD      X0, X1, X2     // add X0 = X1 + X2;
                  RET             // end program; return to previous instruction; LR: Link Reg.



