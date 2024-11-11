;*******************
; Practica 5
;
; Created: 28/09/23
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


;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

ldi r16, $FF
out DDRC, r16 //configuramos el puerto c como salida (Display)

ldi r16, $0F
out DDRA, r16     //desde el A7,A4 son ed salida y de A3,A0 son de entrada

Revisar:
ldi R16, $F7 //sacamos un 0 en A3
out PORTA,r16
nop

//cbi PORTA,2  ya no es necesario ya que lo hicimos al inicio del codigo
sbis PINA, 7
rjmp ICHI
sbis PINA, 6
rjmp YON
sbis PINA, 5
rjmp NANA
sbis PINA, 4
rjmp H

sbi PORTA, 3
cbi PORTA,2
nop

sbis PINA, 7
rjmp NI
sbis PINA, 6
rjmp GO
sbis PINA, 5
rjmp HACHI
sbis PINA, 4
rjmp ZERO

sbi PORTA, 2
cbi PORTA,1
nop

sbis PINA, 7
rjmp SAN
sbis PINA, 6
rjmp ROKU
sbis PINA, 5
rjmp KYU
sbis PINA, 4
rjmp NEKO

sbi PORTA, 1
cbi PORTA,0
nop

sbis PINA, 7
rjmp A
sbis PINA, 6
rjmp B
sbis PINA, 5
rjmp C
sbis PINA, 4
rjmp D

rjmp Revisar

ICHI:
LDI R17, 0b0000_0110
com r17
out PORTC, R17

RCALL Retardo
while_1:
sbis PINA, 7
rjmp while_1

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar
//
NI:
LDI R17, 0b0101_1011
com r17
out PORTC, R17

RCALL Retardo
while_2:
sbis PINA, 7
rjmp while_2

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

SAN:
LDI R17, 0b0100_1111
com r17
out PORTC, R17

RCALL Retardo
while_3:
sbis PINA, 7
rjmp while_3

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

YON:
LDI R17, 0b0110_0110
com r17
out PORTC, R17

RCALL Retardo
while_4:
sbis PINA, 6
rjmp while_4

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar
//
GO:
LDI R17, 0b0110_1101
com r17
out PORTC, R17

RCALL Retardo
while_5:
sbis PINA, 6
rjmp while_5

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar
//
ROKU:
LDI R17, 0b0111_1101
com r17
out PORTC, R17

RCALL Retardo
while_6:
sbis PINA, 6
rjmp while_6

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

NANA:
LDI R17, 0b0000_0111
com r17
out PORTC, R17

RCALL Retardo
while_7:
sbis PINA, 5
rjmp while_7

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

HACHI:
 LDI R17, 0b0111_1111
 com r17
out PORTC, R17

RCALL Retardo
while_8:
sbis PINA, 5
rjmp while_8

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

KYU:
LDI R17, 0b0110_0111
com r17
out PORTC, R17

RCALL Retardo
while_9:
sbis PINA, 5
rjmp while_9

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

A:
LDI R17, $F7
com r17
out PORTC, R17

RCALL Retardo
while_A:
sbis PINA, 7
rjmp while_A

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar


B:
LDI R17, $FC
com r17
out PORTC, R17

RCALL Retardo
while_B:
sbis PINA, 6
rjmp while_B

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

C:
LDI R17, $39
com r17
out PORTC, R17

RCALL Retardo
while_C:
sbis PINA, 5
rjmp while_C

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

D:
LDI R17, $5E
com r17
out PORTC, R17

RCALL Retardo
while_D:
sbis PINA, 4
rjmp while_D

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

H:
LDI R17, $76
com r17
out PORTC, R17

RCALL Retardo
while_H:
sbis PINA, 4
rjmp while_H

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

NEKO:
LDI R17, $36
com r17
out PORTC, R17

RCALL Retardo
while_NEKO:
sbis PINA, 4
rjmp while_NEKO

rcall Retardo
ldi r17,$00
com r17
out PORTC, R17
rjmp Revisar

ZERO:
LDI R17, 0b0011_1111
com r17
out PORTC, R17

RCALL Retardo
while_ZERO:
sbis PINA, 4
rjmp while_ZERO

rcall Retardo
com r17
ldi r17,$00
out PORTC, R17
rjmp Revisar



	 Retardo:
	 ; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R19, $65
WGLOOP0:  ldi  R20, $A4
WGLOOP1:  dec  R20
          brne WGLOOP1
          dec  R19
          brne WGLOOP0
; ----------------------------- 
; delaying 3 cycles:
          ldi  R19, $01
WGLOOP2:  dec  R19
          brne WGLOOP2
; ----------------------------- 
; delaying 2 cycles:
          nop
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
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler