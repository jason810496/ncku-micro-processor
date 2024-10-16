List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    ; Define memory locations for variables
    #define n 0x002
    #define F0_LOW 0x003   ; Low byte of F_n
    #define F0_HIGH 0x004   ; High byte of F_n
    #define F1_LOW 0x005   ; Low byte of F_{n+1}
    #define F1_HIGH 0x006   ; High byte of F_{n+1}
    #define TEMP_LOW 0x007  ; Low byte of TEMP for addition
    #define TEMP_HIGH 0x008 ; High byte of TEMP for addition

    ; Define output memory locations
    #define RESULT_HIGH 0x000 ; High byte of the result
    #define RESULT_LOW 0x001 ; Low byte of the result



    ; test case 1
    MOVLW 0x09     ; Example: Calculate F_9
    MOVWF n        ; Store input in 'n'
    
    ; main 
    main:
	RCALL fib
	GOTO finish
	
    fib:
	; Initialize F0 = 0, F1 = 1
	CLRF F0_LOW          ; F0_LOW = 0
	CLRF F0_HIGH         ; F0_HIGH = 0
	MOVLW 0x01           ; W = 1
	MOVWF F1_LOW         ; F1_LOW = 1
	CLRF F1_HIGH         ; F1_HIGH = 0

	; If n == 0, store F0 (0) in the result
	MOVF n, W            ; W = n
	BZ STORE_F0          ; If n == 0, store F0 and return

	; If n == 1, store F1 (1) in the result
	MOVLW 0x01           ; W = 1
	XORWF n, 0        ; Check if n == 1
	BZ STORE_F1          ; If n == 1, store F1 and return

	; Loop to calculate Fibonacci up to the nth term
	DECFSZ n, F          ; Decrement n (preparing for n-1 iterations)
	GOTO FIB_LOOP

    FIB_LOOP:
	; TEMP = F0 + F1
	MOVF F0_LOW, W       ; W = F0_LOW
	ADDWF F1_LOW, W      ; W = F0_LOW + F1_LOW
	MOVWF TEMP_LOW       ; Store result low byte in TEMP_LOW
	MOVF F0_HIGH, W      ; W = F0_HIGH
	ADDWFC F1_HIGH, W    ; W = F0_HIGH + F1_HIGH + carry
	MOVWF TEMP_HIGH      ; Store result high byte in TEMP_HIGH

	; Update F0 = F1
	MOVF F1_LOW, W       ; W = F1_LOW
	MOVWF F0_LOW         ; F0_LOW = F1_LOW
	MOVF F1_HIGH, W      ; W = F1_HIGH
	MOVWF F0_HIGH        ; F0_HIGH = F1_HIGH

	; Update F1 = TEMP (F_n + F_{n+1})
	MOVF TEMP_LOW, W     ; W = TEMP_LOW
	MOVWF F1_LOW         ; F1_LOW = TEMP_LOW
	MOVF TEMP_HIGH, W    ; W = TEMP_HIGH
	MOVWF F1_HIGH        ; F1_HIGH = TEMP_HIGH

	; Decrement n and continue the loop until n == 0
	DECFSZ n, F
	GOTO FIB_LOOP

	; Store the final result in RESULT_HIGH and RESULT_LOW
	MOVF F1_HIGH, W      ; W = F1_HIGH
	MOVWF RESULT_HIGH    ; Store high byte of result
	MOVF F1_LOW, W       ; W = F1_LOW
	MOVWF RESULT_LOW     ; Store low byte of result
	RETURN

    STORE_F0:
	MOVF F0_HIGH, W      ; W = F0_HIGH
	MOVWF RESULT_HIGH    ; Store high byte of F0
	MOVF F0_LOW, W       ; W = F0_LOW
	MOVWF RESULT_LOW     ; Store low byte of F0
	RETURN

    STORE_F1:
	MOVF F1_HIGH, W      ; W = F1_HIGH
	MOVWF RESULT_HIGH    ; Store high byte of F1
	MOVF F1_LOW, W       ; W = F1_LOW
	MOVWF RESULT_LOW     ; Store low byte of F1
	RETURN
    
    
    finish:
	end