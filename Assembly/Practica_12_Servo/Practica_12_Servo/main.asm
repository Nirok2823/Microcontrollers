;*******************
; Practica 12 Servo
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
//no se usa el sei 

;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

/*LDI r16,0
 out DDRA, r16
 ldi r16, $FF
 out PortA, r16*/ //no tenemos que usar puertos de entrada ni nada

 ldi r16, $FF
 out DDRB,r16

 ldi r16, $00
 out TCNT0, r16

 //configurar el timer 0
 ldi r16, 0
 out OCR0, r16
 ldi r16, 0b0110_1100
 out TCCR0, r16

 ldi r16, 5 // Valor inicial del ocr0 representa el valor del ocr0
 out OCR0, r16
 ldi r30, 1// bandera


 Main:
 cpi r16, 20
 breq Limit
 cpi r16, 4
 breq Limit2

 rcall Delay

 sbrc r30, 0
 inc r16

 sbrc r30, 1
 dec r16

 out OCR0,r16
 rjmp Main

 Limit:
 lsl r30
 dec r16
 rjmp Main

 Limit2:
 inc r16
 lsr r30
 Rjmp Main


	 Delay:
; ============================= 
;    delay loop generator 
;     4000000 cycles:
; ----------------------------- 
; delaying 3999996 cycles:
          ldi  R17, $24
WGLOOP0:  ldi  R18, $BC
WGLOOP1:  ldi  R19, $C4
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 3 cycles:
          ldi  R17, $01
WGLOOP3:  dec  R17
          brne WGLOOP3
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
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler