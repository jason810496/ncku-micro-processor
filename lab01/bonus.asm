List p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF 0x000
	CLRF 0x010
	CLRF 0x005 ; store i as [0x005]
	CLRF 0x020 ; original 0x000
    init:
;	MOVLW	b'10000001'
;        MOVWF 0x000
;	MOVLW	0x05
;	MOVWF 0x010
    
	MOVLW 0xAA
        MOVWF 0x000
	MOVLW	0x10
	MOVWF 0x010
	
	
	
    init_loop:
	; copy 0x000 to 0x020
	MOVF 0x000, W
	MOVWF 0x020
    loop:
	GOTO check_odd
    loop_continue:
	RRCF 0x000
    check_break:
	MOVF 0x020, W
	XORWF 0x000, W
	BZ finish
	GOTO loop
	    
    check_odd:
	BTFSS 0x000, 0; skip if set
	GOTO check_2_or_4
	GOTO sub_1 ; not 2 or 4 case
    check_2_or_4:
        BTFSS 0x000, 1; skip if set
	GOTO add_2
	GOTO add_1
    sub_1:
	DECF 0x010
	GOTO loop_continue
    add_1:
	INCF 0x010
	GOTO loop_continue
    add_2:
	INCF 0x010
	INCF 0x010
	GOTO loop_continue
	
    finish:
        NOP
	end
	