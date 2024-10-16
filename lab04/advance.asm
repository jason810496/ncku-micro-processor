List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    ; Define locations for a and b
    #define a1 0x10
    #define a2 0x11
    #define a3 0x12
    #define b1 0x13
    #define b2 0x14
    #define b3 0x15

    ; Define locations for results
    #define c1 0x020
    #define c2 0x021
    #define c3 0x022
    
    
    cross:
	; Calculate c1 = a2 * b3 - a3 * b2
	MOVF a2, W         ; W = a2
	MOVWF PRODL        ; Load a2 into PRODL
	MOVF b3, W         ; W = b3
	MULWF PRODL        ; Multiply a2 * b3 (result in PRODH:PRODL)
	MOVF PRODL, W      ; W = low byte of a2 * b3
	MOVWF TEMP1        ; Store result temporarily (low byte)
	MOVF PRODH, W      ; W = high byte of a2 * b3
	MOVWF TEMP2        ; Store result temporarily (high byte)

	MOVF a3, W         ; W = a3
	MOVWF PRODL        ; Load a3 into PRODL
	MOVF b2, W         ; W = b2
	MULWF PRODL        ; Multiply a3 * b2 (result in PRODH:PRODL)
	MOVF PRODL, W      ; W = low byte of a3 * b2
	SUBWF TEMP1, F     ; TEMP1 = a2 * b3 - a3 * b2 (low byte)
	MOVF PRODH, W      ; W = high byte of a3 * b2
	SUBWFB TEMP2, F    ; TEMP2 = high byte of the result with carry

	MOVF TEMP1, W      ; W = final result for c1 (low byte)
	MOVWF c1           ; Store c1 in [0x020]

	; Repeat similar steps for c2 = a3 * b1 - a1 * b3
	MOVF a3, W
	MOVWF PRODL
	MOVF b1, W
	MULWF PRODL
	MOVF PRODL, W
	MOVWF TEMP1
	MOVF PRODH, W
	MOVWF TEMP2

	MOVF a1, W
	MOVWF PRODL
	MOVF b3, W
	MULWF PRODL
	MOVF PRODL, W
	SUBWF TEMP1, F
	MOVF PRODH, W
	SUBWFB TEMP2, F

	MOVF TEMP1, W
	MOVWF c2           ; Store c2 in [0x021]

	; Repeat similar steps for c3 = a1 * b2 - a2 * b1
	MOVF a1, W
	MOVWF PRODL
	MOVF b2, W
	MULWF PRODL
	MOVF PRODL, W
	MOVWF TEMP1
	MOVF PRODH, W
	MOVWF TEMP2

	MOVF a2, W
	MOVWF PRODL
	MOVF b1, W
	MULWF PRODL
	MOVF PRODL, W
	SUBWF TEMP1, F
	MOVF PRODH, W
	SUBWFB TEMP2, F

	MOVF TEMP1, W
	MOVWF c3           ; Store c3 in [0x022]

	RETURN