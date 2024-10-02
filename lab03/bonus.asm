List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    clear:
	CLRF 0x00
	CLRF 0x01
	CLRF 0x02

    test_case:
    ; case 1
	MOVLW 0x00
	MOVWF 0x00
	
	MOVLW 0x40
	MOVWF 0x01
    ; case 2
	MOVLW 0x00
	MOVWF 0x00
	
	MOVLW 0x41
	MOVWF 0x01
    ; case 3
	MOVLW 0x2A
	MOVWF 0x00
	
	MOVLW 0x41
	MOVWF 0x01
	
    init_loop:
	MOVLW 0x10 ; 16 in hex
	MOVWF 0x03 ;  n = 16
	MOVLW 0x08 ; 8 in hex
	MOVWF 0x04 ;  n2 = 8
	
	; ptr
	LFSR 0, 0x00 ; FSR0 -> 0x00
    loop:
	BTFSC INDF0, 7 ; test bit 7 , skip if clear
	GOTO answer
	; rotate
	RLCF INDF0
	; move ptr after move 8 bit
	DECF 0x04; --0x04
	MOVFF 0x04, WREG;
	BZ move_ptr
    loop_continue:
	DECFSZ 0x03
	GOTO loop
	GOTO final
	
    move_ptr:
	MOVFF PREINC0, WREG ; ptr from 0x00 to 0x01
	GOTO loop_continue
	
    answer:
        MOVFF 0x03, 0x02
	DECF 0x02 ; ans = 0x03 - 1
	NOP
	
	
    ; add 1 if there are still any 1
    init_final_check:
	; rotate
	RLCF INDF0
	; move ptr after move 8 bit
	DECF 0x04; --0x04
	MOVFF 0x04, WREG;
	BZ final_check_move_ptr
	
	DECF 0x03 ; --n
    final_check_loop:
	BTFSC INDF0, 7 ; test bit 7 , skip if clear
	GOTO final_check_add_1
	; rotate
	RLCF INDF0
	; move ptr after move 8 bit
	DECF 0x04; --0x04
	MOVFF 0x04, WREG;
	BZ final_check_move_ptr
    final_check_continue:
	DECFSZ 0x03
	GOTO final_check_loop
	GOTO final
	
    final_check_move_ptr:
	MOVFF PREINC0, WREG ; ptr from 0x00 to 0x01
	GOTO loop_continue
	
    final_check_add_1:
	INCF 0x02

    final:
	NOP
	end

