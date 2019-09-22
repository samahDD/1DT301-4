;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;	Anas Kwefati
;
; Lab number: 2
; Title: Subroutines
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The program counts the number of time we press and release SW0
;
; Input ports: PORTA checks if we pressed the switch 0 (SW0; PA0).
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

; Initialize SP, Stack Pointer
ldi r21, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,R21 ; SPH = high part of RAMEND address
ldi R21, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R21 ; SPL = low part of RAMEND address

;we initialize
ldi r16, 0xFF ;
out DDRB, r16 ; we set the DDRB as output

ldi r17, 0x00
out DDRA, r17 ; we set DDRA as input

out PORTB, r16

ldi r18, 0b00000000 ; counter

ldi r19, 0b11111101 ; to check if button is pressed
ldi r23, 0xFF

loop :
	in r20, PINA
	cp r20,r19 ;compare r20 and r19
	breq counting ;if equal then go to counting
rjmp loop


counting :
	inc r18 ; we add +1 to the counter
	;so when we press the first time r18 will become : 0b0000 0001

	mov r21, r18 ; we copy r18 to r21
	com r21 ; we put the reverse of what was in r21.
	
	;0 becomes 1 and 1 becomes 0. We put the complement of r21
	;So here, r21 will become 0b1111 1110
	;we display the binary value. When LEDs are turned on it means 1
	;When LED is not turned on it means 0.
	;For example when we press, we count 1 and its binary value is : 0000 0001
	;We reverse it and we get 1111 1110. Which means we turn on the light at LED1
	;In LED logic, 0 means light on and 1 means light off.
	;When light is on (0 for LED logic) for us it will mean 1.
	;When light is off (1 for LED logic) for us it will mean 0.

	out PORTB, r21 ;we output r21 in PORTB to turn the correct LED position

	counting_loop :

		in r20, PINA ; we take the data of PINA and put it in r20
		cp r20, r23 ; we compare r20 with r23

		breq whatever ;if r20 == r23 we go to whatever

		rjmp counting_loop ;else we go back to the beginning of that loop

whatever :
	inc r18 ;we increment r18 by 1
	mov r21, r18 ;we copy r18 to r21
	com r21 ;  we put the reverse of what was in r21.

	out PORTB, r21 ;we output it in PORTB

	rjmp loop ;we start over, from the beginning
