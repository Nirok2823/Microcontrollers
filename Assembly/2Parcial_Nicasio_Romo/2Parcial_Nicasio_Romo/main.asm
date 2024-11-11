;*******************
; Practica 7
;
; Created: 10/10/23
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

ldi r16, $0F // Se configuran como entradas D4-D7 y salidas D0-D3
out DDRD, r16

ldi r16,$FF

out DDRA, r16 //Se configuran como puertos de salida A,B,C
out DDRB, r16
out DDRC, r16

ldi r20, $01 //operando 1 r bandera
ldi r21, $00// registro signo
ldi r18,$00 //Boton pulsado
ldi r17, $00 //registro Original

ldi r16,$00
out PORTA,r16
out PORTB,r16
out PORTC,r16

ldi r28,$F0 //aux2
ldi r26,$0F// aux1
ldi r22,$10// aux1
ldi r23,$00

Inicio:
sbrc r20, 1
rjmp Signo

sbrc r20,3
rjmp Operacion

rcall Tecaldo_N

rjmp Inicio

Signo:
Rcall Teclado_S
rjmp Signo

Teclado_S:
ldi r16, 0b1111_0111
out PORTD, r16 
nop

sbis PIND, 5
rjmp Multiplicacion
sbis PIND, 6
rjmp Resta
sbis PIND, 7
rjmp Suma

sbi PORTD,3
cbi PORTD,0

sbis PIND, 7
Rjmp Reinicio

ret


Multiplicacion:
RCALL Retardo
while_M:
sbis PIND, 5
rjmp while_M
rcall Retardo

ldi r21, 0b0000_0001
ldi r25, 0b1110_1100
out PortB,r25
lsl r20
rjmp Inicio

Resta:
RCALL Retardo
while_R:
sbis PIND, 6
rjmp while_R
rcall Retardo

ldi r21, 0b0000_0010
ldi r25, 0b1000_0000
out PortB,r25
lsl r20
rjmp Inicio

Suma:
RCALL Retardo
while_S:
sbis PIND, 7
rjmp while_S
rcall Retardo

ldi r21, 0b0000_0100
ldi r25, 0b1000_1100
out PortB,r25
lsl r20
rjmp Inicio



Tecaldo_N:
ldi r16, 0b1111_1011
out PORTD, r16 // tenemos 1111_1011
nop

sbis PIND, 4
rjmp Nueve
sbis PIND, 5
rjmp Seis
sbis PIND, 6
rjmp Tres


sbi PORTD, 2
cbi PORTD,1
nop

sbis PIND, 4
rjmp Ocho
sbis PIND, 5
rjmp Cinco
sbis PIND, 6
rjmp Dos
sbis PIND, 7
rjmp Zero

sbi PORTD, 1
cbi PORTD,0
nop

sbis PIND, 4
rjmp Siete
sbis PIND, 5
rjmp Cuatro
sbis PIND, 6
rjmp Uno
sbis PIND, 7
rjmp Reinicio

ret


Uno:
LDI R18, $01
RCALL Retardo
while_1:
sbis PIND, 6
rjmp while_1
rcall Retardo

sbrc r20,0
Rcall Operando_1

sbrc r20,2
Rcall Operando_2

lsl r20
rjmp Inicio
//

Dos:
LDI R18, $02
RCALL Retardo
while_2:
sbis PIND, 6
rjmp while_2
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio

Tres:
LDI R18, $03
RCALL Retardo
while_3:
sbis PIND, 6
rjmp while_3
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio

Cuatro:
LDI R18, $04
RCALL Retardo
while_4:
sbis PIND, 5
rjmp while_4
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio
//
Cinco:
LDI R18, $05
RCALL Retardo
while_5:
sbis PIND, 5
rjmp while_5
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio
//
Seis:
LDI R18, $06
RCALL Retardo
while_6:
sbis PIND, 5
rjmp while_6
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio

Siete:
LDI R18, $07
RCALL Retardo
while_7:
sbis PIND, 1
rjmp while_7
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio

Ocho:
LDI R18, $08

RCALL Retardo
while_8:
sbis PIND, 4
rjmp while_8
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio
//
Nueve:
LDI R18, $09


RCALL Retardo

while_9:
sbis PIND, 7
rjmp while_9
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio


ZERO:
LDI R18, $00

RCALL Retardo
while_ZERO:
sbis PIND, 7
rjmp while_ZERO
rcall Retardo
sbrc r20,0
Rcall Operando_1
sbrc r20,2
Rcall Operando_2
lsl r20
rjmp Inicio

Reinicio:
RCALL Retardo
while_Reinicio:
sbis PIND, 7
rjmp while_Reinicio
rcall Retardo
ldi r20, $01
ldi r17,$00
ldi r25,$00
ldi r19,$00
ldi r23,$00
out PORTA,r17
out PORTB,r17
out PORTC,r17
jmp Inicio





Operando_1:
lsl r18
lsl r18
lsl r18
lsl r18
mov r17,r18
out PortA,r17
ret

Operando_2:
Or r17,r18
out PortA,r17
ret

Operacion: 
Rcall Operandos
sbrc r21,0 //Multiplicacion
Rjmp OMul
sbrc r21,1 // Resta
Rjmp ORes
sbrc r21,2 // Suma
rjmp OSum

OSum:
ADD r19,r27
cpi r19,$0A
brsh Higher
rjmp Last

ORes:
cp r27,r19
brlt Less
Sub r27,r19
mov r19,r27
rjmp Last

OMul:
mul r19,r27
mov r19,r0
cpi r19, 10
brsh Big
rjmp Last


Last:
swap r19
out PortC,r19
Rcall Delay_2s
ldi r20, $01
ldi r17,$00
ldi r25,$00
ldi r19,$00
ldi r23,$00
out PORTA,r17
out PORTB,r17
out PORTC,r17
jmp Inicio

Higher:
Subi r19,$0A
Add r19, r22
rjmp Last

Less:
Sub r19,r27
rjmp Last

Big:
subi r19, $0A
Add r23, r22
cpi r19, $0A
brsh Big
OR r19,r23
rjmp Last



Operandos:
mov r19,r17
mov r27,r17

And r19, r26

And r27, r28
ror r27
ror r27
ror r27
ror r27
ret


Retardo:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R29, $65
WGLOOP0:  ldi  R30, $A4
WGLOOP1:  dec  R30
          brne WGLOOP1
          dec  R29
          brne WGLOOP0
; ----------------------------- 
; delaying 3 cycles:
          ldi  R29, $01
WGLOOP2:  dec  R29
          brne WGLOOP2
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
	ret


	Delay_2s:
	; ============================= 
;    delay loop generator 
;     2000000 cycles:
; ----------------------------- 
; delaying 1999998 cycles:
          ldi  R29, $12
WGLOOP5:  ldi  R30, $BC
WGLOOP4:  ldi  R31, $C4
WGLOOP3:  dec  R31
          brne WGLOOP3
          dec  R30
          brne WGLOOP4
          dec  R29
          brne WGLOOP5
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