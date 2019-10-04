;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;	Anas Kwefati
;
; Lab number: 4
; Title: Timer and UART
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Modify task 3 to obtain an echo. The program should receive the character
;and send it back to the terminal.
;
; Input ports: PORT0 (RS232) VGA
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: Timer Interrupt Subroutine
; Included files: m2560def.inc
;
; Other information:
;The code for this exercice was taken from the lecture.
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp start

.org 0x72


start:
	ldi r16,0xFF	;Set PORTB as output
	out DDRB, r16

	out PORTB,r16	;Iniatialize LEDs state

	ldi r16, 12		;osc = 1MHz, 4800 bps => UBBRR = 12
	sts UBRR1L , r16	;Store Prescaler value in UBRR1L

	ldi r16, (1<<RXEN1 | 1<<TXEN1);Set RX and TX enable flags
	sts UCSR1B, r16

GetChar:	;Receive data
	lds r16, UCSR1A	;read UCSR1A I/0 register to r16
	sbrs r16,RXC1	;RXC1=1 -> new Character
	rjmp GetChar	;RXC1=0 -> no character received
	lds r18,UDR1	;Read character in UDR

Port_output:	;Show Data on LEDs
	com r18
	out PORTB,r18	;Write character to PORTB
	com r18

PutChar:	;Show data back to the terminal
	lds r16, UCSR1A	;Read UCSR1A i/O register to r16
	sbrs r16, UDRE1	;UDRE1 =1 => buffer is empty
	rjmp PutChar	;UDRE1 = 0 => buffer is not empty
	sts UDR1,r18	;write character to UDR1
	rjmp GetChar	;Return to loop
