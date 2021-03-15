.model tiny
.486
.data
    file1   db  'file1.txt',0
    name1    db  'Ameya Thete '
    newline db   0Dh, 0Ah
    idno    db  '2018B5A70885G '
    handl1 dw ?

WRITE MACRO DATADDR, HANDLE, DATLEN
    MOV AH, 40h
    MOV BX, HANDLE
    MOV CX, DATLEN
    LEA DX, DATADDR
    INT 21h   
ENDM

APPND MACRO HANDLE
    MOV AH, 42h
    MOV AL, 02h
    MOV BX, HANDLE
    MOV CX, 0000
    MOV DX, CX
ENDM

.code
.startup
    ; Creating the file
    MOV AH, 3Ch
    LEA DX, file1
    MOV CL, 20h
    INT 21h

    ; Open the file in read/write mode
    MOV AH, 3Dh
    MOV AL, 2h
    LEA DX, file1
    INT 21h
    MOV handl1, AX

    ; Write to the file
    WRITE name1, handl1, 12d
    APPND handl1
    WRITE name1, handl1, 12d
    APPND handl1
    WRITE newline, handl1, 2d
    APPND handl1
    WRITE idno, handl1, 14d
    APPND handl1
    WRITE idno, handl1, 14d
    
    ; Close the file
    MOV AH, 3Eh
    MOV BX, handl1
    INT 21h
.exit
end