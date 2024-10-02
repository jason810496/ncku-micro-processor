List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF TRISA

    init:
	MOVLW 0x5F
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

