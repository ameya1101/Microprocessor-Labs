.model tiny
.486
.data
ARRAY1 DW 0FA22h, 2A11h, 97AAh, 0ABCDh, 0FA99h, 7923h, 4200h
COUNT DB 7h
NEG1 DB 0h

.code
.startup
        LEA BX, ARRAY1
        MOV CL, COUNT
    X1: MOV AX, [BX]
        CMP AX, 0000h
        JGE X2
        INC BYTE PTR[NEG1]
    X2: ADD BX, 2h
        DEC CL
        JNZ X1

.exit
end