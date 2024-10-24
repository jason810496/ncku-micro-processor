#include "xc.inc"
GLOBAL _gcd
PSECT mytest,local,class=CODE,reloc=2

_swap macro al, ah, bl, bh
    MOVFF al, WREG
    MOVFF bl, al
    MOVFF WREG, bl
    
    MOVFF ah, WREG
    MOVFF bh, ah
    MOVFF WREG, bh
    
    ENDM


_gcd:
    ; 0x02 = ah
    ; 0x01 = al
    ; 0x04 = bh
    ; 0x03 = bl

    ; assume a > b 
    ; while b != 0
    ; a -= b
    ; if a < b then swap a and b

    ; make sure a > b
    
    __gcd_pre_check_high:
    MOVFF 0x04, WREG
    CPFSLT 0x02 ; Compare f with WREG, skip if f < w
	GOTO __gcd_pre_check_eq
        _swap 0x01, 0x02, 0x03, 0x04
	GOTO __gcd_loop
	
    __gcd_pre_check_eq:
	MOVFF 0x04, WREG
	CPFSEQ 0x02
	    GOTO __gcd_loop
	    GOTO __gcd_pre_check_low
    
    __gcd_pre_check_low:
    MOVFF 0x03, WREG
    CPFSLT 0x01 ; Compare f with WREG, skip if f < w
	GOTO __gcd_loop
        _swap 0x01, 0x02, 0x03, 0x04

    __gcd_loop:
	MOVFF 0x04, WREG
	SUBWF 0x02, 1 ; a_h = a_h - b_h
	MOVFF 0x03, WREG
	SUBWF 0x01, 1 ; a_l = a_l - b_l
	BTFSS STATUS, 0 ; If Carry is set -> No borrow. Then skip.
	DECF 0x02
	
	CLRF STATUS
	
        ; if a < b then swap a and b
	__gcd_check_high:
	MOVFF 0x04, WREG
	CPFSLT 0x02 ; Compare f with WREG, skip if f < W
	    GOTO __gcd_check_eq
	    _swap 0x01, 0x02, 0x03, 0x04
	    GOTO __gcd_loop_continue
	    
	__gcd_check_eq:
	MOVFF 0x04, WREG
	CPFSEQ 0x02
	    GOTO __gcd_loop_continue
	    GOTO __gcd_check_low
	    
	    
	__gcd_check_low:
	MOVFF 0x03, WREG
        CPFSLT 0x01 ; Compare f with WREG, skip if f < W
	    GOTO __gcd_loop_continue
	    _swap 0x01, 0x02, 0x03, 0x04
    __gcd_loop_continue:
        ; if b == 0 then break
        TSTFSZ 0x03 ; 
	GOTO __gcd_loop
	
	
	TSTFSZ 0x04
	GOTO __gcd_loop

    __gcd_result:
        ; a already in 0x01, NOP
        RETURN

