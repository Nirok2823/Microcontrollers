/*
 * OledTestEncoder.c
 *
 * Created: 28/05/2024 12:14:32 a. m.
 * Author : Dell
 */ 

#define  F_CPU 8000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
//#include "lcd.h"
#include <avr/interrupt.h>
#include "SSD1306.h"
#include "i2c.h"

uint8_t cnt = 0;


uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (!(*LUGAR&(1<<BIT)));
}

uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (*LUGAR&(1<<BIT));
}

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

int main(void) {
	sei();
	
	DDRD|=0;
	PORTD=0;
	
	//Configuracion Int0
	GIFR|=(7<<5); //todas las interrupciones
	MCUCR|=(1<<1); //flanco de bajada
	GICR|=(1<<6); //para usar la interrucpion 0
	
	//Configuracion Timer
	
	
	OLED_Init();  //initialize the OLED
	OLED_Clear(); //clear the display (for good measure)
	OLED_EnableInversion();
	OLED_EnableInversion();
	OLED_SetCursor(0,0);
	OLED_Printf("Cuenta:");
	
	
	while (1) {
		OLED_SetCursor(0,0);
		OLED_GoToNextLine();
		OLED_DisplayNumber(E_DECIMAL, cnt, 3);
		
		
		

	}
	
	return 0; // never reached
}

ISR (INT0_vect)
{
	cnt+=1;
	//Traba(&PIND,2);
	_delay_ms(20);
	
}