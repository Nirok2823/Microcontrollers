/*
 * Practica16, Esclavo2
 *
 * Created: 02/05/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
//#include "lcd.h"
//#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************
#define slave1 0b10000000
#define slave2 0b01000000
#define wSlave 0b11000000

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

void initSpi(){
	SPCR = 0b01100000;
	SPSR = 0b10000000;
}


int main(void)
{
	initSpi();
	DDRB = 0b01000000;
	DDRC = 0b11111111;
	
	char dat = ' ';
	
    while (1) 
    {
		dat = SPDR;
		if(dat == 0) PORTC = 0b11110000;
		else PORTC = 0;
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