;*******************
; Practica 14 LCD
;
; Created: 21/10/23
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

rcall INI_LCD
ldi VAR, 0b1000_0000
Rcall WR_INS ;Posicion 0x00






Start: 
ldi zh, High(Tabla*2)
ldi zl, Low(Tabla*2)
lpm
mov VAR, r0
rcall WR_DAT

Read:
cpi zl,0
breq Operate

cpi zl, $FF
breq Limit

inc zl

Operate:
lpm
mov VAR, r0
cpi VAR,'H'
breq nada

rcall WR_DAT

rjmp Read




Limit:
ldi zl,0
inc zh
rjmp Operate

nada:
rjmp nada


;********************************
;ESTA LIBRERA SE UTILIZA PARA EL LCD
;Esta libreria funciona a una frecuencia de ???????
;FUNCIONES:
;   - INI_LCD sirve para inicializar el LCD
;   - WR_INS para escribir una instruccion en el LCD.  Antes debe de cargarse en VAR la instrucción a escribir
;   - WR_DAT para escribir un dato en el LCD.  Antes debe de cargarse en VAR el dato a escribir
;REGISTROS
;   - Se emplea el registro R16, R17 y R18
;PUERTOS
;   - Se emplea el puerto D (pines 5 6 y 7 para RS, RW y E respectivamente)
;   - Se emplea el puerto C para la conexión a D0..D7
;   - Estos puertos pueden modificarse en la definición de variables
;****************************************
;Definición de variables
.def VAR3 = r17
.def VAR2=r18
.def VAR= r16
.equ LCD_DAT=DDRC
.equ PORT_DAT=PORTC
.equ PIN_DAT=PINC
.equ LCD_CTR=DDRD 
.equ PORT_CTR=PORTD
.equ RS= PD5
.equ RW= PD6
.equ E=  PD7
.equ PIN_RS=5
.equ PIN_RW=6
.equ PIN_E=7

;****************************************
INI_LCD:	
	rcall DECLARA_PUERTOS
        rcall T0_15m			 
	ldi VAR,0b00111000		;Function Set - Inicializa el LCD
	rcall WR_INS_INI		
	rcall T0_4m1
	ldi VAR,0b00111000		;Function Set - Inicializa elLCD
	rcall WR_INS_INI		
	rcall T0_100u			
	ldi VAR,0b00111000		;Function Set - Inicializa elLCD
	rcall WR_INS_INI		
	rcall T0_100u			
	ldi VAR,0b00111000		;Function Set - Define 2 líneas, 5x8 char font
	rcall WR_INS_INI		
	rcall T0_100u
	ldi VAR, 0b00001000		;Apaga el display
	rcall WR_INS
	ldi VAR, 0b00000001		;Limpia el display
        rcall WR_INS
	ldi VAR, 0b00000110		;Entry Mode Set - Display clear, increment, without display shift
	rcall WR_INS		
	ldi VAR, 0b00001100		;Enciende el display
        rcall WR_INS		
ret
;****************************************
WR_INS: 
	rcall WR_INS_INI
	rcall CHK_FLG			;Espera hasta que la bandera del LCD responde que ya terminó
ret
;****************************************
WR_DAT:			
	out PORT_DAT,VAR 
	sbi PORT_CTR,PIN_RS		;Modo datos
	cbi PORT_CTR,PIN_RW		;Modo escritura
	sbi PORT_CTR,PIN_E		;Habilita E
	rcall T0_10m
	cbi PORT_CTR,PIN_E		;Quita E, regresa a modo normal
	rcall CHK_FLG			;Espera hasta que la bandera del LCD indica que terminó
ret
;****************************************
WR_INS_INI: 
	out PORT_DAT,VAR 
	cbi PORT_CTR,PIN_RS		;Modo instrucciones
	cbi PORT_CTR,PIN_RW		;Modo escritura
   	sbi PORT_CTR,PIN_E		;Habilita E
	rcall T0_10m			
	cbi PORT_CTR,PIN_E		;Quita E, regresa a modo normal
ret
;****************************************
DECLARA_PUERTOS:
	ldi VAR, 0xFF
	out LCD_DAT, VAR		; El puerto donde están conectados D0..D7 se habilita como salida
	out LCD_CTR, VAR		; Todo el puerto en donde estén conectados RS,RW y E se habilita como salida
ret	
;****************************************
CHK_FLG: 
	ldi VAR, 0x00		
	out LCD_DAT, VAR		;Establece el puerto de datos como entrada para poder leer la bandera
	cbi PORT_CTR, PIN_RS		;Modo instrucciones
	sbi PORT_CTR, PIN_RW		;Modo lectura
	RBF:
		sbi PORT_CTR, PIN_E 	;Habilita E
		rcall T0_10m
		cbi PORT_CTR, PIN_E	;Quita E, regresa a modo normal
	   	sbic PIN_DAT, 7		
		;sbis o sbic cambian según se trate de la vida real o de poteus
	   	rjmp RBF		;Repite el ciclo hasta que la bandera de ocupado(pin7)=1
	CONTINUA:	
	cbi PORT_CTR, PIN_RS		;Limpia RS
	cbi PORT_CTR, PIN_RW		;Limpia RW
		
 	ldi VAR, 0xFF   	
	out LCD_DAT, VAR		;Regresa el puerto de datos a su configuración como puerto de salida
ret
;****************************************
T0_15m:
; ============================= 
;    delay loop generator 
;     15000 cycles:
; ----------------------------- 
; delaying 14994 cycles:
          ldi  R20, $15
WGLOOP0:  ldi  R21, $ED
WGLOOP1:  dec  R21
          brne WGLOOP1
          dec  R20
          brne WGLOOP0
; ----------------------------- 
; delaying 6 cycles:
          ldi  R20, $02
WGLOOP2:  dec  R20
          brne WGLOOP2
; ============================= 

ret
;****************************************
T0_10m:
; ============================= 
;    delay loop generator 
;     10000 cycles:
; ----------------------------- 
; delaying 9999 cycles:
          ldi  R20, $21
WGLOOP01:  ldi  R21, $64
WGLOOP11:  dec  R21
          brne WGLOOP11
          dec  R20
          brne WGLOOP01
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 


ret
;****************************************
T0_100u:
; ============================= 
;    delay loop generator 
;     100 cycles:
; ----------------------------- 
; delaying 99 cycles:
          ldi  R20, $21
WGLOOP02:  dec  R20
          brne WGLOOP02
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 

ret
;****************************************
T0_4m1:
; ============================= 
;    delay loop generator 
;     4100 cycles:
; ----------------------------- 
; delaying 4095 cycles:
          ldi  R20, $07
WGLOOP03:  ldi  R21, $C2
WGLOOP13:  dec  R21
          brne WGLOOP13
          dec  R20
          brne WGLOOP03
; ----------------------------- 
; delaying 3 cycles:
          ldi  R20, $01
WGLOOP23:  dec  R20
          brne WGLOOP23
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

Tabla:
.db "Andre NirokH"