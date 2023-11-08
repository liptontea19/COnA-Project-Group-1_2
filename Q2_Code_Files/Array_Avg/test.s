.data
string: .asciz "Value is #\n"
string2: .string "Value is %d\n"
var: .int 5

.text 
.global main
main:
    ldr X0, =string
    bl printf   // this works 

    ldr X0, =string2
    mov X1, #42
    bl printf   // this also works

    mov x2, #7

    ldr X0, =string2
    mov X1, x2
    bl printf   // YESSSSSSSSSSS

    
    ret