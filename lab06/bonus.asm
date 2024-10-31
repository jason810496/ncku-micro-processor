List p=18f4520
#include<pic18f4520.inc>


    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming

    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    org 0x00            ; Set program start address to 0x00
    
    #define cur_state 0x010
    #define local_n 0x05

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

start:
int:
; let pin can receive digital signal
    MOVLW 0x0f          ; Set ADCON1 register for digital mode
    MOVWF ADCON1        ; Store WREG value into ADCON1 register
    CLRF PORTB          ; Clear PORTB
    BSF TRISB, 0        ; Set RB0 as input (TRISB = 0000 0001)
    CLRF LATA           ; Clear LATA
    BCF TRISA, 0 
    BCF TRISA, 1
    BCF TRISA, 2 
    
    CLRF cur_state
    
; Button check
state_0:
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    BRA state_0
    
    
state_1:    
    BSF LATA, 0
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    BCF LATA, 0
    
    BSF LATA, 1
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    BCF LATA, 1
    
    BSF LATA, 2
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    BCF LATA, 2
    
    
    BRA state_1
    
    
state_2:
    CLRF local_n
    MOVLW 0x02
    MOVWF local_n
    
    BSF LATA, 0
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    
    BSF LATA, 1
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    BCF LATA, 1
    BCF LATA, 0
    
state_2_loop:
    BSF LATA, 2
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    
    BCF LATA, 2
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    
    DECFSZ local_n
    BRA state_2_loop
    
    ; last light
    BSF LATA, 2
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    DELAY d'111', d'70' ; 0.25 sec
    RCALL check_button
    BCF LATA, 2
    ; inf loop for state 2
    BRA state_2
    

check_button:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    RETURN
    BRA button_click
    

button_click:
    TSTFSZ cur_state
    BRA check_state_1_2 ; cur_state = 1 or 2
    BRA to_state_1 ; cur_state = 0

    
check_state_1_2:
    MOVLW 0x01
    CPFSEQ cur_state ; skip if eq
    BRA to_state_0 ; cur_state = 2
    BRA to_state_2 ; cur_state = 1
    
to_state_0:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    
    CLRF cur_state
    BRA state_0
    
to_state_1:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    
    MOVLW 0x01
    MOVFF WREG, cur_state
    BRA state_1
    
to_state_2:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    
    MOVLW 0x02
    MOVFF WREG, cur_state
    BRA state_2
    
end





