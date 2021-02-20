.model tiny
.486
.data
exm1  DB "ZmeyZTheteZicroZroce"
name1 DB "A"
LEN EQU 20
ame85 DB ?

.code
.startup
    XOR AX, AX
    MOV AH, "A"
    SUB AH, name1
    MOV AL, "Z"
    SUB AL, AH
    MOV CX, LEN
    LEA DI, exm1
    CLD
AGAIN: REPNE SCASB
       JNE DONE
       INC BYTE PTR[ame85]
       LOOP AGAIN
DONE:  MOV BX, 0FFFFh
.exit
end