;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;	Anas Kwefati
;
; Lab number: 3
; Title: Interrupts
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Write a program that turns ON and OFF when we push the button.
;The program must use interrupts
;
; Input ports: PORTD checks if we pressed the button
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
;The term VECTOR means nothing more than that each interrupt has its specific address where it jumps to.
; The term TABLE means it is a list of jump instructions. This is a list of rjmp or jmp instructions, sorted by interrupt priority


.org 0x00 ;This is the location that the program will start executing from
rjmp start

.org INT0addr ;We are using INT0
rjmp interrupt ;we jump to interrupt when the External interrupt will occur

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


	ldi r17, 0b0000001 ;We set 0b00000001 to activate INT0
	out EIMSK, r17 ; Toggle external interrupt requests
	;EIMSK or External Interrupt Mask Register allows to set a bit to enable the related interrupt


	ldi r17, 0b00000010 ;We put 0b0000 0010 to r17
	;we do this to activate the interrupt during a falling edge
	sts EICRA, r17 ;EICRA allows us to define the type of signals
	;that activates the external interrupt

	sei ;enabling all interrupts


main_program:
nop ;we don't do anything
rjmp main_program ; we stay in the main_program until an external interrupt occurs



interrupt:
	com r16 ;we reverse the 0b1111 1111 to 0b0000 0000 like that we turn all light on
	out portB, r16 ;We output the value of r16 to the PORTB
reti ;return from interrupt instruction
