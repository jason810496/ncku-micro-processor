List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    ; Define memory addresses or registers for X and Y bytes
    #define XH 0x020  ; High byte of X
    #define XL 0x021  ; Low byte of X
    #define YH 0x022  ; High byte of Y
    #define YL 0x023  ; Low byte of Y
    
    ; test case 1
    MOVLW 0x0A    
    MOVWF XH      
    MOVLW 0x04    
    MOVWF XL      
    
    MOVLW 0x04    
    MOVWF YH      
    MOVLW 0x02    
    MOVWF YL      
    ; test case 2
    MOVLW 0x02    
    MOVWF XH      
    MOVLW 0x0C  
    MOVWF XL      
    
    MOVLW 0x00    
    MOVWF YH      
    MOVLW 0x0F    
    MOVWF YL  
    
    
    ; Macro definition
    Sub_Mul MACRO xh, xl, yh, yl
	; Subtract Y from X (X - Y)
	; Load xh and yh into working registers
	MOVF xh, W         ; W = xh
	SUBWF yh, W        ; W = xh - yh
	MOVWF 0x000        ; Store high byte of result at address 0x000

	; Load xl and yl into working registers
	MOVF xl, W         ; W = xl
	SUBWF yl, W        ; W = xl - yl
	MOVWF 0x001        ; Store low byte of result at address 0x001

	; Multiply the two 8-bit results stored in 0x000 and 0x001
	MOVF 0x000, W      ; Load the high byte result into W
	MOVWF PRODH        ; Store it in PRODH (High byte of the multiplier)
	MOVF 0x001, W      ; Load the low byte result into W
	MOVWF PRODL        ; Store it in PRODL (Low byte of the multiplier)

	; Use the hardware multiplier
	MULWF PRODL        ; Perform the multiplication with W and PRODL

	; Store the result of the multiplication in [0x010] (High) and [0x011] (Low)
	MOVF PRODH, W      ; Move high byte of the result to W
	MOVWF 0x010        ; Store in address 0x010
	MOVF PRODL, W      ; Move low byte of the result to W
	MOVWF 0x011        ; Store in address 0x011
    ENDM
    
    ; Call the Sub_Mul macro with XH, XL, YH, YL
    Sub_Mul XH, XL, YH, YL
    
    NOP
    
    end
