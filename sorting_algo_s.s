section .data
    hello db 'Hello, World!',0  ; Define a null-terminated string

section .text
global _start

_start:
    ; Write "Hello, World!" to stdout
    mov eax, 4                 ; System call number for sys_write (4)
    mov ebx, 1                 ; File descriptor for stdout (1)
    mov ecx, hello             ; Pointer to the string to write
    mov edx, 13                ; Length of the string
    int 0x80                   ; Invoke the kernel

    ; Exit the program
    mov eax, 1                 ; System call number for sys_exit (1)
    mov ebx, 0                 ; Exit with status code 0
    int 0x80                   ; Invoke the kernel
