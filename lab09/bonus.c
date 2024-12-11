#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)
#define _XTAL_FREQ 1000000   // Fosc = 1 MHz


void set_LED_lightness(int value){
    CCPR1L = (value >> 2) & 0xFF;    // high 8 bits
    CCP1CONbits.DC1B = value & 0b11; // low 2 bits
}

void __interrupt(high_priority)H_ISR(){  
    //step4
    int value = (ADRESH << 8) + ADRESL; // max: 1023
    //do things

    if(value < 512){
        set_LED_lightness(value << 2);
    }
    else{
        set_LED_lightness((1023 - value) << 2);
    }
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    //step5 & go back step3
    __delay_ms(5);  // delay at least 2Tad
    ADCON0bits.GO = 1;
      
    return;
}

void init_ADC(){
    TRISAbits.RA0 = 1;       // analog input port
    ADCON1bits.PCFG = 0b1110; // AN0 as analog input,others as digital
    ADCON0bits.CHS = 0b0000;  // Select AN0 channel
    
    // Set RC0, RC1, RC2, RC3 as digital output for the LEDs
    TRISC = 0;  // Set PORTC as output
    LATC = 0;   // Clear PORTC data latch
    
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; // 1MHz
    
    //step1
    ADCON1bits.VCFG0 = 0;     // Vref+ = Vdd
    ADCON1bits.VCFG1 = 0;     // Vref- = Vss
    ADCON2bits.ADCS = 0b000;  // ADC clock Fosc/2(go search list)
    ADCON2bits.ACQT = 0b001;  // Tad = 2 us acquisition time set 2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;      // Enable ADC
    ADCON2bits.ADFM = 1;      // right justified 
    // ( move init ADC interrupt to init_interrupt() )
    // step3
    ADCON0bits.GO = 1;    // Start ADC conversion
}

void init_PWM(){
    /*init CCP*/
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    //RB0 -> Input
    TRISB = 1;
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8µs * 4
     * = 0.00144s ~= 1450µs
     */
    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;
}

void init_interrupt(){
    PIE1bits.ADIE = 1;    // Enable ADC interrupt
    PIR1bits.ADIF = 0;    // Clear ADC interrupt flag
    INTCONbits.PEIE = 1;  // Enable peripheral interrupts
    INTCONbits.GIE = 1;   // Enable global interrupts
}

void main(void) 
{
    
    init_ADC();
    init_PWM();
    init_interrupt();

    while(1);
    
    return;
}