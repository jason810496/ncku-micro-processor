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
	
	; outer ptr
	LFSR 0, 0x100
    outer_loop:
	init_inner_loop:
	    MOVFF 0x110, 0x111 ;j=i
	    INCF 0x11, 1, 1 ;j++
	    MOVFF 0x110, WREG ; WREG = i
	    INCF WREG, 0, 1 ; WREG = i+1 ( dest:WREG, bank )
	    ; inner ptr
	    LFSR 2, 0x100
	    MOVFF PLUSW2, WREG ; inner ptr -> a(i+1), WREG = a(i+1)
	inner_loop:
	    CPFSGT INDF0, 1 ; cmp pi with pj, skip if pi > pj
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
	MOVFF 0x112, WREG ; WREG  = n
	DECF WREG,0 ,1 ; WREG = n-1 ( dest: WREG, bank )
	CPFSEQ 0x10, 1 ; cmp f with WREG, skip if f = w ( ,1 for bank )
	    GOTO outer_loop
    finish:
	NOP
	end

