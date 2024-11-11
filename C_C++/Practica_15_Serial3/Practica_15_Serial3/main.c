/*
 * Practica_15: Tres Sensores_Sin_interrupcion_con_lcd_Serial
 *
 * Created: 28/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 2000000UL
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
#define conservar_MSB 0xF0
#define conservar_LSB 0x0F
#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1
uint8_t medicion_adc=0;
uint8_t temp=0, hum =0, ph=0;
int conv;
//int medicion_mv=0;
//uint8_t unidad, decima, centecima, milesima=0;
uint8_t sel_port=0;

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


void Leds(uint8_t medicion){
	
	uint8_t aux_x=0;
	uint8_t aux_y=0;
	conv = (int)((float)((medicion*5)/255));
	
	switch(sel_port){
		case 0:
		aux_x=6;
		aux_y=0;
		temp = conv;
		break;
		
		case 1:
		aux_x=12;
		aux_y=0;
		hum = conv;
		
		break;
		
		case 2:
		aux_x=10;
		aux_y=1;
		ph = conv;
		break;
	}
	
	if(medicion<51){
		lcd_gotoxy(aux_x,aux_y);
		lcd_putc('0');	
	}
	else if (medicion<102 && medicion>=51)
	{
		lcd_gotoxy(aux_x,aux_y);
		lcd_putc('1');
	}
	else if (medicion<153 && medicion>=102)
	{
		lcd_gotoxy(aux_x,aux_y);
		lcd_putc('2');
	}
	else if (medicion<204 && medicion>=153)
	{
		lcd_gotoxy(aux_x,aux_y);
		lcd_putc('3');
	}
	else if (medicion<255 && medicion>=204)
	{
		lcd_gotoxy(aux_x,aux_y);
		lcd_putc('4');
	}
	sel_port+=1;
	_delay_ms(62);
}
int main(void)
{
	sei();	
	Usart_init(MYUBRR);
	DDRA|=(0<<0);
	PORTA|=(0<<0);
	
	ADMUX=0b01100000;
	ADCSRA=0b10010100;
	
	lcd_init(LCD_DISP_ON);
	lcd_gotoxy(2,0);
	lcd_puts("Tem:");
	
	lcd_gotoxy(8,0);
	lcd_puts("Hum:");
	
	lcd_gotoxy(7,1);
	lcd_puts("Ph:");
    while (1) 
    {
		if(sel_port<3){
			ADMUX+=1;
		}
		else{
			ADMUX&=0b11111100;
			sel_port=0;
		}
		
		ADCSRA|=(1<<6);	
		
		while(uno_en_bit(&ADCSRA,6)){}
		medicion_adc=ADCH;
		Leds(medicion_adc);
			
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
	switch(UDR){
		case 'T':
		Usart_transmit('T');
		Usart_transmit('e');
		Usart_transmit('m');
		Usart_transmit('p');
		Usart_transmit('e');
		Usart_transmit('r');
		Usart_transmit('a');
		Usart_transmit('t');
		Usart_transmit('u');
		Usart_transmit('r');
		Usart_transmit('a');
		Usart_transmit(':');
		Usart_transmit(' ');
		Usart_transmit(temp+48);
		break;
		
		case 'H':
		Usart_transmit('H');
		Usart_transmit('u');
		Usart_transmit('m');
		Usart_transmit('e');
		Usart_transmit('d');
		Usart_transmit('a');
		Usart_transmit('d');
		Usart_transmit(':');
		Usart_transmit(' ');
		Usart_transmit(hum+48);
		break;
		
		case 'P':
		Usart_transmit('P');
		Usart_transmit('H');
		Usart_transmit(':');
		Usart_transmit(' ');
		Usart_transmit(ph+48);
		break;
	}
	
	Usart_transmit(' ');
	Usart_transmit(' ');
	
}

