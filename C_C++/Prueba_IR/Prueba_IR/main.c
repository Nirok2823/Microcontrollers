/*
 * Practica_15: Tres Sensores_Sin_interrupcion_con_lcd_Serial
 *
 * Created: 28/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************
#define BAUD 4800
#define MYUBRR F_CPU/16/BAUD-1
unsigned char st = 'i';

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

int main(void)
{
	sei();
	Usart_init(MYUBRR);
	DDRB = 0xFE;
	PORTB = 0x01;
	DDRD = 0b00000010;
	
	
	while (1)
	{
		if(cero_en_bit(&PINB,0)){
			st ='1';
		}
		else if(uno_en_bit(&PINB,0)){
			st = '0';
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

ISR (USART_RXC_vect) 
{
	st = UDR;
	Usart_transmit(st);
}
