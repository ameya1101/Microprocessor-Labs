.model tiny
.486
.data
    file2   db  'file2.txt',0
    handl2  dw  ?
    maxlen  db  40
    actlen  db  ?
    inp     db  40 DUP (?)
    
.code
.startup
    ; Create an new file
    MOV AH, 3Ch
    LEA DX, file2
    MOV CL, 20h
    INT 21h
    MOV handl2, AX

    ; Open file in write mode
    MOV AH, 3DH
    MOV AL, 1H
    LEA DX, file2

    ; Take user input
    LEA DX, maxlen
    MOV AH, 0Ah
    INT 21h

    ; write to the file
    MOV AH, 40h
    MOV BX, handl2
    XOR CX, CX
    MOV CL, actlen
    LEA DX, inp
    INT 21h
    
    ; Close the file
    MOV AH, 3Eh
    MOV BX, handl2
    INT 21h
.exit
end