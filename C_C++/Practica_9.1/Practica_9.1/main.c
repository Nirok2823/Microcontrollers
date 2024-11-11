/*
 * Practica_9: Tres Sensores_con_interrupcion
 *
 * Created: 28/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 4000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************
#define conservar_MSB 0xF0
#define conservar_LSB 0x0F
uint8_t medicion_adc=0;
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


void Leds(uint8_t medicion, volatile uint8_t *puerto){
	
	uint8_t aux=0;
	uint8_t aux_1=0;
	uint8_t aux_2=0;
	uint8_t aux_3=0;
	uint8_t aux_4=0;
	switch(sel_port){
		case 0:
		aux=conservar_MSB;
		aux_1=0b00000001;
		aux_2=0b00000011;
		aux_3=0b00000111;
		aux_4=0b00001111;
		break;
		
		case 1:
		aux=conservar_LSB;
		aux_1=0b10000000;
		aux_2=0b11000000;
		aux_3=0b11100000;
		aux_4=0b11110000;
		break;
		
		case 2:
		aux=conservar_MSB;
		aux_1=0b00000001;
		aux_2=0b00000011;
		aux_3=0b00000111;
		aux_4=0b00001111;
		break;
	}
	
	if(medicion<51){
		*puerto&=aux;
	}
	else if (medicion<102 && medicion>=51)
	{
		*puerto&=aux;
		*puerto|=aux_1;
	}
	else if (medicion<153 && medicion>=102)
	{
		*puerto&=aux;
		*puerto|=aux_2;
	}
	else if (medicion<204 && medicion>=153)
	{
		*puerto&=aux;
		*puerto|=aux_3;
	}
	else if (medicion<255 && medicion>=204)
	{
		*puerto&=aux;
		*puerto|=aux_4;
	}
	sel_port+=1;
	_delay_ms(62);
}
int main(void)
{
	sei();	
	
	DDRA|=(0<<0);
	PORTA|=(0<<0);
	
	DDRB|=~(0<<0);
	PORTB|=(0<<0);
	
	DDRC|=~(0<<0);
	PORTC|=(0<<0);
	
	
	ADMUX=0b01100000;
	ADCSRA=0b10011110;
	
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
	medicion_adc=ADCH;
	
	if(sel_port<2) Leds(medicion_adc, &PORTB);
	
	else Leds(medicion_adc, &PORTC);
}


