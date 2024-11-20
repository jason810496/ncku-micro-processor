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

    L1 EQU 0x14
    L2 EQU 0x15

    MAXNUM EQU 0x20
    CUR_STATE EQU 0x21
    ; CUR_STATE: 0, 1, 2
    IS_BACKWARD EQU 0x22
    ; IS_BACKWARD: 0, 1

    org 0x00
    
DELAY macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
endm
	
; 程式邏輯：會一直卡在main裡面做無限迴圈，按下RB0的按鈕後會觸發interrupt，跳到ISR執行
; ISR裡的內容會亮起所有在RA上的燈泡，Delay約0.5秒後熄滅。

goto Initial			; 避免程式一開始就會執行到ISR這一段，要跳過。
ISR:				; Interrupt發生時，會跳到這裡執行。
    org 0x08	
    ; setup ISR		
    BTFSS INTCON, INT0IF
    GOTO toggle_lights ; btn not press -> switch state
      ; toggle timer2
      toggle_timer:
          check_025_sec:
            MOVLW D'61'
            CPFSEQ PR2
            GOTO check_05_sec
            MOVLW D'122'
            GOTO toggle_state
          check_05_sec:
            MOVLW D'122'
            CPFSEQ PR2
            GOTO check_1_sec
            MOVLW D'244'
            GOTO toggle_state
          check_1_sec:
            MOVLW D'244'
            CPFSEQ PR2
            GOTO toggle_state
            MOVLW D'21'
            GOTO toggle_state
      toggle_state:
          check_state_1:
              MOVLW 0x01
              CPFSEQ CUR_STATE
              GOTO check_state_2
                ; to state 2
                MOVLW 0x02
                MOVWF CUR_STATE
                ; upd max num and is backward
                MOVLW 0x07
                MOVWF MAXNUM
                CLRF IS_BACKWARD
                ; reset LATA
                CLRF LATA
              GOTO toggle_lights
          check_state_2:
              MOVLW 0x02
              CPFSEQ CUR_STATE
              GOTO check_state_3
                ; to state 3
                MOVLW 0x03
                MOVWF CUR_STATE
                ; upd max num and is backward
                MOVLW 0x0F
                MOVWF MAXNUM
                CLRF IS_BACKWARD
                ; reset LATA
                CLRF LATA
              GOTO toggle_lights
          check_state_3:
              MOVLW 0x03
              CPFSEQ CUR_STATE
              GOTO check_state_1
                ; to state 1
                MOVLW 0x01
                MOVWF CUR_STATE
                ; upd max num and is backward
                MOVLW 0x0F
                MOVWF MAXNUM
                MOVLW 0x01
                MOVWF IS_BACKWARD
                ; reset LATA
                MOVLW 0x0F
                MOVWF LATA
              GOTO toggle_lights
      toggle_lights:
        ; is backward
          BTFSS IS_BACKWARD, 0
          GOTO light_forward
          GOTO light_backward
        light_forward:
          INCF LATA
            BTFSC MAXNUM, 3
            GOTO mod_by_16
            GOTO mod_by_8
            mod_by_8:
              BTFSC LATA, 3
              CLRF LATA
            mod_by_16:
              BTFSC LATA, 4
              CLRF LATA
          GOTO isr_tear_down
        light_backward:
          DECF LATA
            ; check if LATA is 0
            MOVLW 0x00
            CPFSEQ LATA
            GOTO isr_tear_down
            MOVLW 0x0F
          GOTO isr_tear_down
      isr_tear_down:
    ; teardown ISR 
    BCF INTCON, INT0IF
    BCF PIR1, TMR2IF
    RETFIE                    ; 離開ISR，回到原本程式執行的位址，同時會將GIE設為1，允許之後的interrupt能夠觸發
    
    
Initial:				; 初始化的相關設定
    MOVLW 0x0F
    MOVWF ADCON1		; 設定成要用數位的方式，Digitial I/O 
    
    CLRF TRISA
    CLRF LATA
    BSF TRISB,  0
    BCF RCON, IPEN
    BCF INTCON, INT0IF		; 先將Interrupt flag bit清空
    BSF INTCON, GIE		; 將Global interrupt enable bit打開
    BSF INTCON, INT0IE		; 將interrupt0 enable bit 打開 (INT0與RB0 pin腳位置相同)
    ; init timer2
    BCF PIR1, TMR2IF		; 為了使用TIMER2，所以要設定好相關的TMR2IF、TMR2IE、TMR2IP。
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; 將Prescale與Postscale都設為1:16，意思是之後每256個週期才會將TIMER2+1
    MOVWF T2CON		; 而由於TIMER本身會是以系統時脈/4所得到的時脈為主
    MOVLW D'61'		; 因此每256 * 4 = 1024個cycles才會將TIMER2 + 1
    MOVWF PR2			; 若目前時脈為250khz，想要Delay 0.5秒的話，代表每經過125000cycles需要觸發一次Interrupt
				; 因此PR2應設為 125000 / 1024 = 122.0703125， 約等於122。
    MOVLW D'00100000'
    MOVWF OSCCON	        ; 記得將系統時脈調整成250kHz
    ; init MAXNUM
    MOVLW 0x07
    MOVWF MAXNUM
    ; init CUR_STATE
    CLRF CUR_STATE
    ; init IS_BACKWARD
    CLRF IS_BACKWARD
    
main:
    bra main
end
