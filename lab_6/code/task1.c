/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;    Anas Kwefati
;
; Lab number: 6
; Title: CyberTech Wall Display
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program that writes a character on the CyberTech Display.
;
; Input ports: none
;
; Output ports: CyberTech Display.
;
; Subroutines:
; Included files: <avr/io.h>
;
;Other information: Display is connected to the serial port (RS232) on the STK600.
; Communication speed is 2400bps.
;Changes in program: (Description and date)
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/

#include <avr/io.h>
#include <stdio.h>
#include <string.h>
//#include <util/delay.h>
#define FCPU 1000000// Clock Speed
#define BAUD 2400 //Communication Speed Display rate 2400
#define MYUBBRR (FCPU/16/BAUD-1) //UBBRR = 25 -> osc = 1MHz and UBRR = 47 -> osc = 1,843200MHz

void uart_int(void);
void toPutty(unsigned char data);

int main(void)
{
    uart_int();
    
    char* txt = "\rAO0001Hi How are you ? :)";
    int checksum =0;
    //We make sure that everything is in it
    for(int i =0; i<strlen(txt);i++){
        checksum += txt[i];
    }
    
    checksum%=256;
    
    char toDisplay [strlen(txt)+3];
    sprintf(toDisplay, "%s%02X\n", txt, checksum); //%02x means print at least 2 digits, prepends it with 0's if there's less.
    //%02x is used to convert one character to a hexadecimal string
    
    for (int i = 0; i<strlen(txt)+3;i++){
        toPutty(toDisplay[i]);
    }
    
    txt = "\rZD0013C\n";
    for(int i = 0; i<strlen(txt);i++){
        toPutty(txt[i]);
    }
    
    return 0;
}

//INITALIZATION OF THE DISPLAY

void toPutty(unsigned char data){
    //WAIT FOR DATA TO BE RECEIVED
    while(!(UCSR1A & (1<<UDRE1)));
    UDR1 = data;
}

void uart_int(void) {
    UBRR1L = MYUBBRR; //25 because we are setting the board at 1MHz
    /*Enable receiver and transmitter*/
    UCSR1B = (1<<RXEN1|1<<TXEN1); // Receive Enable (RXEN) bit // Transmit Enable (TXEN) bit
}






