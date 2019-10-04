;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Author:
;	Anas Kwefati
;
; Lab number: 4
; Title: Timer and UART
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Write a program that creates a square wave. The LED has to switch with
; the frequence of 1Hz. Duty cycle 50% -> ON : 0.5s ; OFF : 0.5s.
; Use Timer interrupt with 2Hz, which change between ON and OFF.
;
; Input ports: None
;
; Output ports: PORTB turns on/off the light (LEDs)
;
; Subroutines: Timer Interrupt Subroutine
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
;The term VECTOR means nothing more than that each interrupt has its specific address where it jumps to.
; The term TABLE means it is a list of jump instructions. This is a list of rjmp or jmp instructions, sorted by interrupt priority


;TCCR0: In this register (used to configure the timer), there are 8 bits, but only last 3 bits CS02,CS01 and CS00 are used.
;These are CLOCK SELECT bits used to setup the prescaler

;TCNT0: This is the real counter in the TIMER0 counter.
;The timer clock counts this register as 1, ie the timer clock increases the value of this 8 bit register by 1 with every timer clock pulse.
; The timer clock can be defined by the TCCRO register

;TIMSK0: This register, used to activate/deactivate the INTERRUPTS related to timers,controls the interrupts of all three timers.
;BIT0 (first bit from the right) controls the the overflow interrupts of TIMER0.
;Note that TIMER0 has one interrupt, and the rest of the bits are for other counters

.org 0x00 ;This is the location that the program will start executing from
rjmp start

;TIMER0 is an 8 bit counter clock
.org OVF0addr
rjmp timer0_int


.org 0x72
start:
	; Initialize SP, Stack Pointer
	ldi r16, HIGH(RAMEND) ; R20 = high part of RAMEND address
	out SPH,r16 ; SPH = high part of RAMEND address
	ldi r16, low(RAMEND) ; R20 = low part of RAMEND address
	out SPL,r16 ; SPL = low part of RAMEND address

	;Main program initialization
	ldi r17, 0xFF ;
	out DDRB, r17 ; we set the DDRB as output

	;TCCR0 control the clock selection
	;This is the to choose the timer to count in ms
	ldi r16, 0b00000101 ;We prescale the value 0x05 = 0b0000 0101 so when we look to TCCR0 table we take clk/1024
	out TCCR0B, r16 ;CS2 - CS2 = 101 osc.clock/1024

	;TIMSK or Timer Interrupt Mask Register allows to set TOIEx and 1bit in SREG to enable overflow interrupt
	ldi r16, 0b00000001 ;we choose 0000 0001 Timer0 ;TOIE0 Timer Overflow Interrupt Enable (TIMER0)
	sts TIMSK0, r16  ;We output it in register TIMSK


	ldi r16, 155 ;Starting value for counter it counts from 155 to 255
	;So it will take 100ms to go from 155 to 255.
	out TCNT0, r16 ;We output the counter in Register TCNT0 (Real counter in the TIMER0)

	ldi r19, 0b00000000 ;TO turn on the light

	sei ;enabling all interrupts


main_program:
nop
rjmp main_program

ldi r17, 0 ;COUNTER

timer0_int :
	;Important to not do multiple interrupts at the same time and do one by one
	push r16 ;timer interrupt routine
	in r16, SREG ;save SREG on stack
	push r16

	;WE SET THE COUNTER TCNT0 back
	ldi r16, 155
	out TCNT0, r16


	inc r17 ;increase r17

	cpi r17,5   ;compare r17 with how many time it goes inside this interrupt
	;we take 5, because 5x100ms = 500ms so it will be the half of 1000ms
	brne continue

	ldi r17, 0 ;reset r17 the counter

	com r19 ;complement of r19 to turn off the light
	out PORTB, r19 ;Output r19 to PORTB

	continue :
		nop

	;It allows to exit the interrupt by restoring SREG
	pop r16 ;restore SREG
	out SREG, r16
	pop r16 ;restore register


RETI ;return from interrupt
