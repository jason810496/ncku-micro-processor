List p=18f4520
#include<pic18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
 
    org 0x00
    
    
    ; Macro definition
    Sub_Mul MACRO xh, xl, yh, yl
	; Subtract Y from X (X - Y)
	
	; Load xl and yl into working registers
	MOVFF yl, WREG         ; W = yl
	SUBWF xl, 0        ; W = xl - yl
	MOVWF 0x001        ; Store low byte of result at address 0x001
	
	; Load xh and yh into working registers
	MOVFF yh, WREG         ; W = yh
	SUBWFB xh, 0        ; W = xh - yh
	MOVWF 0x000        ; Store high byte of result at address 0x000

	; Multiply the two 8-bit results stored in 0x000 and 0x001
	MOVFF 0x000, WREG     

	; Mul
	MULWF 0x001

	; Store the result of the multiplication in [0x010] (High) and [0x011] (Low)
	MOVFF PRODH, 0x010      
	MOVFF PRODL, 0x011      
    ENDM
    
    ; test case 1
    MOVLW 0x0A    
    MOVWF 0x020      
    MOVLW 0x04    
    MOVWF 0x021      
    
    MOVLW 0x04    
    MOVWF 0x022      
    MOVLW 0x02    
    MOVWF 0x023      
    ; test case 2
    MOVLW 0x02    
    MOVWF 0x020      
    MOVLW 0x0C  
    MOVWF 0x021      
    
    MOVLW 0x00    
    MOVWF 0x022      
    MOVLW 0x0F    
    MOVWF 0x023  
    
    ; Call the Sub_Mul macro with XH, XL, YH, YL
    Sub_Mul 0x020, 0x021, 0x022, 0x023
    
    NOP
    
    end
