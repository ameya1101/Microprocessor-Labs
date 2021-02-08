.model tiny
.486
.data
ARRAY DD 12345678h, 44444444h, 55555555h
COUNT EQU 2
.code
.startup
        LEA EBX, ARRAY
        MOV CL, COUNT
        MOV EAX, [EBX]
        ADD EBX, 4
    XA: CMP EAX, [EBX]
        JGE XB
        MOV EAX, [EBX]
    XB: ADD EBX, 4
        DEC CL
        JNZ XA
        MOV ESI, EAX
.exit
end