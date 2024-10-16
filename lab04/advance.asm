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

	#define TEMP1 0x030
	#define TEMP2 0x031
    
    
    cross:
	; Calculate c1 = a2 * b3 - a3 * b2
	MOVFF a2, WREG        ; W = a2
	MOVWF PRODL        ; Load a2 into PRODL
	MOVFF b3, WREG        ; W = b3
	MULWF PRODL        ; Multiply a2 * b3 (result in PRODH:PRODL)
	MOVFF PRODL, WREG     ; W = low byte of a2 * b3
	MOVWF TEMP1        ; Store result temporarily (low byte)
	MOVFF PRODH, WREG     ; W = high byte of a2 * b3
	MOVWF TEMP2        ; Store result temporarily (high byte)

	MOVFF a3, WREG        ; W = a3
	MOVWF PRODL        ; Load a3 into PRODL
	MOVFF b2, WREG        ; W = b2
	MULWF PRODL        ; Multiply a3 * b2 (result in PRODH:PRODL)
	MOVFF PRODL, WREG     ; W = low byte of a3 * b2
	SUBWF TEMP1, 1     ; TEMP1 = a2 * b3 - a3 * b2 (low byte)
	MOVFF PRODH, WREG     ; W = high byte of a3 * b2
	SUBWFB TEMP2, 1    ; TEMP2 = high byte of the result with carry

	MOVFF TEMP1, WREG     ; W = final result for c1 (low byte)
	MOVWF c1           ; Store c1 in [0x020]

	; Repeat similar steps for c2 = a3 * b1 - a1 * b3
	MOVFF a3, WREG
	MOVWF PRODL
	MOVFF b1, WREG
	MULWF PRODL
	MOVFF PRODL, WREG
	MOVWF TEMP1
	MOVFF PRODH, WREG
	MOVWF TEMP2

	MOVFF a1, WREG
	MOVWF PRODL
	MOVFF b3, WREG
	MULWF PRODL
	MOVFF PRODL, WREG
	SUBWF TEMP1, 1
	MOVFF PRODH, WREG
	SUBWFB TEMP2, 1

	MOVFF TEMP1, WREG
	MOVWF c2           ; Store c2 in [0x021]

	; Repeat similar steps for c3 = a1 * b2 - a2 * b1
	MOVFF a1, WREG
	MOVWF PRODL
	MOVFF b2, WREG
	MULWF PRODL
	MOVFF PRODL, WREG
	MOVWF TEMP1
	MOVFF PRODH, WREG
	MOVWF TEMP2

	MOVFF a2, WREG
	MOVWF PRODL
	MOVFF b1, WREG
	MULWF PRODL
	MOVFF PRODL, WREG
	SUBWF TEMP1, 1
	MOVFF PRODH, WREG
	SUBWFB TEMP2, 1

	MOVFF TEMP1, WREG
	MOVWF c3           ; Store c3 in [0x022]

	RETURN


	end