#include "xc.inc"
GLOBAL _mysqrt
PSECT mytest,local,class=CODE,reloc=2

_mysqrt:
    MOVFF WREG, 0x10 ; n = WREG
    CLRF 0x11 ; i = 0
    ; while i++
    ; if i*i > n then break

    __mysqrt_loop:
        INCF 0x11 ; i++
	MOVFF 0x11, WREG
        MOVFF WREG, 0x12 ; temp = i
        ; i*i 
        MULWF 0x12
	; if PRODH is not 0, goto result
	TSTFSZ PRODH
	GOTO __mysqrt_result
        ; if PRODL >= n then break
        MOVFF PRODL, WREG
        ; equal case 
        CPFSGT 0x10 ; Compare f with WREG, skip if f < WREG
            GOTO __mysqrt_result
        GOTO __mysqrt_loop
    __mysqrt_result:
	MOVFF 0x11, WREG
        RETURN
