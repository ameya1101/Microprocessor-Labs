.model tiny
.486
.data
    max db 21
    act db ?
    str1 db 21 DUP('$')
.code
.startup
    LEA DX, max
    MOV AH, 0Ah
    INT 21h
    XOR BX, BX
    MOV BL, act
    MOV WORD PTR [str1 + BX], 0D0Ah
    MOV BYTE PTR [str1 + BX + 2], '$'
    LEA DX, str1
    MOV AH, 09h
    INT 21h
.exit
end