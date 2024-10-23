#include "xc.inc"
GLOBAL _gcd
GLOBAL __gcd_loop
GLOBAL __gcd_result
PSECT mytest,local,class=CODE,reloc=2

_swap macro aa, bb
    MOVFF aa, WREG
    MOVFF bb, aa
    MOVFF WREG, bb
    ENDM 


_gcd
    ; 0x01 = a 
    ; 0x03 = b 

    ; assume a > b 
    ; while b != 0
    ; a -= b
    ; if a < b then swap a and b

    ; make sure a > b
    MOVFF 0x03, WREG
    CPFSLT 0x01 ; Compare f with WREG, skip if <
        _swap 0x01, 0x03

    __gcd_loop
        ; a-=b
        MOVFF 0x03, WREG
        SUBWF 0x01 ; a -= b 
        ; if a < b then swap a and b
        CPFSLT 0x01 ; Compare f with WREG, skip if <
        _swap 0x01, 0x03
        ; if b == 0 then break
        MOVFF 0x03, WREG
        BZ __gcd_result
        GOTO __gcd_loop

    __gcd_result
        ; a already in 0x01, NOP
        RETURN

