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
;	Function: Creates a ring counter, updates every 0.5 seconds
;
;	Input ports: None
;
;	Output ports: PORTB, used for LEDS
;
;	Subroutines: Timer
;	Included files: m2560def.inc
;
;	Other information: None
;
;	Changes in program: 
;		09-09-2019 > file created
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

main:
	; Initialize SP, Stack Pointer
	ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
	out SPH,R20 ; SPH = high part of RAMEND address
	ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
	out SPL,R20 ; SPL = low part of RAMEND address

	LDI r20, 0xFF
	OUT DDRB, r20
	CBR r20, 1 ; set output
	OUT PORTB, r20
	call timer

lightloop:
	LSL r20
	BRCS setbit
lightloopcont:
	OUT PORTB, r20
	call timer
	call lightloop

setbit:
	SBR r20, 1
	CLC
	call lightloopcont

timer:
; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
	ldi  r17, 5
    ldi  r18, 20
    ldi  r19, 175
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    dec  r17
    brne L1
	ret

