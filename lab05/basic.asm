#include "xc.inc"
GLOBAL _mysqrt
GLOBAL __mysqrt_loop
GLOBAL __mysqrt_result
PSECT mytest,local,class=CODE,reloc=2

_mysqrt
    MOVFF WREG, 0x10 ; n = WREG
    CLRF 0x11 ; i = 0
    ; while i++
    ; if i*i > n then break

    __mysqrt_loop
        INCF 0x11, 1, 0 ; i++, store in WREG
        MOVFF WREG, 0x12 ; temp = i
        ; i*i 
        MULWF 0x12
        ; if PRODL >= n then break
        MOVFF PRODL, WREG
        ; equal case 
        CPFSLT 0x10 ; Compare f with WREG, skip if <
            GOTO __mysqrt_result
        GOTO __mysqrt_loop
    __mysqrt_result
        MOVFF WREG, 0x01
        RETURN
