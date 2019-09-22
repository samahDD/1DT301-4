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
; Function: Create an electronic dice. The number 1 to 6 should be generated
;						randomly. The result should be displayed through the LEDs

; Input ports: PORTA checks if we pressed the switch 0 (SW0).
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
ldi r16, 0xFF ; we load 0b1111 1111 to r16
out DDRB, r16 ; we set the DDRB as output

ldi r17, 0x00 ; we load 0b0000 0000 to r17
out DDRA, r17 ; we set DDRA as input


out PORTB, r16 ;we output r16 to PORTB

ldi r18, 0b11111110 ; we load 0b1111 1110 to r18
;it will allow us to make sure that SW0 is pressed

ldi r20, 1 ; we load 0b0000 0001 to r20

ldi r16, 0b11111111 ;we load 0b1111 1111 to r16

loop :
	;We check if SW0 is pressed or not
	in r19,PINA ;we put PINA data into r19
	cp r19, r18 ;we compare r19 to r18 (0b1111 1110)
	breq listening_loop ; if r19 == r18 then go to listening_loop

rjmp loop ;otherwise jump back to loop and repeat it until it is true (SW0 pressed)


listening_loop :
	inc r20 ;we increment r20 by 1
	cpi r20, 7 ;cpi allows us to compare constant numbers.
	;so here compare r20 to 7
	breq reset ;if r20 == 7 we go to reset
	;this part allow us to check if SW0 is still pressed or not.
	;if PINA is still pressed, we stay in this loop and r20 gets +1
	;if it is not pressed anymore, so we released the button we go to random
	in r19, PINA ;we put PINA data into r19
	cp r16,r19 ;we compare r16 (0b1111 1111) and r19
	breq random ; if r16 == r19 we go to random
rjmp listening_loop ;jump back to listening_loop if button SW0 not released

reset :
	ldi r20, 1 ;we set back r10 to 1 when r20 reaches 7
	rjmp loop ;and we jump back to the beginning loop

random :
;this part allows us to do the random process. Meaning, we check the constant
;If the Constant r20 is equal to the corresponding number
; it will go to another section of the program

	cpi r20, 1 ;we compare the constant r19 to check if r20 == 1
	breq number_one ;if yes we go to number_one
	cpi r20, 2
	breq number_two
	cpi r20, 3
	breq number_three
	cpi r20, 4
	breq number_four
	cpi r20, 5
	breq number_five
	cpi r20, 6
	breq number_six


number_one:
	ldi r22, 0b11111101 ;we load 0b1111 1101 to r22
	out PORTB, r22 ;we turn on the light LED 2
	rjmp loop ;we turn on the light and we go back to the loop and wait
	;we wait for another SW0 pressed

number_two:
	ldi r22, 0b10111101
	out PORTB, r22
rjmp loop
number_three:
	ldi r22, 0b10101011
	out PORTB, r22
rjmp loop
number_four:
	ldi r22, 0b00111001
	out PORTB, r22
rjmp loop
number_five:
	ldi r22, 0b00101001
	out PORTB, r22
rjmp loop
number_six:
	ldi r22, 0b00010001
	out PORTB, r22
rjmp loop
