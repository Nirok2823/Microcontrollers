;*******************
; Practica 6
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
out DDRD, r16 //configuramos el puerto d como salida (Display)

ldi r16, $F0
out DDRA, r16     //desde el A7,A4 son de Entrada y de A3,A0 son de salida


ldi r16,$00
out PORTD,r16 //sacamos ceros iniciales 
ldi r17,$00
ldi r18,0

Revisar:
ldi R16, $7F //sacamos un 0 en A3 es igual a 0111_1111
out PORTA,r16
nop

//cbi PORTA,2  ya no es necesario ya que lo hicimos al inicio del codigo
sbis PINA, 3
rjmp ICHI
sbis PINA, 2
rjmp YON
sbis PINA, 1
rjmp NANA
sbis PINA, 0
rjmp H

sbi PORTA, 7
cbi PORTA,6
nop

sbis PINA, 3
rjmp NI
sbis PINA, 2
rjmp GO
sbis PINA, 1
rjmp HACHI
sbis PINA, 0
rjmp ZERO

sbi PORTA, 6
cbi PORTA,5
nop

sbis PINA, 3
rjmp SAN
sbis PINA, 2
rjmp ROKU
sbis PINA, 1
rjmp KYU
sbis PINA, 0
rjmp NEKO

sbi PORTA, 5
cbi PORTA,4
nop

sbis PINA, 3
rjmp A
sbis PINA, 2
rjmp B
sbis PINA, 1
rjmp C
sbis PINA, 0
rjmp D

out PORTD, r17
rjmp Revisar

ICHI:
rcall lslShift
LDI R18, $01
Or r17,r18
out PORTD, R17

RCALL Retardo
while_1:
sbis PINA, 3
rjmp while_1

rcall Retardo
rjmp Revisar
//
NI:
rcall lslShift
LDI R18, $02
Or r17,r18
out PORTD, R17

RCALL Retardo
while_2:
sbis PINA, 3
rjmp while_2

rcall Retardo
rjmp Revisar

SAN:
rcall lslShift
LDI R18, $03
Or r17,r18
out PORTD, R17

RCALL Retardo
while_3:
sbis PINA, 3
rjmp while_3

rcall Retardo
rjmp Revisar

YON:
rcall lslShift
LDI R18, $04
Or r17,r18
out PORTD, R17

RCALL Retardo
while_4:
sbis PINA, 2
rjmp while_4

rcall Retardo
rjmp Revisar
//
GO:
rcall lslShift
LDI R18, $05
Or r17,r18
out PORTD, R17

RCALL Retardo
while_5:
sbis PINA, 2
rjmp while_5

rcall Retardo
rjmp Revisar
//
ROKU:
rcall lslShift
LDI R18, $06
Or r17,r18
out PORTD, R17

RCALL Retardo
while_6:
sbis PINA, 2
rjmp while_6

rcall Retardo
rjmp Revisar

NANA:
rcall lslShift
LDI R18, $07
Or r17,r18
out PORTD, R17

RCALL Retardo
while_7:
sbis PINA, 1
rjmp while_7

rcall Retardo
rjmp Revisar

HACHI:
 rcall lslShift
LDI R18, $08
Or r17,r18
out PORTD, R17

RCALL Retardo
while_8:
sbis PINA, 1
rjmp while_8

rcall Retardo
rjmp Revisar


KYU:
rcall lslShift
LDI R18, $09
Or r17,r18
out PORTD, R17

RCALL Retardo
while_9:
sbis PINA, 1
rjmp while_9

rcall Retardo
rjmp Revisar


A:
rcall lslShift
LDI R18, $0A
Or r17,r18
out PORTD, R17

RCALL Retardo
while_A:
sbis PINA, 3
rjmp while_A

rcall Retardo
rjmp Revisar


B:
rcall lslShift
LDI R18, $0B
Or r17,r18
out PORTD, R17

RCALL Retardo
while_B:
sbis PINA, 2
rjmp while_B

rcall Retardo
rjmp Revisar
C:
rcall lslShift
LDI R18, $0C
Or r17,r18
out PORTD, R17

RCALL Retardo
while_C:
sbis PINA, 1
rjmp while_C

rcall Retardo
rjmp Revisar

D:
rcall lslShift
LDI R18, $0D
Or r17,r18
out PORTD, R17

RCALL Retardo
while_D:
sbis PINA, 0
rjmp while_D

rcall Retardo
rjmp Revisar

H:
rcall lslShift
LDI R18, $0E
Or r17,r18
out PORTD, R17

RCALL Retardo
while_H:
sbis PINA, 0
rjmp while_H

rcall Retardo
rjmp Revisar

NEKO:
rcall lslShift
LDI R18, $0F
Or r17,r18
out PORTD, R17

RCALL Retardo
while_NEKO:
sbis PINA, 0
rjmp while_NEKO

rcall Retardo
rjmp Revisar

ZERO:
rcall lslShift
LDI R18, $00
Or r17,r18
out PORTD, R17

RCALL Retardo
while_ZERO:
sbis PINA, 0
rjmp while_ZERO

rcall Retardo
rjmp Revisar


lslShift:
lsl r17
lsl r17
lsl r17
lsl r17
ret


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