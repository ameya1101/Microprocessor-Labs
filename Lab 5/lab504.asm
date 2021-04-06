.model tiny
.486
.data

modec   db  ?
red     db  0Ch
green   db  0Ah
strow   dw  0
stcol   dw  0
enrow   dw  250
encol   dw  150
count   db  3

.code
.startup
        ; Get current mode
        MOV AH, 0Fh
        INT 10h
        MOV modec, AL

        ; Set graphics mode - 80rows, 25 cols
        MOV AH, 00
        MOV AL, 12h
        INT 10h

    ; Loop to print rectangles

X:      

        MOV DX, strow
X2:     MOV CX, stcol
        ; Display a pixel
X1:     
        MOV AL, red
        MOV AH, 0Ch
        INT 10h
        INC CX
        CMP CX, encol
        JNZ X1

        ; Move to next row once all cols in a row are filled
        INC DX
        CMP DX, enrow
        JNZ X2

        ADD strow, 20
        ADD stcol, 20
        SUB enrow, 40
        SUB encol, 40

        MOV DX, strow
X3:     MOV CX, stcol
        ; Display a pixel
X4:     
        MOV AL, green
        MOV AH, 0Ch
        INT 10h
        INC CX
        CMP CX, encol
        JNZ X4

        ; Move to next row once all cols in a row are filled
        INC DX
        CMP DX, enrow
        JNZ X3

        ADD stcol, 20
        ADD strow, 20
        SUB enrow, 40
        SUB encol, 40
        DEC BYTE PTR[count]
        JNZ X

    

        ; Blocking function 'e'
again:  MOV AH, 08h
        INT 21h
        CMP AL, 'e'
        JNZ again

        ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h

    
.exit
end


