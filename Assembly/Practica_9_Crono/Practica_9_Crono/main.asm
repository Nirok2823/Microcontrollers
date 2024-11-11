;*******************
; Practica 9-Crono
;
; Created: 19/10/23
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
out DDRA, r16 //se configura como entrada el puerto A

ldi r16, $FF
out DDRC, r16 // se configuran los puertos de salida a C y D
out DDRD, r16

out PORTA, r16

ldi r16, $00
out PortC,r16
out PortD,r16

out TCNT0,r16

ldi r16, 0b0000_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16

ldi r16, 195
out OCR0, r16

ldi r16, 0b0000_0011
out TIFR, r16

ldi r16, 0b0000_0000
out TIMSK, r16 

ldi r16, $00
ldi r26, $00 // Segundero 
ldi r30, $00 //minutero 
ldi r31, $F0 
ldi r29, $10
ldi r21, $02
ldi r22, $00

//r16 sera igual a mi registro timer
// r26 sera igual a mi registro contador
;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************


Counter:
rcall Check
sbis PINA, 0 //Checa el boton de Inicio
rjmp Inicio

Sbis PINA, 7
rjmp Limpiar


rjmp Counter

Inicio:
rcall Reseti
out TIMSK, r21 //Activa el Timer
rcall Delay_Button
while:
sbis PINA, 0
rjmp while
rcall Delay_Button
rjmp Counter

Limpiar:
rcall Reseti
out TIMSK, r22
rcall Delay_Button
while2:
sbis PINA, 7
rjmp while2
rcall Delay_Button
rjmp Counter


Delay_Button:
; ============================= 
;    delay loop generator 
;     200000 cycles:
; ----------------------------- 
; delaying 199998 cycles:
          ldi  R17, $06
WGLOOP0:  ldi  R18, $37
WGLOOP1:  ldi  R19, $C9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 

ret
Reseti:
ldi r30, $00
ldi r26, $00
ldi r16, $00
out portD, r26
out portC,r30
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

cpi r16, 15
breq Inc_Counter
 inc r16

 True:
 pop r25
 out SREG, r25 
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler

Inc_Counter:
RCALL Verify
clr r16
out portD, r26
out portC,r30
rjmp True

Verify:
cpi r26, $59
breq Inc_Min
mov r27, r26
lsl r27
lsl r27
lsl r27
lsl r27
cpi r27, $90
breq Limit

inc r26
ret

Limit:
AND r26, r31
ADD r26, r29
ret

Inc_Min:
ldi r26, 0
inc r30
ret

Check:
cpi r30, 2
breq Change
ret

Change:
cpi r26, $59
breq Reset_L
ret

Reset_L:
out TIMSK, r22
ret





