.model tiny
.486
.data

space  db  " "
disp    db  ?
counter db  0
modec   db  ?
count   db  1d

.code
.startup
        ; Get current mode
        MOV AH, 0Fh
        INT 10h
        MOV modec, AL

        ; Set text mode - 25x80
        MOV AH, 00
        MOV AL, 03h
        INT 10h

        ; Move cursor to top-left of the screen
        MOV AH, 02h
        MOV DL, 0
        MOV DH, 0
        MOV BH, 0
        INT 10h

        ; Fill this space with red background use space
        ; as the dummy character for filling
        MOV AH, 09h
        MOV AL, space
        MOV CX, 8 * 80
        MOV BL, 01001100b
        MOV BH, 0
        INT 10h

        ; Move cursor to one-third-left of the screen
        MOV AH, 02h
        MOV DL, 0
        MOV DH, 8
        MOV BH, 0
        INT 10h

        ; Fill this space with black background use space
        ; as the dummy character for filling
        MOV AH, 09h
        MOV AL, space
        MOV CX, 8 * 80
        MOV BL, 01110100b
        MOV BH, 0
        INT 10h

        ; Move cursor to last one-third-left of the screen
        MOV AH, 02h
        MOV DL, 0
        MOV DH, 16
        MOV BH, 0
        INT 10h

        ; Fill this space with green background use space
        ; as the dummy character for filling
        MOV AH, 09h
        MOV AL, space
        MOV CX, 8 * 80
        MOV BL, 00101100b
        MOV BH, 0
        INT 10h


        ; Blocking function
match:  MOV AH, 08h
        INT 21h
        CMP AL, '>'
        JNE match
    
      ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h
.exit
end


