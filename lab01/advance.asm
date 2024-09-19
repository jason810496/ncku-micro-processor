List p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF 0x000
	CLRF 0x001
	CLRF 0x002
	CLRF 0x003
	CLRF 0x004 ; copy of 0x002
	CLRF 0x010
	
    init:
;	MOVLW b'01010101'
;        MOVWF 0x000 
;        MOVLW b'01111101'
;        MOVWF 0x001
	
;	MOVLW 0xFF
;        MOVWF 0x000 
;        MOVLW 0x1E
;        MOVWF 0x001
    
	MOVLW 0xA6
        MOVWF 0x000 
        MOVLW 0x79
        MOVWF 0x001
	
    bitwise_operation:
	CLRF WREG
	ADDWF 0x000, W 
	ANDLW b'11110000'
	MOVWF 0x002
	
	CLRF WREG
	ADDWF 0x001, W 
	ANDLW b'00001111'
	
	ADDWF 0x002, W
	MOVWF 0x002
	
	; copy 0x002 to 0x004
	MOVF 0x002, W
	MOVWF 0x004
	
    count_loop_init:
        MOVLW 0x08
	MOVWF 0x010 ; store i in [0x010]
    count_loop:
	BTFSC 0x004, 0; skip if set
	GOTO count_loop_continue
	GOTO add_count
    add_count:
	INCF 0x003
	GOTO count_loop_continue
    count_loop_continue:
	RRCF 0x004
        DECFSZ 0x010
	    GOTO count_loop

    end
	