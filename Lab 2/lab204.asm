.model tiny
.486

.data
ARRAY1 DW 0FA22h, 2A11h, 97AAh, 0ABCDh, 0FA99h, 7923h, 4200h
COUNT DW 7
NEG1 DB 0h

.code
.startup
        LEA SI, ARRAY1
        MOV CX, [COUNT]
        CLD
AGAIN:  LODSW
        CMP AX, 0000
        JGE POS
        INC BYTE PTR [NEG1]
POS:    LOOP AGAIN
.exit
end