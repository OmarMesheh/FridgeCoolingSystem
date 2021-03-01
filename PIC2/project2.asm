#include "P16F877A.INC"
      org 0000
      goto start 

      
start
      CLRF PORTC
      bsf STATUS ,RP0 
      clrf TRISC
      movlw 0XFF
      movwf TRISB
      bcf  STATUS,RP0
 loop    movf PORTB,0
      movwf PORTC
  goto loop
      END