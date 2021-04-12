.model tiny
.486
.data

file1   db  'mon.txt',0
handl1  dw  ?
dat1    db  ?
dat2    db  ? 

attr    db   0
modec   db  ?

.code
.startup

        ; Take user input and generate attribute
        MOV AH, 08h
        INT 21h
        
        ; If input is invalid, exit
        CMP AL, '8'
        JGE done

        CMP AL, '1'
        JL done

        SUB AL, '0'
        MOV attr, AL

        ; Open file
        MOV AH, 3Dh
        MOV AL, 2
        LEA DX, file1
        INT 21h
        MOV handl1, AX

        ; Move file pointer to 6th position in file
        MOV AH, 42h
        MOV AL, 0
        MOV BX, handl1
        XOR CX, CX
        MOV DX, 5d
        INT 21h

        ; Read char1
        MOV AH, 3Fh
        MOV BX, handl1
        MOV CX, 1d
        LEA DX, dat1
        INT 21h

        ; Move file pointer to 12th position in file
        MOV AH, 42h
        MOV AL, 0
        MOV BX, handl1
        XOR CX, CX
        MOV DX, 11d
        INT 21h

        ; Read char2
        MOV AH, 3Fh
        MOV BX, handl1
        MOV CX, 1d
        LEA DX, dat2
        INT 21h

        ; Close the file
        MOV AH, 3Eh
        MOV BX, handl1
        INT 21h

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
        
        ; Print char
        MOV AH, 09h
        MOV AL, dat1
        MOV BL, attr
        MOV BH, 0
        MOV CX, 1
        INT 10h

        ; Move cursor to bottom-right of the screen
        MOV AH, 02h
        MOV DL, 79
        MOV DH, 24
        MOV BH, 0
        INT 10h
        
        ; Print char
        MOV AH, 09h
        MOV AL, dat2
        MOV BL, attr
        MOV BH, 0
        MOV CX, 1
        INT 10h
        

        ; Blocking function '@'
match:  MOV AH, 08h
        INT 21h
        CMP AL, '@'
        JNE match
    
      ; Restoring original mode 
        MOV AL, modec
        MOV AH, 0
        INT 10h

done:

.exit
end


