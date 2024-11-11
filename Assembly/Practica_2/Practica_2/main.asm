;*******************
; Practica 1
;
; Created: 19/09/23
; Author : Andre Nicasio Romo
;*******************

.include "m16adef.inc"     
   
;*******************
;Registros (aqu� pueden definirse)
;.def temporal=r19

;Palabras claves (aqu� pueden definirse)
;.equ LCD_DAT=DDRC
;********************

.org 0x0000
;Comienza el vector de interrupciones...
jmp RESET ; Reset Handler
jmp EXT_INT0 ; IRQ0 Handler
jmp EXT_INT1 ; IRQ1 Handler
jmp TIM2_COMP ; Timer2 Compare Handler
jmp TIM2_OVF ; Timer2 Overflow Handler
jmp TIM1_CAPT ; Timer1 Capture Handler
jmp TIM1_COMPA ; Timer1 CompareA Handler
jmp TIM1_COMPB ; Timer1 CompareB Handler
jmp TIM1_OVF ; Timer1 Overflow Handler
jmp TIM0_OVF ; Timer0 Overflow Handler
jmp SPI_STC ; SPI Transfer Complete Handler
jmp USART_RXC ; USART RX Complete Handler
jmp USART_UDRE ; UDR Empty Handler
jmp USART_TXC ; USART TX Complete Handler
jmp ADC_COMP ; ADC Conversion Complete Handler
jmp EE_RDY ; EEPROM Ready Handler
jmp ANA_COMP ; Analog Comparator Handler
jmp TWSI ; Two-wire Serial Interface Handler
jmp EXT_INT2 ; IRQ2 Handler
jmp TIM0_COMP ; Timer0 Compare Handler
jmp SPM_RDY ; Store Program Memory Ready Handler

;**************
;Inicializar el Stack Pointer
;**************
Reset:
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16 


;*********************************
;Aqu� comienza el programa...
;No olvides configurar al inicio todo lo que utilizar�s
;*********************************

ldi R16, 0
out DDRA, R16         ;configuro a A de entrada
ldi R16, $FF
out PORTA, R16        ;A con pull ups

ldi R16, $FF  /*configuramos el puerto c como salidas*/
out DDRC, R16
/*ldi R16, 0
out PORTC, R16 */ /*opcional ya que no es necesario sacar nada*/
/*aqui empieza nuestro loop*/
Main_loop:
	in R16, PINA
	com r16
	
	cpi r16, $00
	breq CERO

	CPI R16, $01
	breq UNO

	CPI R16, $02
	breq DOS

	CPI R16, $03
	breq TRES

	CPI R16, $04
	breq CUATRO

	CPI R16, $05
	breq CINCO

	CPI R16, $06
	breq SEIS

	CPI R16, $07
	breq SIETE

	CPI R16, $08
	breq OCHO

	CPI R16, $09
	breq NUEVE

	rjmp LIMIT

	/*out PORTC, R16*/





	CERO:
	LDI R16, 0b0011_1111
	out PORTC, R16
	 rjmp Main_loop

	 UNO:
	 LDI R16, 0b0000_0110
	out PORTC, R16
	 rjmp Main_loop

	 DOS:
	 LDI R16, 0b0101_1011
	out PORTC, R16
	 rjmp Main_loop

	 TRES:
	 LDI R16, 0b0100_1111
	out PORTC, R16
	 rjmp Main_loop

	 CUATRO:
	 LDI R16, 0b0110_0110
	out PORTC, R16
	 rjmp Main_loop

	 CINCO:
	 LDI R16, 0b0110_1101
	out PORTC, R16
	 rjmp Main_loop

	 SEIS:
	 LDI R16, 0b0111_1101
	out PORTC, R16
	 rjmp Main_loop

	 SIETE:
	 LDI R16, 0b0000_0111
	out PORTC, R16
	 rjmp Main_loop

	 OCHO:
	 LDI R16, 0b0111_1111
	out PORTC, R16
	 rjmp Main_loop

	 NUEVE:
	 LDI R16, 0b0110_0111
	out PORTC, R16
	 rjmp Main_loop

	 LIMIT:
	 LDI R16, 0b0011_1111
	out PORTC, R16
	 rjmp Main_loop




;*********************************
;Aqu� est� el manejo de las interrupciones concretas
;*********************************
EXT_INT0: ; IRQ0 Handler
reti
EXT_INT1: 
reti ; IRQ1 Handler
TIM2_COMP: 
reti ; Timer2 Compare Handler
TIM2_OVF: 
reti ; Timer2 Overflow Handler
TIM1_CAPT: 
reti ; Timer1 Capture Handler
TIM1_COMPA: 
reti ; Timer1 CompareA Handler
TIM1_COMPB: 
reti ; Timer1 CompareB Handler
TIM1_OVF: 
reti ; Timer1 Overflow Handler
TIM0_OVF: 
reti ; Timer0 Overflow Handler
SPI_STC: 
reti ; SPI Transfer Complete Handler
USART_RXC: 
reti ; USART RX Complete Handler
USART_UDRE: 
reti ; UDR Empty Handler
USART_TXC: 
reti ; USART TX Complete Handler
ADC_COMP: 
reti ; ADC Conversion Complete Handler
EE_RDY: 
reti ; EEPROM Ready Handler
ANA_COMP: 
reti ; Analog Comparator Handler
TWSI: 
reti ; Two-wire Serial Interface Handler
EXT_INT2: 
reti ; IRQ2 Handler
TIM0_COMP: 
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler