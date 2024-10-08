st p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    ; lab02 advance
    
    clear:
	; test case
	CLRF 0x100
	CLRF 0x106
	CLRF 0x110 ; i
	CLRF 0x111 ; j
	CLRF 0x112 ; n
    init_test:
	MOVLB 0x01 ; move bank
	
	MOVLW 0x08 ; a0
        MOVWF 0x00, 1
	
	MOVLW	0x7C ; a1
	MOVWF 0x01, 1
	
	MOVLW	0xFE ; a2
	MOVWF 0x02, 1
	
	MOVLW	0x34 ; a3
	MOVWF 0x03, 1
	
	MOVLW	0x7A ; a4
	MOVWF 0x04, 1
	
	MOVLW	0x0D ; a5
	MOVWF 0x05, 1
	
	MOVLW	0x7C ; a6
	MOVWF 0x06, 1

    init_outer_loop:
	MOVLW d'7'
	MOVWF 0x12 ; n
	DECF 0x12, 1 ; n-- (　only need to loop n-1 time )
	
	; outer ptr
	LFSR 0, 0x100
    outer_loop:
	init_inner_loop:
	    MOVFF 0x110, WREG ; WREG = i
	    INCF WREG ; WREG = i+1
	    ; inner ptr
nclude<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    ; lab02 advance
    
    clear:
	; test case
	CLRF 0x100
	CLRF 0x106
	CLRF 0x110 ; i
	CLRF 0x111 ; j
	CLRF 0x112 ; n
	CLRF 0x113 ; n-1
	CLRF 0x114 ; inner loop n 
    init_test:
	MOVLB 0x01 ; move bank
	
	MOVLW 0x08 ; a0
        MOVWF 0x00, 1
	
	MOVLW	0x7C ; a1
	MOVWF 0x01, 1
	
	MOVLW	0x78 ; a2
	MOVWF 0x02, 1
	
	MOVLW	0xFE ; a3
	MOVWF 0x03, 1
	
	MOVLW	0x34 ; a4
	MOVWF 0x04, 1
	
	MOVLW	0x7A ; a5
	MOVWF 0x05, 1
	
	MOVLW	0x0D ; a6
	MOVWF 0x06, 1
	
	

    init_outer_loop:
	MOVLW d'7'
	MOVWF 0x12, 1 ; n
	MOVFF 0x112, 0x113 ; copy n
	DECF 0x13, 1, 1 ; 0x13 = n-1
	
	; outer ptr
	LFSR 0, 0x100;j
    outer_loop:
	init_inner_loop:
	    MOVFF 0x110, 0x111 ;j=i
	    INCF 0x11, 1, 1 ;j++
	    ; inner ptr
	    LFSR 2, 0x100
		init_workaround:
		    MOVFF 0x111, 0x114 ; 0x114 = 0x111
		workaround:
		    MOVFF PREINC2, WREG ; inner ptr -> pj, WREG = pj
		workaround_continue:
		    DECFSZ 0x14, 1, 1
			GOTO workaround
	inner_loop:
	    MOVFF INDF2, WREG ; WREG = pj
	    CPFSGT INDF0 ; cmp pi with pj, skip if pi > pj
		GOTO inner_loop_continue
	swap_element:
	    MOVFF INDF0, WREG ; pi to WREG
	    MOVFF INDF2, INDF0; pj to pi
	    MOVFF WREG, INDF2 ; WREG to pj
	inner_loop_continue:
	    INCF 0x11, 1, 1 ;j++ ( first 1: store back to file rregister, second 1: bank )
	    MOVFF POSTINC2, WREG ; pj++
	    MOVFF 0x112, WREG ; WREG  = n
	    CPFSEQ 0x11, 1 ; cmp f with WREG, skip if f = w ( ,1 for bank )
		GOTO inner_loop
    outer_loop_continue:
	INCF 0x10,1 , 1 ; i++ ( ,1 for bank )
	MOVFF POSTINC0, WREG ; pi++
	MOVFF 0x113, WREG ; WREG  = n-1
	CPFSEQ 0x10, 1 ; cmp f with WREG, skip if f = w ( ,1 for bank )
	    GOTO outer_loop
    finish:
	NOP
	end

