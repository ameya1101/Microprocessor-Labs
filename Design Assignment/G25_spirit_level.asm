#make_bin#

; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.

; All directives are optional, if you don't need them, delete them.

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0000h#	; same as loading segment
#IP=0000h#	; same as loading offset

; set segment registers
#DS=0000h#	; same as loading segment
#ES=0000h#	; same as loading segment

; set stack
#SS=0000h#	; same as loading segment
#SP=FFFEh#	; set to top of loading segment

; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

        JMP INIT
        NOP         
                 ; INT 1: Stop button
         dw      STOP_ISR  
         dw      0000               
                 ; INT 2: Counter 2 from 8253
         dw      C2_ISR
         dw      0000                        
                 ; INT 3: Start button            
         dw      START_ISR
         dw      0000                 
                 ; INT 4-7: Prevent Proteus malfunction
         dw      RANDOM_IR
         dw      0000
         dw      RANDOM_IR
         dw      0000
         dw      RANDOM_IR
         dw      0000
         dw      RANDOM_IR
         dw      0000
;int 8 to int 255 unused so ip and cs intialized to 0000
;from 3x4 = 0000cH		 
		 db     992 dup(0)
       
INIT:   CLI
        ; Initialize segment registers
        MOV AX, 0200h
        MOV DS, AX
        MOV ES, AX
        MOV SS, AX
        MOV SP, 0FFEh
        MOV SI, 0  
            
 
        ; Initialize 8255    
        ; Base address: 00h
        ; Port A: Mode 0 Output
        ; PA0 - PA4: 7 Segment display
        ; Port B: Mode 0 Output       
        ; PB0 - PB7: LEDs 2 to 9
        ; Port C Upper: Input  
        ; PC0: LED 1
        ; Port C Lower: Output
        ; PC4: Start
        ; PC5: Stop
        ; Control word goes to base + 06h
        MOV AL, 88h
        OUT 06h, AL 
            
        CALL DISPLAY_OFF
        
        ; INITIALIZE 8259
        ; Base address: 10h
        ; ICW1 = 00010011b = 13h at 10h
        MOV AL, 13h
        OUT 10h, AL
        ; ICW2 = 00000000b = 00h at 12h
        MOV AL, 00h
        OUT 12h, AL
        ; ICW3 = xx
        ; ICW4 = 00000001b = 01h at 12h
        MOV AL, 01h
        OUT 12h, AL
        ; OCW1 = 00000001b = 01h at 12h
        ; OCW2 = xx
        
        
        ; Initialize 8253
        ; Base address: 08h                                     
        ; Control word address: 0Eh
        ; C0 CW: 00010100b = 14h (C0, write LSB, mode 2, binary)
        MOV AL, 14h
        OUT 0Eh, AL
        ; LSB for C0: 160d = A0h
        MOV AL, 160d
        OUT 08h, AL  
        
        ; C1 CW: 01110100b = 74h (C1, write LSB and MSB, mode 2, binary)
        MOV AL, 74h
        OUT 0Eh, AL 
        
        ; C2 CW: 10110100b = B4h (C2, write LSB and MSB, mode 2, binary)
        MOV AL, 0B4h
        OUT 0Eh, AL
                 
        ; Use CL for LED_count
        MOV CL, 0 
        ; Use CH for LED_B
        MOV CH, 0    
        ; Use DL for system state
        ; 0: System OFF
        ; 1: Start pressed, random counter ON
        ; 2: Random delay over, LED counting ON
        ; 3: Stop pressed / counting maxed out
        MOV DL, 0      

; Infinite loop to wait for interrupts        
X1:     STI   
        JMP X1   
        
       
STOP_ISR:                                                 
        ; Allow interrupts 
        ; so that cheating can be checked
        STI                               
        
        ; But disable Stop IR (IR1)
        MOV AL, 00000010b
        OUT 12h, AL   
        
        ; Wait for 20ms
        PUSH CX
        MOV BL, 1
        CALL DELAY_20MS
        POP CX
        
        ; Read Stop button from port C
        ; at pin C5
        IN AL, 04h                           
        AND AL, 00100000b                    
                                             
        ; Exit if C5 is OFF
        CMP AL, 0
        JE END_STOP_ISR                         
                                                
        ; END OF DEBOUNCE           
          
        ; In state 0 or 1
        CMP DL, 1
        JLE BLINK
        
        ; CMP DL, 2
        ; nothing, just let it continue
        ; to end current run
        
        ; If current run has ended,
        ; do nothing
        CMP DL, 3
        JE END_STOP_ISR
        
        ; Continue to end current run
        ; Turn system OFF because STOP was pressed
        MOV DL, 3
        
        ; And display sobriety
        CALL DISPLAY       
        JMP END_STOP_ISR
        
    BLINK:      

        ; Set system state to 0
        MOV DL, 0

        ; Blink five times
        MOV AH, 5   

        BLINKLOOP:      
                ; Turn ON all LEDs
                IN AL, 04h
                OR AL, 00000001b
                OUT 04h, AL 
                
                MOV AL, 0FFh
                OUT 02h, AL
                
                ; 240ms delay
                PUSH CX
                MOV BL, 12
                CALL DELAY_20MS
                POP CX
                        
                ; Turn OFF all LEDs
                IN AL, 04h
                AND AL, 0F0h
                OUT 04h, AL
                
                MOV AL, 0
                OUT 02h, AL       
                                
                ; 240ms delay
                PUSH CX
                MOV BL, 12
                CALL DELAY_20MS
                POP CX
                
                DEC AH
                JNZ BLINKLOOP
        
    END_STOP_ISR:
        
        ; Reprogram C2 so it stops counting
        ; C2 CW: 10110100b = B4h (C2, write LSB and MSB, mode 2, binary)
        MOV AL, 0B4h
        OUT 0Eh, AL  
                         
        ; Re-enable all IRs
        MOV AL, 00000000b
        OUT 12h, AL      
           
        ; MOV OCW2 for Non specific EOI 
        MOV AL, 00100000b               
        OUT 10h, AL
        IRET
       
C2_ISR:                 
        ; Check state                          
        ; If random counting, turn ON first LED
        CMP DL, 1                              
        JE FIRST_LED
        ; If LED counting, turn ON another LED
        CMP DL, 2
        JE C2_50MS
        ; Else, exit                           
        JMP END_C2_ISR
                   
    FIRST_LED:     
    
        ; Set system state to LED counting
        MOV DL, 2        
                                  
        ; Increment LED_count
        INC CL
        
        ; Turn LED 0 ON at port C
        IN AL, 04h
        OR AL, 00000001b
        OUT 04h, AL 
        
        ; PROGRAM_C1
        ; C1 CW: 01110100b = 74h (C1, write LSB and MSB, mode 2, binary)
        MOV AL, 74h
        OUT 0Eh, AL  
        
        ; Value for C1: F424h   
        MOV AL, 24h
        OUT 0Ah, AL
        MOV AL, 0F4h
        OUT 0Ah, AL
        
        ; PROGRAM C2
        ; C2 CW: 10110100b = B4h (C2, write LSB and MSB, mode 2, binary)
        MOV AL, 0B4h
        OUT 0Eh, AL
        
        ; Start C2
        MOV AL, 1      ; For counting two cycles of C1
        OUT 0Ch, AL    ; to generate a regular 50ms interrupt
        MOV AL, 0
        OUT 0Ch, AL     
                      
        ; Exit
        JMP END_C2_ISR
        
    C2_50MS:
       
        ; Check if all LED are ON
        ; If not, turn on another
        MOV AL, CL
        CMP AL, 9d
        JL ONE_MORE 
        
        ; Set system state OFF because counting has maxed out
        MOV DL, 3     
                   
        ; Reprogram C2 so it stops counting
        ; C2 CW: 10110100b = B4h (C2, write LSB and MSB, mode 2, binary)
        MOV AL, 0B4h
        OUT 0Eh, AL                  
        
        ; And display sobriety
        CALL DISPLAY
                 
        JMP END_C2_ISR    
        
    ONE_MORE:       
        ; If no; turn ON another LED 
        
        ; Increment LED count
        INC CL                      
        
        ; Shift to turn on port B LED
        SHL CH, 1
        INC CH   
        MOV AL, CH  
        OUT 02h, AL
       
    END_C2_ISR:
        
        ; MOV OCW2 for Non specific EOI 
        MOV AL, 00100000b               
        OUT 10h, AL
        IRET
        
 
START_ISR:                                         
        ; Allow interrupts 
        ; so that cheating can be checked
        STI                               
        
        ; But disable Start IR (IR3)
        MOV AL, 00001000b
        OUT 12h, AL   
        
        ; Wait for 20ms
        PUSH CX
        MOV BL, 1
        CALL DELAY_20MS
        POP CX
        
        ; Read Start button from port C
        ; at pin C4
        IN AL, 04h
        AND AL, 00010000b
          
        ; Exit if C4 is OFF
        CMP AL, 0
        JE END_START_ISR   
        
        ; END OF DEBOUNCE
        
        ; Check system state      
        ; If random counting, exit
        CMP DL, 1
        JE END_START_ISR         
        ; If LED counting, exit
        CMP DL, 2
        JE END_START_ISR
                                  
        ; Set system state ON, random counting ON
        MOV DL, 1
        
        ; TURN OFF ALL LEDs
        MOV CL, 0
        MOV CH, 0

        CALL DISPLAY_OFF
        
        ; Read random counter value
        ; Latch the count using control word
        MOV AL, 0
        OUT 0Eh, AL
        ; then read from counter 0 address
        IN AL, 08h
        MOV BL, AL
        IN AL, 08h
        MOV BH, AL
        
        ; RESTART C0 (Only required in Proteus)
        ; C0 CW: 00010100b = 14h (C0, write LSB, mode 2, binary)
        MOV AL, 14h
        OUT 0Eh, AL
        ; LSB for C0: 160d = A0h
        MOV AL, 0A0h
        OUT 08h, AL                          
        
        ; START C1        
        ; Value for C1: F424h   
        MOV AL, 24h
        OUT 0Ah, AL
        MOV AL, 0F4h
        OUT 0Ah, AL
        
        ; Reprogram and Start C2, wait for initial delay   
        ; C2 CW: 10110100b = B4h (C2, write LSB and MSB, mode 2, binary)
        MOV AL, 0B4h
        OUT 0Eh, AL
        MOV AX, 160d     ; 160d
        ADD AX, BX       ; C2 value is 160d + C0 readout
        OUT 0Ch, AL
        MOV AL, AH
        OUT 0Ch, AL 
    
    END_START_ISR:  
         
        ; Re enable Start IR (IR3)
        MOV AL, 00000000b
        OUT 12h, AL 
                    
        ; MOV OCW2 for Non specific EOI 
        MOV AL, 00100000b               
        OUT 10h, AL
        IRET
        
 
DISPLAY_OFF PROC NEAR
        ; Turn off 7 Segment Display
        MOV AL, 10000b
        OUT 00h, AL
        
        ; Turn off all LEDs         
        ; Turn off port B LEDs
        MOV AL, 0
        OUT 02h, AL                 
        
        ; Turn off bottom LED at port C
        IN AL, 04h
        AND AL, 11110000b
        OUT 04h, AL
        
        RET
DISPLAY_OFF ENDP

        
DISPLAY PROC NEAR       
    
        ; LED# -> Score
        ; 3 -> 5
        ; 5 -> 4
        ; 6 -> 3
        ; 7 -> 2
        ; 9 -> 1        
        
        MOV AL, 5
        
        ; CMP LED_count, 3
        CMP CL, 3
        JLE SEND_TO_7447
        DEC AL
        
        CMP CL, 5
        JLE SEND_TO_7447
        DEC AL
        
        CMP CL, 6
        JLE SEND_TO_7447
        DEC AL
        
        CMP CL, 7
        JLE SEND_TO_7447
        DEC AL
        
        
    SEND_TO_7447: 
        ; Send that to 7 Segment Display 
        OUT 00h, AL
        
        RET
DISPLAY ENDP

DELAY_20MS PROC NEAR            
; Takes a multiplicative factor in BL
; Generates delay of BL * 20ms
; Remember to push CX first!

; Delay Calculation

; LOOP
; 18 cycles if CX is not zero
; 5 cycles when CX becomes zero
; Total = 18 * (CX - 1) + 5                                           

; RET = 16 cycles
; CALL = 19 cycles
; MOV = 4 cycles

; Clock speed = 5MHz => 1 clock cycle = 0.2us

; Total delay needed = 20ms
; 20ms = (16 + 19 + 4 + 5 + 18 * (CX - 1)) * 0.2us

; 20ms / 0.2us = 26 + 18*CX
; CX = (100000 - 26) / 18 = 5555

    XM: MOV CX, 5555 
    XN: LOOP XN 
        DEC BL
        JNZ XM
    
        RET
        
DELAY_20MS ENDP
                 
           
; Do nothing and go back to wherever it came from
; Required because 8259 in Proteus
; sometimes fires random interrupts      
RANDOM_IR:  
        ; MOV OCW2 for Non specific EOI 
        MOV AL, 00100000b               
        OUT 10h, AL
        IRET       