/*
 * Practica_13: Voltimetro_con_serial
 *
 * Created: 21/03/24
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

unsigned long medicion_adc=0;
unsigned long medicion_mv=0;
uint8_t unidad, decima, centecima, milesima=0;

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

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}
void digitos(int timeC, uint8_t *u, uint8_t *d, uint8_t *c, uint8_t *m){
	*u= (timeC/1000); //valor de la unidad
	while(timeC>=1000){
		timeC-=1000;
	}
	*d= timeC/100;
	while(timeC>=100){
		timeC-=100;
	}
	*c= timeC/10;
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

void Conversion(){
	medicion_mv=((medicion_adc)*(5000))/255;
	//medicion_mv/=255;
	digitos(medicion_mv, &unidad, &decima, &centecima, &milesima);
	lcd_clrscr();
	lcd_puts("Voltaje:");
	lcd_putc(unidad+48);
	lcd_putc('.');
	lcd_putc(decima+48);
	lcd_putc(centecima+48);
	lcd_putc(milesima+48);
	_delay_ms(50);
}



int main(void)
{
	sei();	
	ADMUX=0b01100111;
	ADCSRA=0b10011011;
	lcd_init(LCD_DISP_ON); 
	Usart_init(MYUBRR);
	
    while (1) 
    {
		ADCSRA|=(1<<6);
		while (uno_en_bit(&ADCSRA,6)){}
			medicion_adc=ADCH;
			Conversion();
			Usart_transmit(unidad+48);
			Usart_transmit('.');
			Usart_transmit(decima+48);
			Usart_transmit(centecima+48);
			Usart_transmit(milesima+48);
			_delay_ms(50);
			
			
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

ISR (ADC_vect)
{
	
}

