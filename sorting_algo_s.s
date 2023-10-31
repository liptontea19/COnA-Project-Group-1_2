.section .data
hello_string:    .asciz "Hello, World!\n"

.section .text
.global _start

_start:
    @ Write "Hello, World!" to stdout
    mov r0, #1
    ldr r1, =hello_string
    ldr r2, =13
    mov r7, #4
    swi 0

    @ Exit the program
    mov r7, #1
    swi 0
