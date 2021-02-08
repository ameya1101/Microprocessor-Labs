.model tiny
.486
.data
NUMS DD 00001234h, 0000ABBAh
.code
.startup
    LEA EBX, NUMS
    MOV EAX, [EBX]
    ADD EBX, 0004h
    ADD EAX, [EBX]
    ADD EBX, 0004h
    MOV [EBX], EAX
.exit
end