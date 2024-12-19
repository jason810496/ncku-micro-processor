#include <xc.h>
    //setting TX/RX

char mystring[20];
int lenStr = 0;

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
    */
           
    TRISCbits.TRISC6 = 1;            
    TRISCbits.TRISC7 = 1;            
    
    //  Setting baud rate = 1200
    TXSTAbits.SYNC = 0; // Asyn mode           
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1;  //Enable asynchronous serial port             
    PIR1bits.TXIF = 1;   //TXREG is empty 
    PIR1bits.RCIF = 0;   //Reception is not complete
    TXSTAbits.TXEN = 1;  //Enable transmission        
    RCSTAbits.CREN = 1;  //Enables receiver       
    PIE1bits.TXIE = 0;   //Enable interrupt   
    IPR1bits.TXIP = 0;   //Transmit Interrupt is low Priority                   
    PIE1bits.RCIE = 1;   //Enable interrupt     

    // impotant !!!!!!!!!
    // WTF is this shit
    IPR1bits.RCIP = 0;   //Receive Interrupt is low Priority    
    
    
    // init ADC
    ADCON1 = 0x0f;            //Digital
    RCONbits.IPEN = 1;      //Enables Priority
    INTCONbits.GIE = 1;     //Set Global Interrupt Enable bit
    INTCONbits.INT0IE = 1;  //Enables the INT0 external interrupt
    INTCONbits.INT0IF = 0;  //Clear Interrupt Flag bit
    TRISD = 0b0;          //Set A as output
    LATD = 0b0;           //Initialize as 0 
    TRISB = 1;          //Set RB0 as input
}

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    char temp = RCREG;
    
    // allow newline on terminal
    if(temp == '\r' ){
        UART_Write ('\r');
        temp = '\n';
    }
    UART_Write (temp);
    
    if( temp >= '0' && temp <= '9' ){
        // we don't need to -'0' for this shit
        LATD = temp ;
    }
     UART_Write (temp);
   
    
    
    return ;
}
    
char *GetString(){
    return mystring;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
        RCIF = 0;   //Clear flag bit
    }
    
   // process other interrupt sources here, if required
    return;
}
