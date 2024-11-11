;*******************
; Practica 4
;
; Created: 26/09/23
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

ldi R16, 0
out DDRA, R16         ;configuro a A de entrada
ldi R16, $FF
out PORTA, R16        ;A con pull ups

ldi R16, $FF  /*configuramos el puerto c como salidas*/
out DDRC, R16
/*ldi R16, 0
out PORTC, R16 */ /*opcional ya que no es necesario sacar nada*/
/*aqui empieza nuestro loop*/
LDI R16, 0b0000_0000 /*Sacamos en el display un cero*/
out PORTC, R16
LDI R17, $00
ldi r18, $10
ldi r21, $01
ldi r30, $04
ldi r31, $F0
ldi r22, $0F

Check_buttons:
	sbis PINA,0
	rjmp Btn1_Reset
	sbis PINA,2
	rjmp Btn1_Add;Se ejecuta cuado esta presionado
	sbis PINA,4
	rjmp Btn2_Reset
	sbis PINA,6
	rjmp Btn2_Add

	rjmp Check_buttons
/*funcion sumadora*/

	Btn1_Add:	                      
	ADD r17,r18
	out PORTC, r17
	rcall Retardo
	rcall while_Btn1_Add      ;Se ejecuta primero el retardo en conjunto con la verificacion de si aun sigue presionado
	rcall Retardo
	rjmp Check_buttons


	Btn2_Add:
	rcall Retardo
	rcall while_Btn2_Add     ;Se ejecuta primero el retardo en conjunto con la verificacion de si aun sigue presionado
	rcall Retardo
                             ;Ejecuta la instruccion hasta que se suelta el boton o el boton deja de ser 1
	MOV r16,r17
	rcall LShift
	cpi r16, $F0
	breq Mini_Reset
	ADD r17,r21
	out PORTC, r17
	rjmp Check_buttons


	Btn1_Reset:
	AND r17,r22
	out PORTC,r17
	rcall Retardo
	rcall while_Btn1_Reset      ;Se ejecuta primero el retardo en conjunto con la verificacion de si aun sigue presionado
	rcall Retardo
	rjmp Check_buttons


	Btn2_Reset:
	rcall Retardo
	rcall while_Btn2_Reset      ;Se ejecuta primero el retardo en conjunto con la verificacion de si aun sigue presionado
	rcall Retardo
	AND r17,r31
	out PORTC,r17
	rjmp Check_buttons

	 while_Btn1_Reset:
	 sbis PINA,0
	 rjmp while_Btn1_Reset
	 ret

	 while_Btn1_Add:
	 sbis PINA,2
	 rjmp while_Btn1_Add
	 ret

	 while_Btn2_Add:
	 sbis PINA,6
	 rjmp while_Btn2_Add
	 ret

	 while_Btn2_Reset:
	 sbis PINA,4
	 rjmp while_Btn2_Reset
	 ret

	 LShift:
	 Dec r30
	 LSL r16
	 cpi r30, $00
	 brne LShift
	 ldi r30, $04
	 ret

	 Mini_Reset:
	 AND r17,r16
	 out PORTC, r17
	 rjmp Check_buttons


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