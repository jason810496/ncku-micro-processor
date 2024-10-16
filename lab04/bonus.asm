List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    ; Define output memory locations
    #define RESULT_HIGH 0x000
    #define RESULT_LOW 0x001
    ; Define memory locations for variables
    #define n 0x002
    #define F0_LOW 0x003 
    #define F0_HIGH 0x004 
    #define F1_LOW 0x005
    #define F1_HIGH 0x006

	def_swap macro aa, bb
		MOVFF aa, WREG
		MOVFF bb, aa
		MOVFF WREG, bb
		ENDM


    ; test case 1
    MOVLW 0x09     ; Example: Calculate F_9
    MOVWF n      ; Store input in 'n'
    ; test case 2
     MOVLW 0x0F
     MOVWF n 

	; clear 
	CLRF RESULT_HIGH
	CLRF RESULT_LOW
	CLRF F0_LOW
	CLRF F0_HIGH
	CLRF F1_LOW
	CLRF F1_HIGH

	; init 
	MOVLW 0x01
	MOVWF F1_LOW
    
    ; main 
    main:
	RCALL fib
	DECFSZ n
	    GOTO main
	MOVFF F0_LOW, RESULT_LOW
	MOVFF F0_HIGH, RESULT_HIGH
	GOTO finish
	
    fib:
		def_swap F0_LOW, F1_LOW
		def_swap F0_HIGH, F1_HIGH
		MOVFF F1_LOW, WREG 
		ADDWF F0_LOW
		MOVFF F1_HIGH, WREG
		ADDWFC F0_HIGH
		RETURN
    
    finish:
	end