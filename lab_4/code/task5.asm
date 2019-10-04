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
; Function: Do task 3 and 4 but using Interrupt instead of polled UART.
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

.org URXC1addr	;USART Interrupt
rjmp GetChar

.org 0x72


start:
	ldi r16,LOW(RAMEND)	;iniatilize SP
	out SPL,r16
	ldi r16,HIGH(RAMEND)
	out SPH,r16

	ldi r16,0xFF	;Set PORTB as output
	out DDRB, r16
	out PORTB,r16	;Initialize LEDs



	ldi r16, 12		;osc = 1MHz, 4800 bps => UBBRR = 12
	sts UBRR1L , r16	;Store Prescaler value in UBRR1L

	ldi r16, 0b10011000;Set RX, TX enable flags and RXCIE = 1
	sts UCSR1B, r16

	sei	;Set global interrupt flag

main_program:
nop		;Infinite loop that does nothing
rjmp main_program

GetChar:	;Receive data
	lds r16, UCSR1A	;read UCSR1A I/0 register to r16
	lds r18,UDR1	;Read character in UDR

  Port_output:	;Show data on the LEDs
  	com r18
  	out PORTB,r18	;Write character to PORTB
  	com r18

  PutChar:	;Sends back the character to the Terminal
  	lds r16, UCSR1A	;Read UCSR1A i/O register to r16
  	sts UDR1,r18	;write character to UDR1

RETI	;Return from interrupt
