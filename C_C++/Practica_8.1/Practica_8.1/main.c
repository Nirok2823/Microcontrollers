/*
 * RA1000: Sensor Temperatura
 *
 * Created: 15/04/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librer�a general del Microcontrolador
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
unsigned long medicion_adc=0;
unsigned long medicion_mv=0;
uint8_t unidad, decima, centecima, milesima=0;

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

void delete_seg(float seg){ //delay para segundos y fraccion.
	seg*=1000.00;
	uint8_t auxCont;
	
	int mseg= (int)seg;
	
	while(mseg>1000){
		auxCont=0;
		while (auxCont<4){
			
			_delay_ms(250);
			auxCont+=1;
		}
		
		mseg-=1000;
	}
	
	while(mseg>0){
		if(mseg>=250){
			_delay_ms(250);
			mseg-=250;
		}
		else if (mseg>=100){
			_delay_ms(100);
			mseg-=100;
		}
		else if (mseg>=10){
			_delay_ms(10);
			mseg-=10;
		}
		else{
			_delay_ms(1);
			mseg-=1;
		}
	}
	
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
	medicion_mv=((medicion_adc)*(5000))/1023;
	digitos(medicion_mv, &unidad, &decima, &centecima, &milesima);
	
	lcd_gotoxy(8,1);
	lcd_putc(unidad+48);
	lcd_putc(decima+48);
	lcd_putc(centecima+48);
	lcd_putc('.');
	lcd_putc(milesima+48);
	delete_seg(.5);
}

int main(void)
{
	sei();	
	ADMUX=0b01000111;
	ADCSRA=0b10011011;
	lcd_init(LCD_DISP_ON); 
	lcd_gotoxy(0,0);
	lcd_puts("Temperatura:");
	
    while (1) 
    {
		ADCSRA|=(1<<6);
		while (uno_en_bit(&ADCSRA,6)){}
			medicion_adc=ADC;
			Conversion();
			
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


