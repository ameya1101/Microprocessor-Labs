.model tiny
.486
.data
    file1 db  'p6.txt', 0
    handl1 dw ?
    filcontents db 100 DUP ('$')
.code
.startup
    ; Take input from user
    MOV AH, 08h
    INT 21h

    SUB AL, '0' ; Convert to decimal
    MOV AH, 10d
    MUL AH ; Multiply by 10
    XOR BX, BX
    MOV BL, AL

    ; Open file
    MOV AH, 3Dh
    MOV AL, 0h
    LEA DX, file1
    INT 21h
    MOV handl1, AX

    ; Move file pointer
    MOV AH, 42h
    MOV AL, 0h
    XOR CX, CX
    MOV CL, BL
    MOV DX, CX
    MOV CX, 0
    MOV BX, handl1
    INT 21h

    ; Read File
    MOV AH, 3Fh
    MOV CX, 5d
    MOV BX, handl1
    LEA DX, filcontents
    INT 21h

    ; Output String
    LEA DX, filcontents
    MOV AH, 09h
    INT 21h
.exit
end