;
; lab3.asm
;
; Created: 2019-09-23 13:41:25
; Author : ak223wd
;


.include "m2560def.inc"
;The term VECTOR means nothing more than that each interrupt has its specific address where it jumps to. 
; The term TABLE means it is a list of jump instructions. This is a list of rjmp or jmp instructions, sorted by interrupt priority


.org 0x00 ;This is the location that the program will start executing from
rjmp start 

.org INT0addr
rjmp interrupt

.org 0x72
start:
	; Initialize SP, Stack Pointer
	ldi r16, HIGH(RAMEND) ; R20 = high part of RAMEND address
	out SPH,r16 ; SPH = high part of RAMEND address
	ldi r16, low(RAMEND) ; R20 = low part of RAMEND address
	out SPL,r16 ; SPL = low part of RAMEND address



	;Main program initialization 
	ldi r16, 0xFF ; 
	out DDRB, r16 ; we set the DDRB as output
	

	ldi r17, 0b0000001
	out EIMSK, r17 ; Toggle external interrupt requests


	ldi r17, 0b00000010 ;Adress 0x02 is external interrupt 0
	sts EICRA, r17 ;we configure when to switch the external interrupt IN0

	sei ;enabling all interrupts

ldi r19, 0

main_program:
nop
rjmp main_program



interrupt: 
	com r16
	out portB, r16
reti ;return from interrupt instruction

	 
