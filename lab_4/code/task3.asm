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
; Function: Program that uses the serial communication PORT0 (RS232).
;The program should receive characters that are sent from the computer and show the code on the LEDs.
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

start:	;To initialize everything
	ldi r16,0xFF	;PORTB outputs
	out DDRB, r16

	out PORTB,r16	;Iniatial value to outputs

	ldi r16, 12	;osc = 1MHz, 4800 bps => UBBRR = 12
	sts UBRR1L , r16	;Store Prescaler value in UBRR1L

	ldi r16, (1<<RXEN1)	;Set RX enable flags
	sts UCSR1B, r16

GetChar:	;Receive data
	lds r16, UCSR1A	;read UCSR1A I/0 register to r16
	sbrs r16,RXC1	;RXC1=1 -> new Character Skip if bit RXC1 is set in r16
	rjmp GetChar	;RXC1=0 -> no character received otherwise rjmp
	lds r18,UDR1	;Read character in UDR

Port_output:	;Show data on the LEDs
	com r18	;COM to have the 1s become 0s 
	out PORTB,r18	;Write character to PORTB
	com r18	;COM again to make it normal
