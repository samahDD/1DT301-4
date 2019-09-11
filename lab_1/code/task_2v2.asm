;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2019-09-95
; Author:
;   Roel de Vries
;   Anas Kwefati
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
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



;TASK_2

.include "m2560def.inc"
ldi r16, 0xFF
out DDRB, r16
ldi r17, 0x00
out DDRD, r17

ldi r16, 0xFF
out PORTB,r16


loop:

in r18, PIND
ldi r20, 0xFF
EOR r18, r20
out PORTB, r18

rjmp loop
