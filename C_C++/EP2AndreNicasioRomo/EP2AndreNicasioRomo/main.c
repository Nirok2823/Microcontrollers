/*
 * Practica_10: Temperatura
 *
 * Created: 15/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
#include "lcd.h"
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************

#define BAUD 4800
#define MYUBRR F_CPU/16/BAUD-1

volatile uint8_t dhrs=0;
volatile uint8_t uhrs=8;

volatile uint8_t dmin=4;
volatile uint8_t umin=9;

volatile uint8_t dseg=0;
volatile uint8_t useg=0;

volatile uint8_t cont=0;

volatile uint8_t d1=0;
volatile uint8_t d2=0;

volatile uint8_t refTemp=0;
volatile uint8_t sensorTemp=0;
volatile uint8_t medicion = 0;
volatile long volts = 0;
volatile uint8_t pos = 0;
volatile uint8_t lcdPos = 0;
volatile uint16_t eepromDir = 0;

void Usart_init(uint16_t ubrr){
	UBRRH = (uint8_t)(ubrr>>8);
	UBRRL = (uint8_t) ubrr;
	
	UCSRB = 0b10011000;
	UCSRC = 0b10001110;
}

void Usart_transmit(uint8_t data){
	while(cero_en_bit(&UCSRA, UDRE)){}
	UDR = data;
}


void EEPROM_write(uint8_t Dir, uint8_t Dat)
{
	while(uno_en_bit(&EECR,EEWE)){}
	
	EEAR=Dir;
	EEDR=Dat;
	cli();
	
	EECR|=(1<<EEMWE);
	EECR|=(1<<EEWE);
	
	sei();
}

uint8_t EEPROM_read(uint8_t Dir)
{
	while(uno_en_bit(&EECR,EEWE)){}
	
	EEAR=Dir;
	EECR|=(1<<EERE);
	return EEDR;
}

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}


void digitos(long timeC, volatile uint8_t *c, volatile uint8_t *m){
	*c= (timeC/10);
	while(timeC>=10){
		timeC-=10;
	}
	*m=timeC;
}

void delay_s(uint8_t seg){
	uint8_t auxCont;
	uint8_t aux_seg=0;
	
	while(aux_seg<seg){
		auxCont=0;
		
		while (auxCont<4){
			_delay_ms(250);
			auxCont+=1;
		}
		aux_seg+=1;
	} 
}

uint8_t RefTemp(uint8_t v){
	return (uint8_t) (((9)*v)+5);
}

uint8_t Sensores(uint8_t v){
	return  (uint8_t)(((7)*v)+15);
}

void printTemp(volatile uint8_t *temp){
	d1 = 0;
	d2 = 0;
	digitos(*temp, &d1, &d2);
	lcd_putc(d1+48);
	lcd_putc(d2+48);
}
uint8_t hexToDecimal(uint8_t d1, uint8_t d2){
	uint8_t decimal = 0;
	while(d1>=1){
		decimal += 10;
		d1 -= 1;
	}
	decimal += d2;
	return decimal;
}
void alert(uint8_t posBit, uint8_t temp){
	if(eepromDir < 512){
		uint8_t aux = 0;
		switch (posBit){
			case 7:
			aux = 1;
			break;
			
			case 6:
			aux = 2;
			break;
			
			case 5:
			aux = 3;
			break;
			
			case 4:
			aux = 4;
			break;
		}
		
		EEPROM_write(eepromDir,hexToDecimal(dhrs,uhrs));
		EEPROM_write(eepromDir+1,hexToDecimal(dmin,umin));
		EEPROM_write(eepromDir+2,aux);
		EEPROM_write(eepromDir+3,medicion);
		
		if(cero_en_bit(&PINB,posBit))  PORTB |= (1<<posBit);
		
		eepromDir+=4;
		
	}
	
}

void Sensando(){
	
	lcd_clrscr();
	lcd_gotoxy(0,0);
	lcd_putc(dhrs+48);
	lcd_putc(uhrs+48);
	lcd_putc(':');
	lcd_putc(dmin+48);
	lcd_putc(umin+48);
	ADMUX=0b01100000; // iniciamos sensando la temp de ref
	
	ADCSRA|=(1<<6);
	while (uno_en_bit(&ADCSRA,6)){}
	medicion=ADCH;
	volts = (medicion*5)/255;
	refTemp=RefTemp(volts);
	
	lcd_gotoxy(14,0);
	printTemp(&refTemp);
	pos = 7;
	lcdPos = 0;
	ADMUX += 7;
	
	while(pos >= 4){
		ADCSRA|=(1<<6);
		while (uno_en_bit(&ADCSRA,6)){}
		medicion=ADCH;
		volts = (medicion*5)/255;
		sensorTemp = Sensores(volts);
		lcd_gotoxy(lcdPos,1);
		if(sensorTemp < refTemp){
			alert(pos, sensorTemp);
		}
		
		else if(uno_en_bit(&PINB,pos)) PORTB^= (1<<pos);
		printTemp(&sensorTemp);
		
		
		
		ADMUX-=1;
		pos-=1;
		lcdPos+=3;
	}
	delay_s(60);
	
}
	
void Consulta(){
	eepromDir = 0;
	PORTB = 0;
	lcd_clrscr();
	lcd_gotoxy(4,0);
	lcd_puts("CONSULTA");
	_delay_ms(50);
}

int main(void)
{
	sei();
	//Usart_init(MYUBRR);
	DDRA = 0b00000000;// todos los pines de A como entrada y sin pull up
	
	DDRD = 0b11111110; // solo el d0 es de entrada
	PORTD=0b00000001; // d0 con pull up
	
	DDRB=0xFF; // todos los pines de B son salida
	PORTB=0;   // todos inician en 0;	
	
	ADMUX=0b01100000; //Adc con lectura de 8 bits
	ADCSRA=0b10011011; //Adc sin interrupcion
	
	//Configuracion del timer
	TCNT0|=(0<<0); // 0b0000_0000
	TIFR|=(1<<1); // 0b0000_0011
	TIFR|=(1<<0); 
	TIMSK|=(1<<1); // 0b0000_0010
	TCCR0|=(1<<3); //
	TCCR0|=(1<<2); //
	TCCR0|=(1<<0); //0b0000_1101
	
	OCR0=243; // Valor del Ocr para que entre  a la interrupcion cada cuarto de segundo
	
	lcd_init(LCD_DISP_ON);
	Usart_init(MYUBRR);
	
	
    while (1) 
    {
		if(cero_en_bit(&PIND,0)){
			Consulta();
		}
		
		else if(uno_en_bit(&PIND,0)){
			if(eepromDir < 512) Sensando();
			else{
				lcd_clrscr();
				lcd_gotoxy(8,0);
				lcd_puts("Reinicio...");
				
				Usart_transmit('A');
				delay_s(5);
				eepromDir = 0;
				} 
		}
		
	}
		
}


uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (!(*LUGAR&(1<<BIT)));
}

uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (*LUGAR&(1<<BIT));
}

ISR (TIMER0_COMP_vect)
{
	
	cont+=1;
	if (cont==4){
		useg+=1;
		cont=0;
		
		if(useg==10){
			useg=0;
			dseg+=1;
		}
		
		if(dseg==6){
			dseg=0;
			umin+=1;
		}
		
		if(umin==10){
			umin=0;
			dmin+=1;
		}
		
		if(dmin==6){
			dmin=0;
			uhrs+=1;
		}
		
		if(uhrs==10){
			uhrs=0;
			dhrs+=1;
		}
		
		if(dhrs==2 && uhrs==4){
			dhrs=0;
			uhrs=0;
			dmin=0;
			umin=0;
			dseg=0;
			useg=0;
		}
		
		if(uno_en_bit(&PIND,0)){
			lcd_gotoxy(0,0);
			lcd_putc(dhrs+48);
			lcd_putc(uhrs+48);
			lcd_putc(':');
			lcd_putc(dmin+48);
			lcd_putc(umin+48);
		}	
	}	
	
}





ISR (ADC_vect)
{

}

ISR (USART_RXC_vect)
{
	
}
