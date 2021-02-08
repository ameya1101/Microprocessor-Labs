.model tiny
.486
.data
NUMS DW 1234h, 0ABBAh
.code
.startup
    LEA BX, NUMS
    MOV AX, [BX]
    ADD BX, 0002h
    ADD AX, [BX]
    ADD BX, 0002h
    MOV [BX], AX
.exit
end