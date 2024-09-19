List p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF 0x000
	CLRF 0x001
	CLRF 0x002 ; A1
	CLRF 0x010
	CLRF 0x011
	CLRF 0x012 ; A2 
	CLRF 0x020 ; final ans

    init:
    ;ut1
;        MOVLW 0x01
;        MOVWF 0x000 ; [0x000] = 0x01
;        MOVLW 0x02
;        MOVWF 0x001 ; [0x001] = 0x02
;        
;        MOVLW 0x04
;        MOVWF 0x010 ; [0x010] = 0x04
;        MOVLW 0x03
;        MOVWF 0x011 ; [0x011] = 0x03
    ;ut2
;	MOVLW 0x11
;	MOVWF 0x000 
;	MOVLW 0x12
;	MOVWF 0x001 
;
;	MOVLW 0x2A
;	MOVWF 0x010 
;	MOVLW 0x07
;	MOVWF 0x011 
    ;ut3
        MOVLW 0x07
        MOVWF 0x000 ; [0x000] = d'1'
        MOVLW 0x09
        MOVWF 0x001 ; [0x001] = d'2'
        
        MOVLW 0x12
        MOVWF 0x010 ; [0x010] = d'3'
        MOVLW 0x01
        MOVWF 0x011 ; [0x011] = d'4'


    sum:
    ; A1 case    
	CLRF WREG ; [WREG] = 0
	ADDWF 0x000, W ; [WREG] = [0x000]
	ADDWF 0x001, W ; [WREG] = [0x000] + [0x001]
	MOVWF 0x002

    sub:
    ; A2 case

	CLRF WREG ; [WREG] = 0
	ADDWF 0x011, W ; [WREG] = [0x011]
	SUBWF 0x010, W ; [WREG] = [0x010] - [0x011]
	MOVWF 0x012

    compare:
	CLRF WREG ; [WREG] = 0
	ADDWF 0x002, W ; [WREG] = [0x002] ( A1 )
	CPFSEQ 0X012 ; skip if [WREG] = [0x12] ( skip if A1 = A2 )
	    GOTO not_equal_case
	GOTO equal_case 

    not_equal_case:
	CPFSLT 0X012 ; skip if [0x12] < [WREG] ( skip if A2 < A1 )
	    GOTO a1_less_than_a2
	GOTO a1_greater_than_a2																																																																																																																																																																																																																			    

    a1_greater_than_a2:
	CLRF WREG ; [WREG] = 0
	MOVLW 0xAA
	MOVWF 0x020
	GOTO final

    a1_less_than_a2:
	CLRF WREG ; [WREG] = 0
	MOVLW 0xCC
	MOVWF 0x020
	GOTO final


    equal_case:
	CLRF WREG ; [WREG] = 0
	MOVLW 0xBB
	MOVWF 0x020
	GOTO final

    final:
	NOP
	end


