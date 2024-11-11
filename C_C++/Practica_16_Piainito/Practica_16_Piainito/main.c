/*
 * Practica_16: Juego Para ninos
 * Created: 28/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
//#include "lcd.h"
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************
#define C5	28
#define B4	31
#define A4	35
#define G4	39
#define F4	44
#define	E4	46
#define	D4	50
#define	C4	55

char buttonTrans =0;
char buttonRec =0;
uint8_t bit;

#define uno 0b11111110
#define dos 0b11111101
#define tres 0b11111011
#define cuatro 0b11110111
#define cinco 0b11101111
#define seis 0b11011111
#define siete 0b10111111
#define ocho 0b01111111


#define BAUD 4800
#define MYUBRR F_CPU/16/BAUD-1

void Usart_init(uint16_t ubrr){
	UBRRH = (uint8_t)(ubrr>>8);
	UBRRL = (uint8_t) ubrr;
	
	UCSRB = 0b10011000;
	UCSRC = 0b10000110;
}

void Usart_transmit(uint8_t data){
	while(cero_en_bit(&UCSRA, UDRE)){}
	UDR = data;
}

char Usart_recive(){
	while(cero_en_bit(&UCSRA, RXC)){}
	return UDR;
}


void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}


void delay_s(uint8_t seg){
	uint8_t auxCont;
	uint8_t aux_seg=0;
	
	while(aux_seg<seg){
		auxCont=0;
		
		while (auxCont<4){
			_delay_us(62500);
			auxCont+=1;
		}
		aux_seg+=1;
	} 
}

void Send(){
	
	if(PINA != 0xFF){
		switch (PINA)
		{
			case uno:
			buttonTrans = '1';
			OCR0 = C4;
			bit = 0;
			break;
			
			case dos:
			buttonTrans = '2';
			OCR0 = D4;
			bit = 1;
			break;
			
			case tres:
			buttonTrans = '3';
			OCR0 = E4;
			bit = 2;
			break;
			
			case cuatro:
			buttonTrans = '4';
			OCR0 = F4;
			bit = 3;
			break;
			
			case cinco:
			buttonTrans = '5';
			OCR0 = G4;
			bit = 4;
			break;
			
			case seis:
			buttonTrans = '6';
			OCR0 = A4;
			bit = 5;
			break;
			
			case siete:
			buttonTrans = '7';
			OCR0 = B4;
			bit = 6;
			break;
			
			case ocho:
			buttonTrans = 'I';
			break;
		}
	if(buttonTrans == buttonRec){
		TCCR0+=3;
		Traba(&PINA, bit);
		TCCR0-=3;
		TCNT0 = 0;
	} else Traba(&PINA,bit);
		Usart_transmit(buttonTrans);
	}
}

int main(void)
{
	sei();	
	Usart_init(MYUBRR);
	DDRA|=(0<<0); // todos de entrada
	PORTA|=(0xFF<<0); //todos con pullup
	DDRB|=(0xFF<<0); // todos de salida
	PORTB|=(0<<0); //todos en 0;
	
	// configuracion del timer
	TIFR=3;
	TIMSK=2;
	TCNT0=0;
	TCCR0=0b00011011; 
	OCR0=0;
	TCCR0-=3;
	//para apagar el timer restamos 3 y prenderlo sumarlo
	
    while (1) 
    {
		Send();	
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

ISR (USART_RXC_vect) 
{
	buttonRec = UDR;
}

ISR (TIMER0_COMP_vect)
{
	
}

