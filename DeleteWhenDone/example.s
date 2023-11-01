.section .data
hello_message:
    .ascii "Hello, World!\n"   // The message to be printed
message_len = . - hello_message  // Calculate the message length

.section .text
.global _start

_start:
    // Prepare syscall arguments
    mov r0, #1                // File descriptor for stdout (1)
    ldr r1, =hello_message    // Pointer to the message
    ldr r2, =message_len      // Message length

    // Make a syscall to write the message to the console
    mov r7, #4                // syscall number for write
    swi 0                     // Invoke the syscall

    // Exit the program
    mov r7, #1                // syscall number for exit
    mov r0, #0                // Exit status
    swi 0                     // Invoke the syscall
