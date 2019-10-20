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
; Function: Program that changes text strings on the display.
;
; Input ports: none
;
; Output ports: CyberTech Display.
;
; Subroutines:
; Included files: <avr/io.h> and <util/delay.h>
;
;Other information: Display is connected to the serial port (RS232) on the STK600.
; Communication speed is 2400bps.
;Changes in program: (Description and date)
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#include <avr/io.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define F_CPU 1000000// Clock Speed
#include <util/delay.h>
#define BAUD 2400 //Communication Speed Display rate 2400
#define MYUBBRR (F_CPU/16/BAUD-1) //UBBRR = 25 -> osc = 1MHz and UBRR = 47 -> osc = 1,843200MHz

void uart_int(void);
void toPutty(unsigned char data);
void toDisplayOnLCD(char* stringChar);

int main(void)
{
	uart_int();
	

	char* data = "abc";
	char *txt = "\rAO0001";
	
	for(int i =0;i<strlen(data);i++){
		//The idea is to take char by char and add it one by one to str2
		char c = data[i];
		size_t len = strlen(txt); //take the length of txt
		char *str2 = malloc(len + 1 + 1); //give a length of len and allocate a bit more memory with malloc in case 
		strcpy(str2, txt); // copy txt to str2
		str2[len] = c;  //create an array of str2 with a length of len for the char c
		str2[len + 1] = '\0'; // we add 1 to len and add the end char \0
		toDisplayOnLCD(str2); //call display
		free(str2); //free str2 deallocate the space used by malloc()
		
		str2 = "\rZD0013C";
		toDisplayOnLCD(str2);
		_delay_ms(5000); //wait 5s
	}

		
	return 0; 
}



//METHOD TO DISPLAY ON THE SCREEN 
void toDisplayOnLCD(char* stringChar){
	
	int checksum = 0; 
	 //We make sure that everything is in it
	 for(int i =0; i<strlen(stringChar);i++){
		 checksum += stringChar[i];
	 }
	 
	 checksum%=256;
	 
	 char toDisplay [strlen(stringChar)+3];
	 sprintf(toDisplay, "%s%02X\n", stringChar, checksum); //%02x means print at least 2 digits, prepends it with 0's if there's less.
	 //%02x is used to convert one character to a hexadecimal string
	
	for (int i = 0; i<strlen(stringChar)+3;i++){
		toPutty(toDisplay[i]);
	}
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



