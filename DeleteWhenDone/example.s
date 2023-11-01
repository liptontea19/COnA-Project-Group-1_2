.section .data
MAX_SIZE = 10000
x: .skip MAX_SIZE, 8    

.section .text
.global _start

_start:
    // Initialize stack pointer and call the quick_sort function
    mov x0, sp
    ldr x1, =0
    ldr x2, =MAX_SIZE
    bl quick_sort

    // Add code to measure and print execution time here

    // Exit the program
    mov x8, #93   // __NR_exit
    mov x0, #0
    svc #0

quick_sort:
    stp x29, x30, [sp, -16]!  // Push the link register and frame pointer onto the stack
    mov x29, sp               // Set up the new frame pointer

    ldr x3, [x0]              // Load the base address of the array
    cmp x2, x1                // Compare first and last indices
    bge .L1                   // If first >= last, return

    // Call the partition function
    bl partition

    // Recursively call quick_sort on the left and right partitions
    ldr x4, [sp, #16]         // Load the first argument (base address) from the stack
    mov x2, x5                // Update 'last' with the pivot index - 1
    bl quick_sort

    ldr x4, [sp, #16]         // Load the first argument (base address) from the stack
    mov x1, x5                // Update 'first' with the pivot index + 1
    ldr x6, [sp, #16]         // Load the third argument (last) from the stack
    bl quick_sort

    // Pop the frame and link register, and return
.L1:
    ldp x29, x30, [sp], 16
    ret

partition:
    stp x29, x30, [sp, -16]!  // Push the link register and frame pointer onto the stack
    mov x29, sp               // Set up the new frame pointer

    ldr x3, [x0]              // Load the base address of the array
    ldr x4, [x1]              // Load the pivot index
    ldr x5, [x3, x4, lsl #3]  // Load the pivot value

    // Partition the array into two sub-arrays
    mov x6, x1                // i = first
    sub x7, x2, #1            // j = last - 1

.L2:
    ldr x8, [x3, x6, lsl #3]  // Load x[i]
    ldr x9, [x3, x7, lsl #3]  // Load x[j]

    // Compare x[i] and pivot value
    cmp x8, x5
    bge .L3

    // Swap x[i] and x[j]
    str x9, [x3, x6, lsl #3]
    str x8, [x3, x7, lsl #3]

.L3:
    // Update i and j
    add x6, x6, #1
    sub x7, x7, #1

    // Check if i <= j
    cmp x6, x7
    b.le .L2

    // Swap x[i] and pivot value
    str x5, [x3, x6, lsl #3]
    str x8, [x3, x4, lsl #3]

    // Return the pivot index
    mov x0, x6

    // Pop the frame and link register, and return
    ldp x29, x30, [sp], 16
    ret
