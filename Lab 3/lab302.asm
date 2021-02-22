;Write an ALP that does the following

; 1. Display the string “Enter User Name” and goes to the next line
; 2. Takes in the user entered string compares with user name value already stored in memory
; 3. If there is no match it should exit.
; 4. If there is a match it should display the string “Enter Password” and goes to next line
; 5. Takes in password entered by the user and compares with password already stored in memory
; 6. If there is no match it should exit’
; 7. If there is a match it should display “Hello Username”

.model tiny
.486
.data
    usrprmt db "Enter User Name", 0Dh, 0Ah, '$'
    pwdprmt db "Enter Password", 0Dh, 0Ah, '$'
    helloprmt db "Hello $"
    newline db 0Dh, 0Ah, '$'
    usrname db "ameya"
    usrnamelen EQU 5
    pwd db "qwertyui" 
    usrinpmax db 11
    usrinpsize db ? 
    usrinp db 11 DUP(?)
    pwdlen db 8
    pwdinp db 8 DUP(?)
.code
.startup
        ; Username prompt
        LEA DX, usrprmt
        MOV AH, 09h
        INT 21h

        ; User enters the username
        LEA DX, usrinpmax
        MOV AH, 0Ah
        INT 21h

        ; Use CMPS to check if username exists
        LEA SI, usrname
        LEA DI, usrinp
        XOR CX, CX
        MOV CL, usrnamelen
        CALL CHKSTR
        JNC not_found
        CMP CL, 0
        JA not_found

        ; If username exists, ask for password
        LEA DX, pwdprmt
        MOV AH, 09h
        INT 21h

        ; User enters password
        LEA DI, pwdinp
        XOR CX, CX
        MOV CL, pwdlen
        CLD
    PWDIN: MOV AH, 08h
            INT 21h 
            STOSW
            DEC DI
            MOV DL, '*'
            MOV AH, 02h
            INT 21h
            LOOP PWDIN

        ; Use CMPS to check if password exists
        LEA SI, pwd
        LEA DI, pwdinp
        XOR CX, CX
        MOV CL, pwdlen
        CALL CHKSTR
        JNC not_found
        CMP CL, 0
        JA not_found

        ; Password is correct, say hello. 
        LEA DX, newline
        MOV AH, 09h
        INT 21h
        
        LEA DX, helloprmt
        MOV AH, 09h
        INT 21h

        ; Append carriage return and newline to username so it prints properly
        XOR BX, BX
        MOV BL, usrinpsize
        MOV WORD PTR [usrinp + BX], 0D0Ah
        MOV BYTE PTR [usrinp + BX + 2], '$'
        LEA DX, usrinp
        MOV AH, 09h
        INT 21h
    not_found:
.exit

CHKSTR PROC NEAR
        CLD
        CLC
        REPE CMPSB
        JNE not_equal
        STC
not_equal:
        RET    
CHKSTR ENDP

end