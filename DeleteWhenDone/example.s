.data
.text
.global main
.extern printf

main:
    SUB sp,sp,#16
    STR X30,[sp]
    LDR X0, =string
    BL printf
    LDR X30,[sp]
    ADD sp,sp,#16
    RET