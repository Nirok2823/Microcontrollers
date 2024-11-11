
#define  F_CPU 8000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************************************************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************************************************************

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

int main(void)
{
	DDRB = 0b10110000;
	DDRA = 0xFF;
	DDRC = 0x00;
	
	PORTC = 0xFF;
	PORTA = 0xFF;	
	SPSR = 0b00000001;
	SPCR = 0b01010000;
	

	
    while (1) 
    {
		if (cero_en_bit(&PINC, 0))
		{
			//esclavo 6
			PORTA = 0b10111111;
			
			SPDR = 0b11111110;
			
			while (cero_en_bit(&SPSR,7)) {}
			uint8_t basura= SPDR;
			
			//esclavo 7
			PORTA = 0X7F;
			
			SPDR = 0b11110000;
			
			while (cero_en_bit(&SPSR,7)) {}
			
			PORTA = 0XFF;	
				
			basura= SPDR;
			
			Traba(&PINC, 0);
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

