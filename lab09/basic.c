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

char student_id[] = "74116720";

void __interrupt(high_priority)H_ISR(){  
    //step4
    int value = (ADRESH << 8) + ADRESL; // max: 1023
    //do things
    int index = value / 128; // (2^10 / 8) = 128 range : 0~7
    LATC = student_id[index] - '0'; 
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    //step5 & go back step3
    __delay_ms(5);  // delay at least 2Tad
    ADCON0bits.GO = 1;
      
    return;
}

void main(void) 
{
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
    
    
     // step2
    PIE1bits.ADIE = 1;    // Enable ADC interrupt
    PIR1bits.ADIF = 0;    // Clear ADC interrupt flag
    INTCONbits.PEIE = 1;  // Enable peripheral interrupts
    INTCONbits.GIE = 1;   // Enable global interrupts

    // step3
    ADCON0bits.GO = 1;    // Start ADC conversion
    
    while(1);
    
    return;
}