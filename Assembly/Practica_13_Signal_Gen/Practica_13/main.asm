;*******************
; Practica 13 generador de seniales
;
; Created: 22/11/23
; Author : Andre Nicasio Romo
;*******************

.include "m16adef.inc"     
   
;*******************
;Registros (aquí pueden definirse)
;.def temporal=r19

;Palabras claves (aquí pueden definirse)
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
//no se usa el sei 

;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

/*LDI r16,0
 out DDRA, r16
 ldi r16, $FF
 out PortA, r16*/ //no tenemos que usar puertos de entrada ni nada
 sei
 ldi r16, $FF
 out DDRB,r16

 ldi r16, $00
 out TCNT0, r16

 //configurar el timer 0
 ldi r16, 0
 out OCR0, r16
 ldi r16, 0b0110_1100
 out TCCR0, r16

ldi r16, 0b0000_0011
out TIFR, r16

ldi r16, 0b0000_0011 
out TIMSK, r16 

 ldi r16, 0 // Valor inicial del ocr0 representa el valor del ocr0
 out OCR0, r16
 ldi r16, 1// bandera
 ldi r24,0


 Main:


 rjmp Main



;*********************************
;Aquí está el manejo de las interrupciones concretas
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
in r25, SREG
push r25

sbrc r16, 0
rjmp Start

Read:

cpi zl, $FF
breq Limit

inc zl
rjmp Operate



Start:
ldi zh, High(SENAL_SENOIDAL*2)
ldi zl, Low(SENAL_SENOIDAL*2)
lpm

mov r24, r0
out OCR0, r24
inc r16
rjmp Fin

Limit:
inc zl
inc zh
rjmp Operate

reinicio: 
ldi r16,1
rjmp Start

Operate:
lpm
mov r24, r0
cpi r24, 0
breq reinicio

out OCR0, r24

Fin:

 pop r25
 out SREG, r25 

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

SENAL_SENOIDAL:
.db 128,131,134,137,140,144,147,150,153,156,159,162,165,168,171,174
.db 177,179,182,185,188,191,193,196,199,201,204,206,209,211,213,216
.db 218,220,222,224,226,228,230,232,234,235,237,239,240,241,243,244
.db 245,246,248,249,250,250,251,252,253,253,254,254,254,254,254,254
.db 254,254,254,254,254,254,254,253,253,252,251,250,250,249,248,246
.db 245,244,243,241,240,239,237,235,234,232,230,228,226,224,222,220
.db 218,216,213,211,209,206,204,201,199,196,193,191,188,185,182,179
.db 177,174,171,168,165,162,159,156,153,150,147,144,140,137,134,131
.db 128,125,122,119,116,112,109,106,103,100,97,94,91,88,85,82
.db 79,77,74,71,68,65,63,60,57,55,52,50,47,45,43,40
.db 38,36,34,32,30,28,26,24,22,21,19,17,16,15,13,12
.db 11,10,8,7,6,6,5,4,3,3,2,2,2,1,1,1
.db 1,1,1,1,2,2,2,3,3,4,5,6,6,7,8,10
.db 11,12,13,15,16,17,19,21,22,24,26,28,30,32,34,36
.db 38,40,43,45,47,50,52,55,57,60,63,65,68,71,74,77
.db 79,82,85,88,91,94,97,100,103,106,109,112,116,119,122,125
.db 0,0