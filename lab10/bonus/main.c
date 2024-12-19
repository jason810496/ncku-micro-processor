#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;
#define _XTAL_FREQ 1000000   // Fosc = 1 MHz

char str[20];
void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
        
        
        
        if( stop > 0 ){
            
            int prev_stop = stop;
            LATD = 0;
            while( prev_stop == stop ){
                // should #define _XTAL_FREQ 1000000   // Fosc = 1 MHz
                // before using __delay_ms
                __delay_ms(500); // 0.5 sec
                if( LATD == prev_stop ){
                    LATD = 0;
                }
                LATD++;
            }
            LATD = 0;

        }
        
    }
    return;
}
//#pragma interrupt ISR
//void ISR(void)
//{
//    // handle button interrupt
//    if(INTCONbits.INT0IF){
//        LATD = 0;
//        counter = 0;
//        INTCONbits.INT0IF = 0;
//    }
//    
//    // handle uart interrupt
//    if(RCIF)
//    {
//        if(RCSTAbits.OERR)
//        {
//            CREN = 0;
//            Nop();
//            CREN = 1;
//        }
//        
//        
//        MyusartRead();
//        
//        // set light to 0
//        LATD = 0;
//        counter = 0;
//        RCIF = 0;   //Clear flag bit
//        return;
//    }
//    
//    
//    return;
//}
