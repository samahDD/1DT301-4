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
ldi r18, 0b11111110
ldi r20, 1

ldi r16, 0b11111111

loop : 
	in r19,PINA
	cp r19, r18
	breq listening_loop

rjmp loop


listening_loop :
	inc r20 
	cpi r20, 7
	breq reset
	in r19, PINA
	cp r16,r19
	breq random
rjmp listening_loop

reset : 
	ldi r20, 1
	rjmp loop
	
random : 
	cpi r20, 1
	breq number_one
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
	ldi r22, 0b11111101
	out PORTB, r22
	rjmp loop

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

	
