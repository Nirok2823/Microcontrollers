;*******************
; Practica 10_musica
;
; Created: 31/10/23
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
sei

ldi r16, $00
out DDRA, r16 // se configuran los puertos de entrada A y B
out DDRB, r16
//solo el puerto b lleva pull ups

ldi r16, $FF
out DDRC, r16 //se configura el puerto c como salida (diaplays)

out PORTB,r16 //Activamos pull ups en el puerto b (Boton) 
out PORTA,r16

ldi r16, $00
out PortC,r16 //Sacamos Ceros Iniciales en los dispalys


out TCNT0,r16 //Se limpia el contador

ldi r16, 0b0000_1011 // se configura el timer en cnt y un prescaler de 64
out TCCR0, r16

ldi r16, 124      
out OCR0, r16 // Valor del OCR para que cuente cada 1 milisegundo

ldi r16, 0b0000_0011
out TIFR, r16

ldi r16, 0b0000_0000  
out TIMSK, r16 

ldi r21, $02
//out TIMSK, r21 todavia no queremos activarlo
ldi r22,$00 
ldi r24,$00 //Counter Entrada
ldi r26, $00 //Counter Timer

ldi r23,$00 //decenas
ldi r31,$00
ldi r30,$10
ldi r26,$00
//r16 sera igual a mi registro timer
// r26 sera igual a mi registro contador
;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

Main:
sbis PINB, 0

rjmp Check

rjmp Main


Check:
sbic PINA,0
rjmp Highh
rjmp Loww

Loww:
sbic PINA,0 //Sigue en Bajo?
rjmp Counter_L
rjmp Loww

Highh:
sbis PINA,0 //Sigue en alto?
rjmp Counter_H
rjmp Highh

Counter_H:
out TIMSK, r21 //Empiezo a contar
inc r24
cpi r24, 2
breq Stop

Verf:
sbis PinA,0
rjmp Verf
rjmp Highh


Counter_L:
out TIMSK, r21 //Empiezo a contar
inc r24
cpi r24, 2
breq Stop

VerfL:
sbic PinA,0
rjmp VerfL
rjmp Loww

Stop:
out TIMSK, r22 //Detengo el Contador 
cpi r26, 52
brsh Limit
cpi r26, 10
brsh Big
rjmp Last

Limit:
ldi r26,$FF
rjmp Last

Big:
subi r26, $0A
Add r23, r30
cpi r26, $0A
brsh Big
OR r26,r23
rjmp Last

Last:
ldi r24,$00 //reinicio el Counter del la entrada
mov r31,r26
ldi r26,$00
ldi r23,$00
subi r31,$01
out PORTC, r31
rcall Delay_B
While:
Sbis PINB, 0
rjmp while
rcall Delay_B
rjmp Main

Delay_B:
; ============================= 
;    delay loop generator 
;     400000 cycles:
; ----------------------------- 
; delaying 399999 cycles:
          ldi  R17, $97
WGLOOP0:  ldi  R18, $06
WGLOOP1:  ldi  R19, $92
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret




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
in r25, SREG
push r25

inc r26
 
 pop r25
 out SREG, r25 
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler

