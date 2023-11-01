.section .data
hello_message:
    .ascii "Hello, World!\n"
    message_len = . - hello_message

.section .text
.global _start

_start:
    // Prepare the syscall arguments
    mov x0, 1          // File descriptor for stdout (1)
    ldr x1, =hello_message  // Pointer to the message
    mov x2, message_len // Message length

    // Call the write syscall (syscall number 64 on AArch64)
    mov x8, 64         // syscall number for write
    svc 0              // Make the syscall

    // Exit the program (syscall number 93 on AArch64)
    mov x8, 93         // syscall number for exit
    mov x0, 0          // Exit status
    svc 0              // Make the syscall
