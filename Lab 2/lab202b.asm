.model tiny
.486
.data
NUM1 DD 1h, 2h, 3h, 4h
NUM2 DD 0h, 0Ah, 0Bh, 0Ch
COUNT EQU 4d
.code
.startup
        LEA ESI, NUM1
        LEA EDI, NUM2
        MOV ECX, COUNT
        MOV BL, 0
        CLC
    X1: MOV AX, [ESI]
        ADC [EDI], AX
        INC ESI
        INC ESI
        INC ESI
        INC ESI
        INC EDI
        INC EDI
        INC EDI
        INC EDI
        DEC ECX
        JNZ X1
        JNC X2
        INC BL
    X2: MOV [EDI], BL
.exit
end