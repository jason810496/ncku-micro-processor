List p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    ; lab02 basic
    
    clear:
	; test case
	CLRF 0x100
	CLRF 0x116
	CLRF 0x0F0 ; i
    init_test:
	MOVLW 0x00
	MOVLB 0x01
        MOVWF 0x00, 1
	
	MOVLW	0x01
	MOVWF 0x16, 1
	
    init_loop:
	; iter
	MOVLW d'6'
        MOVWF 0x0F0
	; forward ptr
	LFSR 0, 0x100
	; backward ptr
	LFSR 2, 0x116
    loop:
	; forward next = forward + backward
	MOVFF POSTINC0, WREG ; WREG = forward, forwrd ptr++
	ADDWF INDF2, WREG ; WREG = forward + backward
	MOVFF WREG, INDF0 ; store forward
	; backward
	MOVFF INDF0, WREG 
	ADDWF POSTDEC2, WREG ; WREG = forward + backward, backward ++
	MOVFF WREG, INDF2 ; store backward
    loop_continue:
	 DECFSZ 0x0F0
	    GOTO loop
    finish:
        NOP
	end
	