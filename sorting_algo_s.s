.global main

main:
MOV R0,#3
MOV R1,#0
LOOP:
CMP R0,R1
BEQ END
ADDGT R1,#1
SUBLT R1.#1
B LOOP
END:
BX LR