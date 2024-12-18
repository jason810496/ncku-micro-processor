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
        if(str[0]=='m' && str[1]=='1'){ // Mode1
            Mode1();
            ClearBuffer();
        }
        else if(str[0]=='m' && str[1]=='2'){ // Mode2
            Mode2();
            ClearBuffer();  
        }
    }
    return;
}

// void __interrupt(high_priority) Hi_ISR(void)
// {
//     if(INTCONbits.INT0IF){
//         LATD = 0;
//     }
//     INTCONbits.INT0IF=0;
//     return;
// }

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
