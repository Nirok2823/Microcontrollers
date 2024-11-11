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

sei

;*********************************
;Aquí comienza el programa...
;No olvides configurar al inicio todo lo que utilizarás
;*********************************
ldi r16, 0b1111_0000 // los pines c0-c3 son entrada y c4-c7 son salidas
out DDRC, R16
ldi r16, 0b0000_0010 // todos los pines de entrada exceptuado el led (b1)
out DDRB, R16

ldi r16, 0b1111_1101
 out PortB, r16

ldi r16, 0b1110_0000 //setear las banderas de las interrupciones aun sin ocurrir
out GIFR, r16        //normal mente se setean las 3 banderas juntas. bits 7(I1),6(I0),5(I2)
                     // Siempre configurar con: 0b1110_0000   

ldi r16, 0b0000_0000  //Se usa para setear con que tipo de flanco se va a trabajar
out MCUCSR, r16        // el bit 6 es I2, bits 0,1 son (I0) y bits 3 y 4 son (I1)
                      // 00=0v
					  // 01=Flancos tanto de subida como de bajada
					  // 10= Flancos de Bajada
					  // 11=Flancos de subida

ldi r16, 0b0010_0000   //Regristro para habilitar las Interrupciones
out GICR, r16          //Bit 7= (I1)
                       //Bit 6= (I0)
					   //Bit 5= (I2)

ldi r17, $01 //bandera 0b0000_0001
ldi r18, 0 //Letras A o B
ldi r19, 0 // numeros 1 o 2
ldi r22, 0 // Digito1 Costo
ldi r23, 0 // Digito2 Costo
ldi r24, 0 // Decenas
ldi r25, 0 // Unidades
ldi r27, 48 // Dpara pasar a asqui
ldi r29, 0 //registro para la cantidad
ldi r31, 10 //registro para la cantidad
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
breq Lbajo

rcall WR_DAT

rjmp Read

Limit:
ldi zl,0
inc zh
rjmp Operate

Lbajo:
ldi VAR, 0b1100_0000
Rcall WR_INS ;Posicion 0x40
ldi VAR, 0b0000_1111
Rcall WR_INS ; Blink
rjmp Inicio
rjmp Lbajo

Inicio:

sbrc r17, 0
rcall Btns_AB

sbrc r17, 1
rcall Btns_12

sbrc r17, 2
rjmp sProduct

rjmp Inicio

sProduct:
ldi Var, 0b0000_0001
rcall WR_INS // se limpio el lcd
ldi VAR, 0b0000_1100
Rcall WR_INS ; Se quita el blink

cpi r18, 'A'
breq As

cpi r18, 'B'
breq Bs

rjmp sProduct

As:
cpi r19, '1'
breq A1

cpi r19, '2'
breq A2

rjmp As

Bs:

cpi r19, '1'
breq B1

cpi r19, '2'
breq B2

rjmp Bs

A1:
ldi r22, '0'
ldi r23, '3'

rjmp Insertar_Msg1

A2:
ldi r22, '0'
ldi r23, '9'
rjmp Insertar_Msg1

B1:
ldi r22, '2'
ldi r23, '3'
rjmp Insertar_Msg1

B2:
ldi r22, '3'
ldi r23, '1'
rjmp Insertar_Msg1

Insertar_Msg1:
Start1: 
ldi zh, High(Ins*2)
ldi zl, Low(Ins*2)
lpm
mov VAR, r0
rcall WR_DAT

Read1:
cpi zl,0
breq Operate1

cpi zl, $FF
breq Limit1

inc zl

Operate1:
lpm
mov VAR, r0
cpi VAR,'H'
breq Insertar_Msg2

rcall WR_DAT

rjmp Read1

Limit1:
inc zl
inc zh
rjmp Operate1

rjmp Insertar_Msg1

Insertar_Msg2:
mov Var,r22
rcall WR_DAT

mov Var,r23
rcall WR_DAT

ldi Var, '.'
rcall WR_DAT

ldi Var, '0'
rcall WR_DAT
ldi Var, '0'
rcall WR_DAT

ldi VAR, 0b1100_0000
Rcall WR_INS ;Posicion 0x40

Start2: 
ldi zh, High(InsC*2)
ldi zl, Low(InsC*2)
lpm
mov VAR, r0
rcall WR_DAT

Read2:
cpi zl,0
breq Operate2

cpi zl, $FF
breq Limit2

inc zl

Operate2:
lpm
mov VAR, r0
cpi VAR,'H'
breq loop

rcall WR_DAT

rjmp Read2

Limit2:
inc zl
inc zh
rjmp Operate2

loop:
lsl r17
ldi VAR, 0b1100_1000
Rcall WR_INS ;Posicion 0x48
rjmp Insertar
rjmp loop


rjmp Insertar_Msg2

Insertar:
 cp r25, r23
 brsh check
 brlo check2
rjmp Insertar

check:
cp r24, r22
brsh Entregando
rjmp Insertar

check2:
cp r22, r24
brlo Entregando
rjmp Insertar




Entregando:
ldi Var, 0b0000_0001
rcall WR_INS // se limpio el lcd

ldi Var, 0b1000_0000
rcall WR_INS // se limpio el lcd
ldi Var, 'E'
rcall WR_DAT
nop
ldi Var, 'n'
rcall WR_DAT
nop
ldi Var, 't'
rcall WR_DAT
nop
ldi Var, 'r'
rcall WR_DAT
nop
ldi Var, 'e'
rcall WR_DAT
nop
ldi Var, 'g'
rcall WR_DAT
nop
ldi Var, 'a'
rcall WR_DAT
nop
ldi Var, 'n'
rcall WR_DAT
nop
ldi Var, 'd'
rcall WR_DAT
nop
ldi Var, 'o'
rcall WR_DAT
nop
ldi Var, '.'
rcall WR_DAT
nop
ldi Var, '.'
rcall WR_DAT
nop
ldi Var, '.'
rcall WR_DAT

Entregando2:
sbi portb, 1
ldi VAR, 0b1100_0000
Rcall WR_INS ;Posicion 0x48
ldi Var, 'C'
rcall WR_DAT
ldi Var, 'a'
rcall WR_DAT
ldi Var, 'm'
rcall WR_DAT
ldi Var, 'b'
rcall WR_DAT
ldi Var, 'i'
rcall WR_DAT
ldi Var, 'o'
rcall WR_DAT
ldi Var, 0
rcall WR_DAT

rcall Cambio
mov var, r24
rcall WR_DAT
mov var, r25
rcall WR_DAT

ldi Var, '.'
rcall WR_DAT

ldi Var, '0'
rcall WR_DAT
ldi Var, '0'
rcall WR_DAT
rcall Delay_2s
rjmp reseti

rjmp entregando2

reseti:
cbi Portb, 1
ldi Var, 0b0000_0001
rcall WR_INS // se limpio el lcd
cbi portb, 1
ldi r17, $01 //bandera 0b0000_0001
ldi r18, 0 //Letras A o B
ldi r19, 0 // numeros 1 o 2
ldi r22, 0 // Digito1 Costo
ldi r23, 0 // Digito2 Costo
ldi r24, 0 // Decenas
ldi r25, 0 // Unidades
ldi r27, 48 // Dpara pasar a asqui
ldi r29, 0 //registro para la cantidad
ldi r31, $0A //registro para la cantidad
rjmp Start

Btns_AB:

ldi r16, 0b0111_1111
out PORTC, r16 
nop

sbis PINC, 0
rjmp A
sbis PINC, 1
rjmp B

ret

Btns_12:

ldi r16, 0b1110_1111
out PORTC, r16 
nop

sbis PINC, 2
rjmp Uno

sbi PortC, 4
cbi PortC, 5
nop 

sbis PINC, 2
rjmp Dos

ret


A:
ldi VAR, 'A'
mov r18,Var

RCALL Retardo
while_A:
sbis PINC, 0
rjmp while_A
rcall Retardo

rcall WR_DAT

lsl r17
rjmp Inicio

B:
ldi VAR, 'B'
mov r18,Var

RCALL Retardo
while_B:
sbis PINC, 0
rjmp while_B
rcall Retardo

rcall WR_DAT

lsl r17
rjmp Inicio

Uno:
ldi VAR, '1'
mov r19,Var

RCALL Retardo
while_1:
sbis PINC, 2
rjmp while_1
rcall Retardo

rcall WR_DAT

lsl r17
rjmp Inicio
//

Dos:
ldi VAR, '2'
mov r19,Var
RCALL Retardo
while_2:
sbis PINC, 2
rjmp while_2
rcall Retardo

rcall WR_DAT
lsl r17
rjmp Inicio


Retardo:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R20, $65
WGLOOP0000:  ldi  R21, $A4
WGLOOP1000:  dec  R21
          brne WGLOOP1000
          dec  R20
          brne WGLOOP0000
; ----------------------------- 
; delaying 3 cycles:
          ldi  R20, $01
WGLOOP2000:  dec  R20
          brne WGLOOP2000
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
	ret

	Cambio:
	subi r22, 48
	subi r23, 48
	subi r24, 48
	subi r25, 48
	 cp r25,r23
	 brlo special
	 rjmp finale

	 special:
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 inc r25
	 dec r24
	 rjmp finale

	 finale:
	 sub r24,r22
	 sub r25,r23
	 add r24, r27
	 add r25, r27
	 ret


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
.equ LCD_DAT=DDRA
.equ PORT_DAT=PORTA
.equ PIN_DAT=PINA
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
	   	sbis PIN_DAT, 7		
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
Tabla:
.db "Elige Producto H"
InsC:
.db "Tienes $00.00H"
Ins:
.db "Inserta $H"
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
zero:
ldi r24, '0'
rjmp w
EXT_INT2: 
in r28, SREG //Se realiza un respaldo de las banderas, copiando el sreg 
push r28    //Se manda lo del registro a una pila del micro


sbrs r17, 3
rjmp gOut
ldi r24, 0
in r26, PinB
lsr r26
lsr r26
lsr r26
lsr r26

cpi r26, 0b0000_0001
breq Un_peso

cpi r26, 0b0000_0010
breq Dos_peso

cpi r26, 0b0000_0011
breq Cinco_peso

cpi r26, 0b0000_0100
breq Diez_peso

sig:
mov r25, r29
cpi r25, $0A
brsh Big

sigg:
cpi r24, 0
breq zero

add r24, r27



w:
add r25, r27
mov var, r24
rcall WR_DAT


mov var, r25
rcall WR_DAT

ldi VAR, 0b1100_1000
Rcall WR_INS ;Posicion 0x48


gOut:
rcall Retardo
while5:
sbis PINB, 2
rjmp while5
rcall Retardo

 pop r28			//Se saca de la pila las banderas del SREG
 out SREG, r28		//Mandamos al SREG las banderas de respaldo
 		
reti ; IRQ2 Handler

TIM0_COMP: 
reti
SPM_RDY: 
reti ; Store Program Memory Ready Handler

Un_peso:
inc r29
rjmp sig

Dos_peso:
inc r29
inc r29
rjmp sig

Cinco_peso:
inc r29
inc r29
inc r29
inc r29
inc r29
rjmp sig

Diez_peso:
inc r29
inc r29
inc r29
inc r29
inc r29
inc r29
inc r29
inc r29
inc r29
inc r29
rjmp sig

Big:
subi r25, $0A
inc r24
cpi r25, $0A
brsh Big

rjmp sigg

Delay_2s:
; ============================= 
;    delay loop generator 
;     2000000 cycles:
; ----------------------------- 
; delaying 1999998 cycles:
          ldi  R20, $12
WGLOOP011:  ldi  R21, $BC
WGLOOP111:  ldi  R31, $C4
WGLOOP211:  dec  R31
          brne WGLOOP211
          dec  R21
          brne WGLOOP111
          dec  R20
          brne WGLOOP011
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
ret



