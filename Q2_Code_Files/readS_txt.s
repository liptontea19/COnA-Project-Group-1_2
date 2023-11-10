.LC0:
        .string "r"                 ; Define a string literal "r" (file mode)
        .align  3

.LC1:
        .string "data.txt"          ; Define a string literal "data.txt" (file name)
        .align  3

.LC2:
        .string "Error! File cannot be opened."  ; Define an error message string
        .align  3

.LC3:
        .string "%[^\n]"            ; Define a format string for fscanf
        .align  3

.LC4:
        .string "Data from the file:\n%s"        ; Define a format string for printf
        .text
        .align  2
        .global main
        .type   main, %function

main:
.LFB6:
        .cfi_startproc
        sub     sp, sp, #1024         ; Allocate 1024 bytes of stack space
        .cfi_def_cfa_offset 1024
        stp     x29, x30, [sp]       ; Store the frame pointer (x29) and link register (x30) on the stack
        .cfi_offset 29, -1024        ; Define CFI (Call Frame Information) offsets for x29 and x30
        .cfi_offset 30, -1016
        mov     x29, sp               ; Set the frame pointer (x29) to the current stack pointer
        adrp    x0, .LC0              ; Load the address of the "r" string literal into x0
        add     x1, x0, :lo12:.LC0    ; Add the low 12 bits of .LC0 to x0
        adrp    x0, .LC1              ; Load the address of the "data.txt" string literal into x0
        add     x0, x0, :lo12:.LC1    ; Add the low 12 bits of .LC1 to x0
        bl      fopen                 ; Call the fopen function to open the file
        str     x0, [sp, 1016]        ; Store the file pointer in memory at [sp + 1016]
        ldr     x0, [sp, 1016]        ; Load the file pointer from memory into x0
        cmp     x0, 0                 ; Compare the file pointer to 0 (check if it's null)
        bne     .L2                   ; Branch to label .L2 if not equal (file opened successfully)
        adrp    x0, .LC2              ; Load the address of the error message string into x0
        add     x0, x0, :lo12:.LC2    ; Add the low 12 bits of .LC2 to x0
        bl      printf                ; Call the printf function to print the error message
        mov     w0, 1                 ; Set the return code to 1 (indicating an error)
        bl      exit                  ; Call the exit function to exit the program

.L2:
        add     x0, sp, 16            ; Set x0 to the address of a buffer in the stack
        mov     x2, x0                ; Copy the address to x2
        adrp    x0, .LC3              ; Load the address of the format string for fscanf
        add     x1, x0, :lo12:.LC3    ; Add the low 12 bits of .LC3 to x1
        ldr     x0, [sp, 1016]        ; Load the file pointer from memory into x0
        bl      __isoc99_fscanf       ; Call the fscanf function to read data from the file
        add     x0, sp, 16            ; Set x0 to the address of the buffer again
        mov     x1, x0                ; Copy the address to x1
        adrp    x0, .LC4              ; Load the address of the format string for printf
        add     x0, x0, :lo12:.LC4    ; Add the low 12 bits of .LC4 to x0
        bl      printf                ; Call the printf function to print the data
        ldr     x0, [sp, 1016]        ; Load the file pointer from memory into x0
        bl      fclose                ; Call the fclose function to close the file
        mov     w0, 0                 ; Set the return code to 0 (indicating success)
        ldp     x29, x30, [sp]        ; Restore the frame pointer and link register from the stack
        add     sp, sp, 1024          ; Deallocate the stack space
        .cfi_restore 29               ; Restore CFI information for x29 and x30
        .cfi_restore 30
        .cfi_def_cfa_offset 0         ; Reset the CFA (Canonical Frame Address)
        ret                           ; Return from the main function
        .cfi_endproc                  ; End of CFI information
