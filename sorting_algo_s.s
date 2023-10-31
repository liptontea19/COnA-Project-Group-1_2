@first_asm.s; Defines a main function to add 2 numbers;
.global main

main:
    MOV R1,#8   @put value 8 in register R1;
    MOV R2,#9   @put value 9 in register R2;
    ADD R0,R1,R2    @add R0=R1+R2
    BX  LR  @end; return result from function