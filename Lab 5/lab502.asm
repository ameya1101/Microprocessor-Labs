.model tiny
.486
.data

space   db  " "
disp    db  ?
counter db  0
modec   db  ?

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
        XOR DX, DX
        MOV BH, 0
        INT 10h

        ; Fill this space with blue background and yellow foreground, use space
        ; as the dummy character for filling
        MOV AH, 09h
        MOV AL, space
        MOV CX, 13 * 80
        MOV BL, 00011110b
        MOV BH, 0
        INT 10h

        ; Move cursor to mid-left
        MOV AH, 02h
        MOV DL, 0
        MOV DH, 13
        MOV BH, 0
        INT 10h

        ; Fill this space with white background and bright green foreground, use space
        ; as the dummy character for filling
        MOV AH, 09h
        MOV AL, space
        MOV CX, 13 * 80
        MOV BL, 01111010b
        MOV BH, 0
        INT 10h

    X1: ; Move cursor to 0,0
        MOV AH, 02h
        MOV DH, 0
        MOV DL, counter
        MOV BH, 0
        INT 10h

        ; Take input
        MOV AH, 07h
        INT 21h
        MOV disp, AL

    X: ; Display Char
        MOV AH, 09h
        MOV BL, 00011110b
        MOV BH, 0
        MOV CX, 1
        INT 10h


     ; Move cursor to (13, 0)
        MOV AH, 02h
        MOV DH, 13
        MOV DL, counter
        MOV BH, 0
        INT 10h

        ; Display that character
        MOV AH, 09h
        MOV AL, disp
        MOV BL, 01111010b
        MOV CX, 1
        INT 10h

        CMP AL, '$'
        JE match

        INC BYTE PTR[counter]

        JMP X1

        ; Blocking function
match:  MOV AH, 08h
        INT 21h
        CMP AL, '#'
        JE done
        MOV disp, AL
        JMP X
    
done: ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h
.exit
end


