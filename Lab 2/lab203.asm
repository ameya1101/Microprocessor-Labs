.model tiny
.486
.data
ARRAY1 DB 11h, 15h, 1Fh, 0Ah, 91h, 47h, 2Fh, 44h, 42h, 22h
KEY EQU 0Ah
VALUE EQU 'E'
COUNT EQU 10

.code
.startup
        LEA BX, ARRAY1
        MOV CL, COUNT
        MOV AH, VALUE
    XA: MOV AL, [BX]
        CMP AL, KEY
        JNE XB
        MOV [BX], AH
    XB: INC BX
        DEC CL
        JNZ XA

.exit
end