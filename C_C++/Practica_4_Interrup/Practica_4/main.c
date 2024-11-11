/*
 * Practica_4: Dado
 *
 * Created: 02/02/24
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
#define Pin_Teclado PINA
#define Puerto_teclado PORTA
uint8_t Random_n=0;

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

int main(void)
{
	sei();
	DDRA|=(0xFF<<0);
	PORTA|=(0<<0);
	
	DDRB|=(0xFF<<0);
	PORTB|=(0<<0);
	
	DDRD|=(0xFF<<0);
	DDRD^=(1<<2); // se declara como Entrada el d2
	PORTD|=(1<<2); //pull up en el boton de la interrupcion 
	
	GIFR|=(7<<5); //todas las interrupciones
	MCUCR|=(1<<3); //flanco de bajada
	GICR|=(1<<6); //para usar la interrucpion 0
	
    while (1) 
    {
		for(int i=1; i<=6; i++){
			Random_n=i;
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

ISR (INT0_vect)
{
	switch(Random_n){
		case 1:
		PORTA=0x00;
		PORTB=0x01;
		break;
		
		case 2:
		PORTA=0x24;
		PORTB=0x00;
		break;
		
		case 3:
		PORTA=0x81;
		PORTB=0x01;
		break;
		
		case 4:
		PORTA=0xA5;
		PORTB=0x00;
		break;
		
		case 5:
		PORTA=0xA5;
		PORTB=0x01;
		break;
		
		case 6:
		PORTA=0xE7;
		PORTB=0x00;
		break;

	}
	
	Traba(&PIND,2);
	
	// Código de la función de interrupción.
	// No requiere limpiar el flag respectivo. El flag se limpia por hardware
}
