#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

 org 0x00
 L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    org 0x00            ; Set program start address to 0x00

; instruction frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 ?s
; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
; num1 = 111, num2 = 70, Total_cycles = 62512 cycles
; Total_delay ~= Total_cycles * instruction time = 0.25 s
DELAY macro num1, num2
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop
   
    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
   
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP2:
    MOVLW num1          
    MOVWF L1  
   
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP1:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    DECFSZ L1, 1        
    BRA LOOP1           ; BRA instruction spends 2 cycles
   
    ; 3 cycles
    DECFSZ L2, 1        ; Decrement L2, skip if zero
    BRA LOOP2          
endm
 goto Initial    
ISR:
    org 0x08      
    MOVLW 0xFF
    MOVWF 0x10
    BTFSC 0x01,1
    GOTO ST1
    BTFSC 0x01,2
    GOTO ST2
    BTFSC 0x01,3
    GOTO ST3
    BTFSC 0x01,4
    GOTO ST4
    BTFSC 0x01,5
    GOTO ST5
    BTFSC 0x01,6
    GOTO ST6
   
    ST1:
BCF 0x01,1
BSF 0x01,2
BCF INTCON, INT0IF
    RETFIE
    ST2:
BCF 0x01,2
BSF 0x01,3
BCF INTCON, INT0IF
    RETFIE
    ST3:
BCF 0x01,3
BSF 0x01,4
BCF INTCON, INT0IF
    RETFIE

    ST4:
BCF 0x01,4
BSF 0x01,5
BCF INTCON, INT0IF
    RETFIE
    ST5:
BCF 0x01,5
BSF 0x01,6
BCF INTCON, INT0IF
    RETFIE
    ST6:
BCF 0x01,6
BSF 0x01,1
   
    BCF INTCON, INT0IF
    RETFIE
Initial:
    MOVLW 0x0F
    MOVWF ADCON1
    initial_state:
MOVLW 0x02
MOVWF 0x01

MOVLW 0x00
MOVWF 0x10 ;FLAG
   
    CLRF TRISA
    CLRF LATA
    BSF TRISB,  0
    BCF RCON, IPEN
    BCF INTCON, INT0IF ; ??Interrupt flag bit??
    BSF INTCON, GIE ; ?Global interrupt enable bit??
    BSF INTCON, INT0IE ; ?interrupt0 enable bit ?? (INT0?RB0 pin?????)
   
   
main:
    MOVLW 0x00
    MOVWF 0x10 ;FLAG
    BTFSC 0x01,1
    GOTO STATE1
    BTFSC 0x01,2
    GOTO STATE2
    BTFSC 0x01,3
    GOTO STATE3
    BTFSC 0x01,4
    GOTO STATE4
    BTFSC 0x01,5
    GOTO STATE5
    BTFSC 0x01,6
    GOTO STATE6
   
    STATE1:;7/0.25
    CLRF LATA
    loop1:
    INCF LATA
    DELAY d'111', d'70'
    RCALL CHECK
    MOVLW 0x07
    CPFSEQ LATA
    GOTO loop1
    RCALL CHECK
    CLRF LATA
    GOTO STATE1
   
   
   
    STATE2:
    CLRF LATA
    loop2:
    INCF LATA
    DELAY d'111', d'140'
    RCALL CHECK
   
    MOVLW 0x0F
    CPFSEQ LATA
    GOTO loop2
    RCALL CHECK
    GOTO STATE2
   
   
    STATE3: ;_15/0.25
    MOVLW 0x0F
    MOVWF LATA
    loop3:
   
    DECF LATA
    DELAY d'111', d'70'
    RCALL CHECK
    MOVLW 0x00
    CPFSEQ LATA
    GOTO loop3
    RCALL CHECK
    GOTO STATE3
   
   
    STATE4:;7/0.25
    CLRF LATA
    loop4:
    INCF LATA
    DELAY d'111', d'140'
    RCALL CHECK
    MOVLW 0x07
    CPFSEQ LATA
    GOTO loop4
    RCALL CHECK
    CLRF LATA
    GOTO STATE4
   
    STATE5:
    CLRF LATA
    loop5:
    INCF LATA
    DELAY d'111', d'70'
    RCALL CHECK
   
    MOVLW 0x0F
    CPFSEQ LATA
    GOTO loop5
    RCALL CHECK
    GOTO STATE5
   
    STATE6: ;_15/0.5
    MOVLW 0x0F
    MOVWF LATA
    loop6:
   
    DECF LATA
    DELAY d'111', d'140'
    RCALL CHECK
    MOVLW 0x00
    CPFSEQ LATA
    GOTO loop6
    RCALL CHECK
    GOTO STATE6
   
    CHECK:
MOVLW 0xFF
CPFSEQ 0x10
RETURN
CLRF LATA
    GOTO main

   
 end