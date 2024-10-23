#include "xc.inc"
GLOBAL _multi_signed
PSECT mytest,local,class=CODE,reloc=2


_multi_signed
    ; 8-bit signed integer 'a'
    ; 4-bit signed integer 'b'
    ; The output will be a 16-bit result. The result should be stored in an unsigned integer variable

    CLRF 0x05 ; a sign; 0 = positive, 1 = negative
    CLRF 0x10 ; result sign, 0 = positive, 1 = negative

    __check_sign_a
        MOVFF 0x01, WREG ; move a to WREG
        BN __mark_a_negative
        GOTO __check_sign_b

    __mark_a_negative
        INCF 0x05

    __check_sign_b
        MOVFF 0x03, WREG ; move b to WREG
        BN __mark_b_negative
        GOTO __mark_b_positive

    __mark_b_positive
        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        ; result be positive
        GOTO __multiply
        

    __mark_b_negative
        TSTFSZ 0x05 ; skip if a = 0 ( a is positive )
        GOTO __multiply ; a is negative and b is negative, result will be positive
        INCF 0x10 ; result is negative
        GOTO __multiply
    
    __multiply
        

