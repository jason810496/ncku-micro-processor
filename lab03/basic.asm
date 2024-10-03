List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF TRISA

    test_case:
	; example ; expected; 0xBE -> 0xDF
	MOVLW 0x5F
	MOVWF TRISA
	; case 1 ; expected; 0x92 -> 0xC9
	MOVLW 0x49
	MOVWF TRISA
	; case 2 ; expected; 0x26 -> 0x13
	MOVLW 0x93
	MOVWF TRISA
	; case 3 ; expected; 0x90 -> 0xC8
	MOVLW 0xC8
	MOVWF TRISA
	
	
    left_shift:
	RLCF TRISA
	NOP
	
    right_shift:
	BTFSC STATUS, 4 ; negative bit, skip if clear
	GOTO neg_case
	GOTO pos_case
	
    neg_case:
	RRCF TRISA
	MOVFF TRISA, WREG
	IORLW 0x80
	MOVFF WREG, TRISA
	GOTO final  
	
    pos_case:
	RRCF TRISA

    final:
	NOP
	end

