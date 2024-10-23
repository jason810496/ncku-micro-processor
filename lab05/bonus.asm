#include "xc.inc"
GLOBAL _multi_signed
PSECT mytest,local,class=CODE,reloc=2


_multi_signed:
    ; 8-bit signed integer 'a'
    ; 4-bit signed integer 'b'
    ; The output will be a 16-bit result. The result should be stored in an unsigned integer variable

    CLRF 0x05 ; a sign; 0 = positive, 1 = negative
    CLRF 0x10 ; result sign, 0 = positive, 1 = negative
    
    __input:
	MOVFF 0x01, 0x03
	MOVFF WREG, 0x01

    __check_sign_a:
        BTFSC 0x01, 7
	GOTO __mark_a_negative
        GOTO __check_sign_b

    __mark_a_negative:
	NEGF 0x01 ; make a = -a
        INCF 0x05

    __check_sign_b:
        BTFSC 0x03, 7
        GOTO __mark_b_negative
        GOTO __mark_b_positive

    __mark_b_positive:
        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        GOTO __mark_result_negative
        GOTO __mark_result_positive
        

    __mark_b_negative:
	NEGF 0x03 ; make b = -b
    
        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        GOTO __mark_result_positive
	GOTO __mark_result_negative
	
    __mark_result_positive:
	GOTO __multiply
    
    __mark_result_negative:
	INCF 0x10 ; result is negative
	GOTO __multiply
    
    __multiply:
	MOVFF 0x03, 0x20 ; temp n 
	MOVFF 0x01, 0x21 ; copy of 0x01
	DECF 0x20 ; temp n --
    __multiply_loop:
	MOVFF 0x21, WREG
	ADDWF 0x01
	BTFSC STATUS, 0
	INCF 0x02
    __multiply_continue:
	DECFSZ 0x20, 1, 1
	GOTO __multiply_loop
	
	; check result neg, pos
	TSTFSZ 0x10
	    GOTO __toggle_result_negative
	    GOTO __finish
	    
    __toggle_result_negative:
	COMF 0x01
	
	COMF 0x02
	
	; increase 0x02 if carry
	
	INCF 0x01
	BTFSC STATUS, 0
	INCF 0x02
	
	
	
    __finish:
	RETURN

