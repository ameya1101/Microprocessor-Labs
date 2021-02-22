.model tiny
.486
.data
   strlen db 5
   stract db ?
   str1 db 6 DUP('$')
   nl db 0Dh, 0Ah, '$'
.code
.startup
         ; Accept user input
         LEA DX, strlen
         MOV AH, 0Ah
         INT 21h
         CMP stract, 4 ;Check if user input length is 4 or not. If not, exit. 
         JNE XN
         
         ; Newline
         LEA DX, nl
         MOV AH, 09h
         INT 21h

         ; Print in reverse
         XOR CX, CX
         MOV CL, BYTE PTR [strlen]
         LEA DI, BYTE PTR [str1 + 4]
   AGAIN: MOV DL, [DI]
          MOV AH, 02h
          INT 21h
          DEC DI
          LOOP AGAIN          
   XN:    
.exit
end