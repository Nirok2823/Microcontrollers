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

ldi r16, $FF
out DDRD, r16 //configuramos el puerto d como salida (Display)

ldi r16, $F0
out DDRA, r16     //desde el A7,A4 son de salida y de A3,A0 son de entrada


ldi r16,$00
out PORTD,r16 //sacamos ceros iniciales 
ldi r17,$00 //contador
ldi r18,$00 // tecla pulsada
ldi r30,$00 //contador si fue correcto o no
;ldi r31,$00
ldi r25, $00 ; registro bandera bandera

Candado_cerrado:
ldi r25,$00
sbi PORTD,7
cbi PORTD,0
RCall Status
ldi R16, $7F //sacamos un 0 en A3 es igual a 0111_1111
out PORTA,r16
nop

call buttons
rjmp Candado_Cerrado

Counter_Case:
cpi r17,$00
breq D1
cpi r17,$01
breq D2
cpi r17,$02
breq D3
cpi r17,$03
breq D4

D1:
cpi r18, $01
breq D1_C
brne D1_I

D1_C:
inc r30
inc r17
rjmp Candado_Cerrado

D1_I:
inc r17
rjmp Candado_Cerrado
//
D2:
cpi r18, $05
breq D2_C
brne D2_I

D2_C:
inc r30
inc r17
rjmp Candado_Cerrado

D2_I:
inc r17
rjmp Candado_Cerrado
//
D3:
cpi r18, $07
breq D3_C
brne D3_I

D3_C:
inc r30
inc r17
rjmp Candado_Cerrado

D3_I:
inc r17
rjmp Candado_Cerrado
//
D4:
cpi r18, $09
breq D4_C
brne D4_I

D4_C:
inc r30
inc r17
rjmp Candado_Cerrado

D4_I:
inc r17
rjmp Candado_Cerrado

Check_Secuence:
ldi r17, $00
cpi r30, $04
ldi r30, $00
breq Candado_Abierto
rjmp Alarm_On

Status:
cpi r17, $04
breq Check_Secuence
ret

Candado_Abierto:
ldi r25,2
cbi PORTD,7
ldi r30, $00
ldi R16, $7F //sacamos un 0 en A3 es igual a 0111_1111
out PORTA,r16
nop
call buttons
rjmp Candado_Abierto

change:
ldi r17,$00
jmp Candado_cerrado

Alarm_On:
ldi r25,4

sbi PORTD,0
cpi r17, $02
breq change
ldi R16, $7F //sacamos un 0 en A3 es igual a 0111_1111
out PORTA,r16
nop
call buttons

rjmp Alarm_On

case2:
cpi r17,$01
breq Alarm_On
inc r17
rjmp Alarm_On

case3:
cpi r17,$01
breq case3_1

ldi r17,$00
rjmp Alarm_On

case3_1:
inc r17
ldi r18, $00
ldi r30, $00
jmp Alarm_On

caseD:
ldi r17,$00
rjmp Alarm_On

ICHI:
LDI R18, $01
RCALL Retardo
while_1:
sbis PINA, 3
rjmp while_1
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case
//
NI:
LDI R18, $02
RCALL Retardo
while_2:
sbis PINA, 3
rjmp while_2
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp case2
rjmp Counter_case

SAN:
LDI R18, $03
RCALL Retardo
while_3:
sbis PINA, 3
rjmp while_3
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp case3
rjmp Counter_case

YON:
LDI R18, $04
RCALL Retardo
while_4:
sbis PINA, 2
rjmp while_4
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case
//
GO:
LDI R18, $05
RCALL Retardo
while_5:
sbis PINA, 2
rjmp while_5
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case
//
ROKU:
LDI R18, $06
RCALL Retardo
while_6:
sbis PINA, 2
rjmp while_6
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

NANA:
LDI R18, $07
RCALL Retardo
while_7:
sbis PINA, 1
rjmp while_7
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

HACHI:
LDI R18, $08
RCALL Retardo
while_8:
sbis PINA, 1
rjmp while_8
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case
//
KYU:
LDI R18, $09
RCALL Retardo
while_9:
sbis PINA, 1
rjmp while_9
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case
//
A:
LDI R18, $0A
RCALL Retardo
while_A:
sbis PINA, 3
rjmp while_A
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case


B:
LDI R18, $0B
RCALL Retardo
while_B:
sbis PINA, 2
rjmp while_B
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

C:
LDI R18, $0C
RCALL Retardo
while_C:
sbis PINA, 1
rjmp while_C
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

D:
LDI R18, $0D
RCALL Retardo
while_D:
sbis PINA, 0
rjmp while_D
rcall Retardo
sbrc r25,2
jmp caseD
ldi r17,$00
ldi r30,$00
rjmp Candado_cerrado


H:
LDI R18, $0E
RCALL Retardo
while_H:
sbis PINA, 0
rjmp while_H
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

NEKO:
LDI R18, $0F
RCALL Retardo
while_NEKO:
sbis PINA, 0
rjmp while_NEKO
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

ZERO:
LDI R18, $00
RCALL Retardo
while_ZERO:
sbis PINA, 0
rjmp while_ZERO
rcall Retardo
sbrc r25,1
rjmp Candado_cerrado
sbrc r25,2
jmp caseD
rjmp Counter_case

buttons:
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