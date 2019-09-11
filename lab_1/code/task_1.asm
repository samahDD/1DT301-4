;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	1DT301, Computer Technology 1
;	Date: 09-09-2019
;	Authors:
;		Roel de Vries
;		Anas Kwefati
;
;	Lab number 1
;	Title:	How to use the PORTS, digital IO, subroutine call
;
;	Hardware: STK600, CPU ATmega 2560
;
;	Function: Turn on LED 2 in Assembly
;
;	Input ports: None
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
	SBI DDRB, 2
	CBI PORTB, 2
