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
	inc r18 ; we add +1
	
	mov r21, r18
	com r21	 

	out PORTB, r21

	counting_loop :
		
		in r20, PINA
		cp r20, r23

		breq whatever 

		rjmp counting_loop

whatever : 
	inc r18
	mov r21, r18
	com r21	 

	out PORTB, r21
	
	rjmp loop	







	

