st p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    ; lab02 bonus
    
    init_test:
	MOVLW 0x28 ; a0
        MOVWF 0x00
	
	MOVLW	0x34 ; a1
	MOVWF 0x01
	
	MOVLW	0x7A ; a2
	MOVWF 0x02
	
	MOVLW	0x80 ; a3
	MOVWF 0x03
	
	MOVLW	0xA7 ; a4
	MOVWF 0x04
	
	MOVLW	0xD1 ; a5
	MOVWF 0x05
	
	MOVLW	0xFE ; a6
	MOVWF 0x06
	
	MOVLW 0xFE ; 
	MOVWF 0x0F ; to be seach
	
    init_b_search:
	MOVLW d'7'
	MOVWF 0x20 ; n
	CLRF 0x21    ; l
	MOVWF 0x22 ; r
	DECF 0x22    ; r = n-1
	CLRF 0x23    ; mid
    b_search:
	MOVFF 0x21, WREG ; WREG = l
	ADDWF 0x22, 0 ; WREG = l+r
	; WREG /=2
	RRCF WREG, 0 
	ANDLW b'01111111' ; WREG = (l+r)/2
	MOVFF WREG, FSR0 ; ptr0 -> a[mid]
	MOVFF WREG, 0x23 ; mid
	MOVFF 0x0F, WREG ; WREG = to be search
	check_eq:
	    CPFSEQ INDF0
		GOTO eq_case
	check_neq:
	eq_case:
	bigger_case:
	smaller_case:
    b_search_continue:
        CPFSGT 0x23 ; if mid > WREG, skip 
	    GOTO b_seach
	



