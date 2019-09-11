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
;	Function: Turn on Led 0 when you press led 5
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
	SBI DDRB, 0 ; set output
	CBI DDRA, 5 ; set input

lightloop:

	SBIS PINA, 5
	CBI PORTB, 0
	SBIC PINA, 5	
	SBI PORTB, 0  
