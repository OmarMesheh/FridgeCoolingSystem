#include "P16F877A.INC"
  COUN1 equ 0x20
  OFF   equ 0x22
  MIN   equ 0x27
  MID   equ 0x32
  MAX   equ 0x31
EXTERNAL_COUN equ 0x25
INTERNAL_COUN equ 0x23
  FLASH equ 0x50
  TEMP1  equ 0x30
        org 0000
        goto start
        org 0004
        goto ISR

 start 
        bsf STATUS,RP0
        clrf TRISB
        clrf TRISC 
        movlw b'00011111'  ; RC0-RC4 IS INPUT & RC7 IS OUTPUT
        movwf TRISC
        movlw b'11000000' ; RB6&RB7 IS INPUT
        movwf TRISB
        bcf STATUS,RP0
        movf PORTB,0
        bcf INTCON,RBIF
        bSf INTCON,GIE
        bSf INTCON,RBIE
        
        clrf PORTB
        clrf FLASH
        clrf PORTC      
  LOOP  BTFSS FLASH,0
        goto LOOP
        movlw B'00000000'
        movwf OFF
        movlw B'01000000'
        movwf MIN
        movlw B'10000000'
        movwf MID
        movlw B'11000000'
        movwf MAX
  LOOP2 clrf PORTC
        movf PORTC,0
        movwf TEMP1
        movf OFF,0
        subwf PORTB,0
        btfsc STATUS,Z
        CALL CASE_OFF
        movf MIN,0
        subwf PORTB,0
        btfsc STATUS,Z
        CALL CASE_MIN
        movf MID,0
        subwf PORTB,0
        btfsc STATUS,Z
        CALL CASE_MID
        movf MAX,0
        subwf PORTB,0
        btfsc STATUS,Z
        CALL CASE_MAX
        goto LOOP2
;.................................
CASE_OFF  clrf PORTC
          goto LOOP2
          RUTERN

CASE_MIN  
          movlw D'20'
          subwf PORTC,0
          btfss STATUS,C
          goto MA
          movlw B'10000000'
          xorwf PORTC,1
          movlw D'20'
          movwf COUN1  
 COUNTER1 CALL delay_min
          decfsz COUN1,1
          goto COUNTER1
          clrf PORTC
          movlw D'20'
          movwf COUN1
COUNTER1A CALL delay_min
          decfsz COUN1,1
          goto COUNTER1A
          goto LOOP2

      MA   clrf PORTC
          goto LOOP2
 ;DELAY FOR MIN 
delay_min movlw B'01000000'
          subwf PORTB,0
          btfss STATUS,Z
          goto LOOP2
          movf PORTC,0
          andlw b'00011111'
          subwf TEMP1,0
          btfss STATUS,Z
          goto  LOOP2
          movlw D'0'
          movwf EXTERNAL_COUN
          movlw D'244'
          movwf INTERNAL_COUN 
LOOP_NOP  NOP
          NOP     
          NOP
          NOP
          NOP
          
          
          decfsz EXTERNAL_COUN,1
          goto LOOP_NOP
          decfsz INTERNAL_COUN 
          goto LOOP_NOP
          RETURN  






CASE_MID 
          movlw D'15'
          subwf PORTC,0
          btfss STATUS,C
          goto BL
          movlw B'10000000'
          xorwf PORTC,1
          movlw D'30'
          movwf COUN1
COUNTER1B CALL delay_mid
          decfsz COUN1,1
          goto COUNTER1B
          clrf PORTC
          movlw D'20'
          movwf COUN1
COUNTER1C CALL delay_mid
          decfsz COUN1,1
          goto COUNTER1C
          goto LOOP2

     BL    clrf PORTC
          goto LOOP2
; DELAY FOR MID
delay_mid movlw B'10000000'
          subwf PORTB,0
          btfss STATUS,Z
          goto LOOP2
          movf PORTC,0
          andlw b'00011111'
          subwf TEMP1,0
          btfss STATUS,Z
          goto  LOOP2
          movlw D'0'
          movwf EXTERNAL_COUN
          movlw D'244'
          movwf INTERNAL_COUN 
LOOP_NOP1 NOP
          NOP     
          NOP
          NOP
          NOP
          decfsz EXTERNAL_COUN,1
          goto LOOP_NOP1
          decfsz INTERNAL_COUN 
          goto LOOP_NOP1
          RETURN  




CASE_MAX
          movlw D'5'
          subwf PORTC,0
          btfss STATUS,C
          goto CL
          movlw B'10000000'
          xorwf PORTC,1
          movlw D'40'
          movwf COUN1
COUNTER1D CALL delay_max
          decfsz COUN1,1
          goto COUNTER1D
          clrf PORTC
          movlw D'20'
          movwf COUN1
COUNTER1E CALL delay_max
          decfsz COUN1,1
          goto COUNTER1E
          goto LOOP2   
     CL   clrf PORTC
          goto LOOP2
;DELAY_MAX
delay_max movlw B'11000000'
          subwf PORTB,0
          btfss STATUS,Z
          goto LOOP2
          movf PORTC,0
          andlw b'00011111'
          subwf TEMP1,0
          btfss STATUS,Z
          goto  LOOP2
          movlw D'0'
          movwf EXTERNAL_COUN
          movlw D'244'
          movwf INTERNAL_COUN 
LOOP_NOP2 NOP
          NOP     
          NOP
          NOP
          NOP
          decfsz EXTERNAL_COUN,1
          goto LOOP_NOP2
          decfsz INTERNAL_COUN 
          goto LOOP_NOP2
          RETURN  

;.............INTERRUPT......................

ISR  
    movlw 0x01
    xorwf FLASH,1
    movf PORTB,0
    bcf INTCON,RBIF
    RETFIE
    

;...........

          END

