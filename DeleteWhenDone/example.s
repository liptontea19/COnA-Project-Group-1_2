.data
.text
.global main

main:
    MOV X1,#0
    MOV X2,#0
LOOP:
    CMP X1,#4
    BEQ END
    ADD X1,X1,#1
    ADD X2,X2,X1
    B LOOP
END:
    MOV X0,X2
    RET