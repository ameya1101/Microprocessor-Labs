.model tiny
.486
.data
    filename db  'ID.txt', 0
.code
.startup
    MOV AH, 41h
    LEA DX, filename
    INT 21h
.exit
end