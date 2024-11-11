;*******************
; Practica 8
;
; Created: 12/10/23
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

sei //Habilitar el uso de las interrupciones





;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

ldi r17, $00
Out ddrd, r17
ldi r17, $FF
out portd, r17
out DDRC, r17

ldi r16, 0b1110_0000 //setear las banderas de las interrupciones aun sin ocurrir
out GIFR, r16        //normal mente se setean las 3 banderas juntas. bits 7(I1),6(I0),5(I2)
                     // Siempre configurar con: 0b1110_0000   

ldi r16, 0b0000_0010  //Se usa para setear con que tipo de flanco se va a trabajar
out MCUCR, r16        // el bit 6 es I2, bits 0,1 son (I0) y bits 3 y 4 son (I1)
                      // 00=0v
					  // 01=Flancos tanto de subida como de bajada
					  // 10= Flancos de Bajada
					  // 11=Flancos de subida

ldi r16, 0b0100_0000   //Regristro para habilitar las Interrupciones
out GICR, r16          //Bit 7= (I1)
                       //Bit 6= (I2)
					   //Bit 5= (I0)

ldi r16, $00
out PORTC, r16

ldi r30, $01
ldi r31, $F0
ldi r29, $10

Counter:
RCALL Delay_1s

sbrc r30, 0
rjmp Common_case

sbrc r30, 1
rjmp Common_case

sbrc r30, 2
rjmp Ten_23

rjmp Counter

Common_case:
RCALL Verify
out portc, r16
rjmp Counter

Ten_23:
RCALL Verify
cpi r16, $24
breq reseti
out portc, r16
rjmp Counter


Verify:
mov r26, r16
lsl r26
lsl r26
lsl r26
lsl r26
cpi r26, $90
breq Limit
Case_nL:
inc r16
ret

Case_L:
ret

Limit:
lsl r30
AND r16, r31
ADD r16, r29
rjmp Case_L

 reseti: 
 ldi r16, 0
 ldi r30,1
 out portc, r16
 rjmp Counter
; inicia el programa 

 


 Delay_1s:
; ============================= 
;    delay loop generator 
;     1000000 cycles:
; ----------------------------- 
; delaying 999999 cycles:
          ldi  R17, $09
WGLOOP0:  ldi  R18, $BC
WGLOOP1:  ldi  R19, $C4
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

	 
	 Delay_button:
	 ; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R21, $65
WGLOOP00:  ldi  R20, $A4
WGLOOP11:  dec  R20
          brne WGLOOP11
          dec  R21
          brne WGLOOP00
; ----------------------------- 
; delaying 3 cycles:
          ldi  R21, $01
WGLOOP22:  dec  R21
          brne WGLOOP22
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

in r25, SREG //Se realiza un respaldo de las banderas, copiando el sreg 
push r25     //Se manda lo del registro a una pila del micro

ldi r26, $99
out PORTC, r26

rcall Delay_button
while:
sbis PIND, 2
rjmp while
rcall Delay_button

 pop r25			//Se saca de la pila las banderas del SREG
 out SREG, r25		//Mandamos al SREG las banderas de respaldo
 out portc, r16		
  reti				//Nota, Siempre usar reti

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