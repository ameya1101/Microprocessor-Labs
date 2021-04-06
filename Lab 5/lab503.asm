.model tiny
.486
.data

modec   db  ?
att     db  04h
strow   dw  80
stcol   dw  70
enrow   dw  180
encol   dw  150

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

        ; Starting row number in DX and column number in CX
        MOV DX, strow
X2:     MOV CX, stcol
        ; Display a pixel
X1:     MOV AL, att
        MOV AH, 0Ch
        INT 10h
        INC CX
        CMP CX, encol
        JNZ X1

        ; Move to next row once all cols in a row are filled
        INC DX
        CMP DX, enrow
        JNZ X2

        ; Blocking function 'e'
X3:     MOV AH, 08h
        INT 21h
        CMP AL, 'e'
        JNZ X3

        ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h

    
.exit
end


