/*
 * Practica_9: Tres Sensores_Sin_interrupcion_con_lcd
 *
 * Created: 28/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 4000000UL
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
uint8_t medicion_adc=0;
//int medicion_mv=0;
//uint8_t unidad, decima, centecima, milesima=0;
uint8_t sel_port=0;


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
	
	switch(sel_port){
		case 0:
		aux_x=6;
		aux_y=0;
		break;
		
		case 1:
		aux_x=12;
		aux_y=0;
		
		break;
		
		case 2:
		aux_x=10;
		aux_y=1;
		
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
	
	DDRA|=(0<<0);
	PORTA|=(0<<0);
	
	ADMUX=0b01100000;
	ADCSRA=0b10010110;
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

ISR (ADC_vect)
{
	
}

