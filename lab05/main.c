/*
 * File:   main.c
 * Author: jason
 *
 * Created on October 23, 2024, 9:47 AM
 */


#include <xc.h>

extern unsigned char mysqrt(unsigned char char); 

void main(void) {

    volatile unsigned char result = mysqrt(10);

    while(1);
    return;
}
