.model tiny
.486

.data
ARRAY1 DB 11h, 15h, 1Fh, 0Ah, 91h, 47h, 0Ah, 44h, 42h, 22h
KEY EQU 0Ah
VALUE EQU 'E'
COUNT EQU 10

.code
.startup
        LEA DI, ARRAY1
        MOV CX, COUNT
        MOV AL, KEY
        MOV AH, VALUE
        CLD
AGAIN: REPNE SCASB
        JNE DONE
        DEC DI
        MOV [DI], AH
        JMP AGAIN
DONE:   MOV BX, 0FFFFh
.exit
end