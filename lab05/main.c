/*
 * File:   main.c
 * Author: jason
 *
 * Created on October 23, 2024, 9:47 AM
 */


#include <xc.h>
// #include <cmath>

extern unsigned char mysqrt(unsigned char num); 
extern unsigned int gcd(unsigned int a,unsigned int b);
extern unsigned int multi_signed(unsigned char a, unsigned char b);

void main(void) {

//    volatile unsigned char result = mysqrt(255);

//    volatile unsigned int result = gcd(5,30);
    
    volatile unsigned int result = multi_signed(50,50);
    
    while(1);
    return;
}
