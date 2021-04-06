.model tiny
.486
.data

modec   db  ?
disp    db  "DOLL"

.code
.startup
        ; Get current mode
        MOV AH, 0Fh
        INT 10h
        MOV modec, AL

        ; Set text mode - 80cols, 25 rows
        MOV AH, 00
        MOV AL, 03h
        INT 10h

        ; Move cursor to a position to display, say center of display
        ; Middle of 25x80 - row 12 (count from 0), col 37 (I want to print 4 chars)
        LEA SI, disp
        MOV DI, LENGTHOF disp
        MOV DH, 12d
        MOV DL, 37d

    X1: MOV AH, 02h
        INT 10h

        ; Displaying a character
        MOV AH, 09h
        LODSB
        MOV BL, 10001111b
        MOV BH, 0
        MOV CX, 1
        INT 10h

        INC DL
        DEC DI
        JNZ X1

        ; Blocking function
    X2: MOV AH, 08h
        INT 21h
        CMP AL, 'x'
        JNE X2

        ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h
.exit
end


