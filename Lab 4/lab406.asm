.model tiny
.486
.data
    file2   db  'file2.txt',0
    newname db  'ID.txt', 0
    
.code
.startup
    MOV AH, 56h
    LEA DX, file2
    LEA DI, newname
    MOV CL, 20h
    INT 21h
.exit
end