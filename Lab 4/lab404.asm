.model tiny
.486
.data
    file1   db  'file1.txt',0
    handl1 dw ?
    fileread db 65d DUP('$')
.code
.startup
    ; Open the file in read mode
    MOV AH, 3Dh
    MOV AL, 0h
    LEA DX, file1
    INT 21h
    MOV handl1, AX

    ; Read the file
    LEA DX, fileread
    MOV BX, handl1
    
X:  MOV AH, 3Fh
    MOV CX, 1
    INT 21h

    INC DX
    CMP AX, 0
    JNZ X

    ; Output contents of buffer
    LEA DX, fileread
    MOV AH, 09h
    INT 21h
    
    ; Close the file
    MOV AH, 3Eh
    MOV BX, handl1
    INT 21h
.exit
end