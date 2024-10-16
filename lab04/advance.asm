List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    ; Define locations for a and b
    #define a1 0x10
    #define a2 0x11
    #define a3 0x12
    #define b1 0x13
    #define b2 0x14
    #define b3 0x15

    ; Define locations for results
    #define c1 0x020
    #define c2 0x021
    #define c3 0x022

    #define TEMP1 0x030
    #define TEMP2 0x031
    #define TEMP3 0x032
    #define TEMP4 0x033

    ; test case 1
    MOVLW 0x03
    MOVWF a1
    MOVLW 0x04
    MOVWF a2
    MOVLW 0x05
    MOVWF a3
    MOVLW 0x06
    MOVWF b1
    MOVLW 0x07
    MOVWF b2
    MOVLW 0x08
    MOVWF b3
    ; test case 2
    ; 0x0B 0x00 0x10 0x0C 0x00 0x06
    MOVLW 0x0B
    MOVWF a1
    MOVLW 0x00
    MOVWF a2
    MOVLW 0x10
    MOVWF a3
    MOVLW 0x0C
    MOVWF b1
    MOVLW 0x00
    MOVWF b2
    MOVLW 0x06
    MOVWF b3



    RCALL cross
    GOTO finish

;cal_c MACRO e, a, b, c, d
;    ; Calculate d = a * b - c * d
;    MOVFF a, WREG
;    MOVFF b, TEMP1
;    MULWF TEMP1
;    MOVFF PRODL, TEMP1
;
;    MOVFF c, WREG
;    MOVFF d, TEMP2
;    MULWF TEMP2
;
;    SUBWF TEMP1, 0
;    MOVFF PRODL, e
;    ENDM

cross:
    ; Calculate c1 = a2 * b3 - a3 * b2
    MOVFF a2, WREG        
    MOVFF b3, TEMP1        
    MULWF TEMP1        
    MOVFF PRODL, TEMP1

    MOVFF a3, WREG       
    MOVFF b2, TEMP2       
    MULWF TEMP2
    MOVFF PRODL, WREG

    SUBWF TEMP1, 0
    MOVFF WREG, c1 

    ; Calculate c2 = a3 * b1 - a1 * b3

    MOVFF a3, WREG
    MOVFF b1, TEMP1
    MULWF TEMP1
    MOVFF PRODL, TEMP1

    MOVFF a1, WREG
    MOVFF b3, TEMP2
    MULWF TEMP2
    MOVFF PRODL, WREG

    SUBWF TEMP1, 0
    MOVFF WREG, c2

    ; Calculate c3 = a1 * b2 - a2 * b1

    MOVFF a1, WREG
    MOVFF b2, TEMP1
    MULWF TEMP1
    MOVFF PRODL, TEMP1

    MOVFF a2, WREG
    MOVFF b1, TEMP2
    MULWF TEMP2
    MOVFF PRODL, WREG

    SUBWF TEMP1, 0
    MOVFF WREG, c3

    RETURN

finish:
	end