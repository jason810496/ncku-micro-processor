List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    #define quotient 0x000
    #define remainder 0x001
    #define idx 0x050
    #define copy_value 0x051
    
    get_highest_bit MACRO num
	; param: num
	; return: highest_bit in WREG, return 0xFF means not set for all bits
	local get_highest_bit_loop
	local get_highest_bit_finish
	
	MOVFF num, copy_value
	MOVLW 0x07
	MOVWF idx
	
	BTFSC copy_value, 7
	GOTO get_highest_bit_finish
	
	DECF 0x07, 1
	get_highest_bit_loop:
	    RLNCF copy_value
	    BTFSC copy_value, 7
	    GOTO get_highest_bit_finish
    
	    DECFSZ idx
	    GOTO get_highest_bit_loop
	    
	; not set for all bits
	MOVLW 0xFF
	MOVFF WREG, idx
	    
	get_highest_bit_finish:
	    MOVFF idx, WREG
    ENDM
    
    NOP
    MOVLW 0x98
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    MOVLW 0x01
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    MOVLW 0x55
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    MOVLW 0xBD
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    MOVLW 0x0F
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    MOVLW 0x00
    get_highest_bit WREG
    MOVFF WREG, 0x01
    NOP
    
    end