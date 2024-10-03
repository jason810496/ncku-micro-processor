List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF 0x00
	CLRF 0x01
	CLRF 0x10
	CLRF 0x11
	CLRF 0x20
	CLRF 0x21
	CLRF 0x22
	CLRF 0x23

    test_case:
	; example ; expected: 0x00 AD 0x07 0x07
	MOVLW 0x12
	MOVWF 0x00 ; A
	
	MOVLW 0xCB
	MOVWF 0x01 ; B 
	
	MOVLW 0x09
	MOVWF 0x10 ; C
	
	MOVLW 0x35
	MOVWF 0x11 ; D
	; case 1 ; expected: 0x02 0x02 0xA0 0x6C
	MOVLW 0x20
	MOVWF 0x00 ; A
	
	MOVLW 0x24
	MOVWF 0x01 ; B 
	
	MOVLW 0x010
	MOVWF 0x10 ; C
	
	MOVLW 0x03
	MOVWF 0x11 ; D
	; case 2 ; expected: 0x28 0x59 0xF9 0xC8
	MOVLW 0x77
	MOVWF 0x00 ; A
	
	MOVLW 0x77
	MOVWF 0x01 ; B 
	
	MOVLW 0x056
	MOVWF 0x10 ; C
	
	MOVLW 0x78
	MOVWF 0x11 ; D
	
    
    ; A*C*2^16 + ( B*C + A*D ) * 2^8 + B*D
    b_d_case:
	; WREG = 0x11 D 
	MULWF 0x01 ; B
	MOVFF PRODL, 0x23
	MOVFF PRODH, 0x22
	
    b_c_case:
	MOVFF 0x01, WREG ; B
	MULWF 0x10 ; C
	
	MOVFF PRODL, WREG
	ADDWF 0x22 ; BCL to 0x22
	; check if carry
	BTFSC STATUS, 0 ; negative bit, skip if clear
	INCF 0x21
	
	MOVFF PRODH, WREG
	ADDWF 0x21 ; BCH to 0x21
	; check if carry
	BTFSC STATUS, 0 ; negative bit, skip if clear
	INCF 0x20
	
    a_d_case:
	MOVFF 0x00, WREG ; A
	MULWF 0x11 ; D
	
	MOVFF PRODL, WREG
	ADDWF 0x22 ; ADL to 0x22
	; check if carry
	BTFSC STATUS, 0 ; negative bit, skip if clear
	INCF 0x21
	
	MOVFF PRODH, WREG
	ADDWF 0x21 ; ADH to 0x21
	; check if carry
	BTFSC STATUS, 0 ; negative bit, skip if clear
	INCF 0x20
	
    a_c_case:
	MOVFF 0x00, WREG ; A
	MULWF 0x10 ; C
	
	MOVFF PRODL, WREG
	ADDWF 0x21 ; ACL to 0x21
	; check if carry
	BTFSC STATUS, 0 ; negative bit, skip if clear
	INCF 0x20
	
	MOVFF PRODH, WREG
	ADDWF 0x20 ; ACH to 0x20

    final:
	NOP
	end

