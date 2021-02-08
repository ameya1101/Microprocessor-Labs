.model tiny
.486
.data
NUM1 DW 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h
NUM2 DW 0h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
COUNT EQU 8d
.code
.startup
        LEA SI, NUM1
        LEA DI, NUM2
        MOV CX, COUNT
        MOV BL, 0
        CLC
    X1: MOV AX, [SI]
        ADC [DI], AX
        INC SI
        INC SI
        INC DI
        INC DI
        DEC CX
        JNZ X1
        JNC X2
        INC BL
    X2: MOV [DI], BL
.exit
end