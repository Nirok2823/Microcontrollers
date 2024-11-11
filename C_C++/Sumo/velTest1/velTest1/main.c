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

long cnt = 0;
//long timem = 0;
long speed = 0;
//int auxspeed = 0;
long rpm =0;
double kmh = 0;
long rad = 0;
float kms = 0;


uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (!(*LUGAR&(1<<BIT)));
}

uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT)
{
	return (*LUGAR&(1<<BIT));
}

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(10);
	_delay_ms(10);
	
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(10);
	_delay_ms(10);
}

int main(void) {
	sei();
	
	DDRD|=0;
	PORTD=0;
	
	//Configuracion Int0
	GIFR|=(7<<5); //todas las interrupciones
	MCUCR|=(1<<1); //flanco de bajada
	GICR|=(1<<6); //para usar la interrucpion 0
	
	/*
	//Configuracion Timer
	TCNT0 = 0;
	TIFR = 3;
	TIMSK = 2; // sin overfow
	TCCR0 = 0b00001101; //prescaler 1024 modo cnt
	TCCR0-=5;
	OCR0 = 243;*/
	
	
	OLED_Init();  //initialize the OLED
	OLED_Clear(); //clear the display (for good measure)
	OLED_EnableInversion();
	OLED_EnableInversion();
	OLED_SetCursor(0,0);
	OLED_Printf("Velocidad:");
	
	
	while (1) {
		/*
		TCNT0 = 0;
		TCCR0 +=5;
		while(timem<4){}
		TCCR0 -=5;
		timem = 0;*/
		cnt = 0;
		sei();
		for(int i = 0; i <= 100; i++) _delay_ms(10);
		cli();
		rpm = (cnt*60)/20;
		rad = (rpm*3.1416)/30;
		kmh = (rad*0.00005)*3600;
		speed = (int)(kmh*10);
		kms += (rad*0.05);
		cnt = 0;
		
		OLED_SetCursor(0,0);
		OLED_GoToNextLine();
		OLED_DisplayChar((speed/1000)+48);
		OLED_DisplayChar(((speed/100)%10)+48);
		OLED_DisplayChar(((speed/10)%10)+48);
		OLED_DisplayChar('.');
		OLED_DisplayChar((speed%10)+48);
		OLED_Printf(" km/h");
		OLED_GoToNextLine();
		OLED_GoToNextLine();
		OLED_Printf("Rpm:");
		OLED_GoToNextLine();
		
		OLED_DisplayNumber(E_DECIMAL, (int)rpm, 4);
		
		OLED_GoToNextLine();
		OLED_GoToNextLine();
		OLED_Printf("Distancia:");
		OLED_GoToNextLine();
		OLED_DisplayNumber(E_DECIMAL, (int)kms, 5);
		OLED_Printf(" Mts");
		
		
	}
	
	return 0; // never reached
}

ISR (INT0_vect)
{
	cnt+=1;
	//Traba(&PIND,2);
	
}

/*
ISR (TIMER0_COMP_vect)
{
	timem +=1;
	
}
*/