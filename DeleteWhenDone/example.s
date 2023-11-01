.section .data
MAX_SIZE = 10000
x:
    .fill MAX_SIZE, 4, 0
newline:
    .string "\n"
sorted_text:
    .string "\n\nsorted array:"
time_text:
    .string "\n\nTime in sorting %d values using quicksort algorithm is %f milliseconds"

.section .bss
num_items: .space 4
first: .space 4
last: .space 4
pivot: .space 4
pivot_value: .space 4
temp: .space 4
i: .space 4
time_taken: .space 8

.section .text
.globl main

# Function to print an integer
print_int:
    pushl %ebp
    movl %esp, %ebp
    pushl %eax
    pushl %ecx
    pushl %edx
    movl 8(%ebp), %eax
    movl $0, %ecx
    movl $10, %edx
.loop:
    xorl %edx, %edx
    divl %edx
    addl $48, %edx
    pushl %edx
    incl %ecx
    testl %eax, %eax
    jnz .loop
.print_loop:
    popl %edx
    movl %edx, (%eax)
    incl %eax
    decl %ecx
    jnz .print_loop
    movl %eax, %ecx
    popl %eax
    popl %edx
    popl %ecx
    popl %ebp
    ret

# Function to print a string
print_string:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    movl 8(%ebp), %esi
.loop:
    movzbl (%esi), %eax
    testb %al, %al
    jz .done
    pushl %eax
    call print_char
    addl $1, %esi
    popl %eax
    jmp .loop
.done:
    popl %esi
    popl %ebp
    ret

# Function to print a character
print_char:
    pushl %eax
    pushl %ecx
    pushl %edx
    movl $4, %eax
    movl $1, %ebx
    movl 8(%esp), %ecx
    movl $1, %edx
    int $0x80
    popl %edx
    popl %ecx
    popl %eax
    ret

# Function to generate a random number
rand:
    movl $1, %eax
    int $0x80
    ret

# Function to initialize the random seed
srand:
    movl $0, %eax
    int $0x80
    ret

# Function to get the current clock time
clock:
    movl $14, %eax
    int $0x80
    ret

# Function to exit the program
exit:
    movl $1, %eax
    int $0x80

main:
    call srand  # Initialize random seed
    movl $MAX_SIZE, num_items  # Set num_items to MAX_SIZE

    # Fill the array with random numbers and print the unsorted array
    movl $0, i
fill_loop:
    cmpl num_items, i
    jge sort_array
    pushl i
    call rand
    movl %eax, temp
    popl i
    movl temp, x(,%i,4)  # x[i] = rand()
    pushl x(,%i,4)
    call print_int
    call print_string
    jmp fill_loop

sort_array:
    movl $0, first
    movl num_items, last
    subl $1, last
    pushl last
    pushl first
    pushl x
    call quick_sort
    addl $12, %esp

    # Print the sorted array
    call print_string
    movl $0, i
print_loop:
    cmpl num_items, i
    jge calculate_time
    pushl i
    pushl x(,%i,4)
    call print_int
    call print_string
    popl i
    incl i
    jmp print_loop

calculate_time:
    call clock
    movl %eax, t
    subl t, %eax
    movl $1000, %ecx  # CLOCKS_PER_SEC
    imull %ecx, %eax
    movl %eax, time_taken

    # Print the time it took to sort the values
    pushl time_taken
    pushl MAX_SIZE
    call print_time

    # Exit
    call exit

# Quick Sort Function
quick_sort:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %eax  # x
    movl 16(%ebp), first
    movl 20(%ebp), last

    cmpl first, last
    jge .quick_sort_done

    pushl last
    pushl first
    pushl %eax
    call partition
    addl $8, %esp

    movl %eax, pivot

    pushl pivot
    pushl first
    pushl %eax
    call quick_sort
    addl $8, %esp

    movl pivot, %eax
    incl %eax
    movl %eax, first

    pushl last
    pushl %eax
    pushl %eax
    call quick_sort
    addl $8, %esp

.quick_sort_done:
    popl %ebp
    ret

# Partition Function
partition:
    pushl %ebp
    movl %esp, %ebp
    movl 12(%ebp), %eax  # x
    movl 16(%ebp), first
    movl 20(%ebp), last

    movl first, pivot
    movl first, i

    movl x(,%first,4), %eax  # pivot_value
    movl %eax, pivot_value

.partition_loop:
    cmpl last, i
    jg .partition_done

    movl x(,%i,4), %eax  # x[i]

    cmpl %eax, pivot_value
    jge .no_swap

    movl x(,%pivot,4), %eax  # x[pivot]
    movl %eax, temp
    movl x(,%i,4), %eax  # x[i]
    movl %eax, x(,%pivot,4)
    movl temp, x(,%i,4)

    incl pivot

.no_swap:
    incl i
    jmp .partition_loop
