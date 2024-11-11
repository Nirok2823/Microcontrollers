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

ldi r16, $FF
out DDRB, r16 // se configuran los puertos de salida a C y D




ldi r16, $00
out PortB,r16


out TCNT0,r16 //Se limpia el contador

ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16

ldi r16, 31
out OCR0, r16

ldi r16, 0b0000_0011
out TIFR, r16

ldi r16, 0b0000_0000
out TIMSK, r16 

ldi r21, $02
out TIMSK, r21

ldi r22,$00 //compases
ldi r23,$00 //compases
ldi r24,$00
ldi r31,$00
ldi r30,$00

//r16 sera igual a mi registro timer
// r26 sera igual a mi registro contador
;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************

IntroCS1: //cant stop

cpi r30, 5
breq IntroCS2

rcall D3
rcall E3

rcall D3
rcall E3

rcall D3
rcall E3

rcall D3
rcall E3

rcall D3
rcall E3s

rcall SilCor
inc r30
rjmp IntroCS1

IntroCS2:
cpi r31, 2
breq Reposo

rcall E3s
rcall E3s
rcall D4
rcall SilsCor
rcall E42
rcall E3s
rcall E3s
rcall E3s
rcall D4
rcall SilsCor
rcall E42

rcall E3s
rcall E3s
rcall E3s

rcall D3c
rcall D4
rcall SilsCor
rcall E42
rcall D3
rcall D3
rcall D3
rcall D4
rcall SilsCor
rcall E42

rcall D3
rcall D3
rcall D3

rcall B2c
rcall D4
rcall SilsCor
rcall E42
rcall B2
rcall B2
rcall B2
rcall D4
rcall SilsCor
rcall E42

rcall B2
rcall B2
rcall B2

rcall C3c
rcall D4
rcall SilsCor
rcall E42
rcall C3
rcall C3
rcall C3
rcall D4
rcall SilsCor
rcall E42

rcall C3
rcall C3
rcall C2_Scorchea

inc r31
rjmp IntroCS2


Reposo:
rcall Cambio
rjmp IntroP1


IntroP1: //Thunderstroke
cpi r24,2
breq IntroP2

ldi r23,0
cpi r22,8
breq IntroP1_2


rcall Eb4
rcall B3
rcall Gb4
rcall B3
inc r22
rjmp IntroP1

IntroP1_2:
cpi r23,8
breq Repetition_Bar

ldi r22,0

rcall E4
rcall B3
rcall G4
rcall B3
inc r23
rjmp IntroP1_2

IntroP2:
rcall B4
rcall B3

rcall A4
rcall B3

rcall Ab4
rcall B3

rcall A4
rcall B3

rcall Ab4
rcall B3

rcall Gb4
rcall B3

rcall Ab4
rcall B3

rcall E4
rcall B3

rcall Gb4
rcall B3

rcall Eb4
rcall B3
rcall E4
rcall B3

rcall Eb4
rcall B3
rcall E4
rcall B3

rcall Eb4
rcall B3
rcall E4
rcall B3

rcall Eb4
rcall B3

rjmp IntroP2

Repetition_Bar:
inc r24
rjmp IntroP1


B2:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 62
out OCR0, r16

rcall C2_Scorchea

ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
rcall Retardo

ret

B2c:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 62
out OCR0, r16

rcall C2_corchea
ret

C3:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 59
out OCR0, r16

rcall C2_Scorchea

ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
rcall Retardo

ret

C3c:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 59
out OCR0, r16

rcall C2_corchea
ret

D3:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 52
out OCR0, r16

rcall C2_Scorchea

ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
rcall Retardo

ret

D3c:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 52
out OCR0, r16

rcall C2_corchea
ret



E3:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 46
out OCR0, r16

rcall C2_corchea
ret

E3s:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16

ldi r16, 46
out OCR0, r16

rcall C2_Scorchea

ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
rcall Retardo
ret


D4:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 25
out OCR0, r16

rcall C2_Scorchea
ret

E42:
ldi r16, 23
out OCR0, r16

rcall C2_corchea
ret

SilCor:
ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16

rcall C2_corchea

ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ret


SilsCor:
ldi r16, 0b0010_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16

rcall C2_Scorchea

ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ret



B3:

ldi r16, 31
out OCR0, r16

rcall Delay_2s
ret

Eb4:
ldi r16, 0b0001_1101 // se configura el timer en cnt y un prescaler de 1024
out TCCR0, r16
ldi r16, 24
out OCR0, r16

rcall Delay_2s
ret

E4:
ldi r16, 23
out OCR0, r16

rcall Delay_2s
ret

Gb4:
ldi r16, 20
out OCR0, r16

rcall Delay_2s

ret

G4:
ldi r16, 19
out OCR0, r16

rcall Delay_2s
ret

Ab4:
ldi r16, 18
out OCR0, r16

rcall Delay_2s
ret

A4:
ldi r16, 17
out OCR0, r16

rcall Delay_2s
ret

B4:
ldi r16, 15
out OCR0, r16

rcall Delay_2s
ret


Delay_2s:
; ============================= 
;    delay loop generator 
;     900000 cycles:
; ----------------------------- 
; delaying 899937 cycles:
          ldi  R17, $09
WGLOOP0:  ldi  R18, $A5
WGLOOP1:  ldi  R19, $C9
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 63 cycles:
          ldi  R17, $15
WGLOOP3:  dec  R17
          brne WGLOOP3
; ============================= 
ret

C2_corchea:
; ============================= 
;    delay loop generator 
;     2666667 cycles:
; ----------------------------- 
; delaying 2666664 cycles:
          ldi  R17, $18
WGLOOP00:  ldi  R18, $BC
WGLOOP10:  ldi  R19, $C4
WGLOOP20:  dec  R19
          brne WGLOOP20
          dec  R18
          brne WGLOOP10
          dec  R17
          brne WGLOOP00
; ----------------------------- 
; delaying 3 cycles:
          ldi  R17, $01
WGLOOP30:  dec  R17
          brne WGLOOP30
; ============================= 
ret

C2_Scorchea:
; ============================= 
;    delay loop generator 
;     1333333 cycles:
; ----------------------------- 
; delaying 1333332 cycles:
          ldi  R17, $0C
WGLOOP01:  ldi  R18, $BC
WGLOOP11:  ldi  R19, $C4
WGLOOP21:  dec  R19
          brne WGLOOP21
          dec  R18
          brne WGLOOP11
          dec  R17
          brne WGLOOP01
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 

ret

	 Retardo:
; ============================= 
;    delay loop generator 
;     80000 cycles:
; ----------------------------- 
; delaying 79998 cycles:
          ldi  R17, $86
WGLOOP02:  ldi  R18, $C6
WGLOOP12:  dec  R18
          brne WGLOOP12
          dec  R17
          brne WGLOOP02
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 

	ret

	Cambio:
	; ============================= 
;    delay loop generator 
;     40000000 cycles:
; ----------------------------- 
; delaying 39998607 cycles:
          ldi  R17, $FB
WGLOOP03:  ldi  R18, $E3
WGLOOP13:  ldi  R19, $E9
WGLOOP23:  dec  R19
          brne WGLOOP23
          dec  R18
          brne WGLOOP13
          dec  R17
          brne WGLOOP03
; ----------------------------- 
; delaying 1392 cycles:
          ldi  R17, $02
WGLOOP33:  ldi  R18, $E7
WGLOOP43:  dec  R18
          brne WGLOOP43
          dec  R17
          brne WGLOOP33
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


 True:
 pop r25
 out SREG, r25 
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler






