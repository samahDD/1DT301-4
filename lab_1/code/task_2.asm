;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	1DT301, Computer Technology 1
;	Date: 09-09-2019
;	Authors:
;		Roel de Vries
;		Student name 2
;
;	Lab number 1
;	Title:	How to use the PORTS, digital IO, subroutine call
;
;	Hardware: STK600, CPU ATmega 2560
;
;	Function: Turn on Led n if switch n is pressed
;
;	Input ports: PORTA, used for the switches
;
;	Output ports: PORTB, used for LEDS
;
;	Subroutines: None
;	Included files: m2560def.inc
;
;	Other information: None
;
;	Changes in program: 
;		09-09-2019 > file created
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

main:
	; set output
	LDI r20, 0xFF
	OUT DDRB, r20
	
	; set input
	LDI r20, 0x00
	OUT DDRA, r20

lightloop:
	IN r18, PINB
	LDI r20, 0xFF
	EOR r18, r20
	OUT PORTB, r18
