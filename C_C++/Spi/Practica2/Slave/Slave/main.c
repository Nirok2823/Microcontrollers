
#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
//#include "lcd.h"
#include <avr/interrupt.h>	 //Para poder manejar interrupciones
//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************************************************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************************************************************


int main(void)
{
	DDRB = 0b01000000;
	DDRC = 0xFF;
	
	
	SPCR = 0b01000000;
	SPSR = 0b00000001;
	
    while (1) 
    {
		if (uno_en_bit(&SPSR,7))
		{
			PORTC = SPDR;
			_delay_ms(250);
			_delay_ms(250);
			_delay_ms(250);
			_delay_ms(250);
			PORTC = 0;
			
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