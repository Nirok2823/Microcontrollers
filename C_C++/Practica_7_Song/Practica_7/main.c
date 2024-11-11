/*
 * Practica_6: Temporizador
 *
 * Created: 15/02/24
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
/*
#define Pin_Teclado PIND
#define Puerto_teclado PORTD
#define restar_dec 0x10
#define conservar_dec 0xF0
#define conservar_uni 0x0F
*/
#define D6	12
#define Db6	13
#define B5	15
#define Bb5	16
#define A5	17
#define D5	26
#define Db5 27
#define C5	29
#define B4	31
#define Bb4 33
#define A4	35
#define Ab4 37
#define G4	39
#define Gb4 41
#define F4	44
#define	E4	46
#define	Eb4	48
#define	D4	50
#define	Db4	52
#define B3	62
#define A3	70

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

void delete_s(uint8_t seg){
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

void NegraPunto(uint8_t nota){
	OCR0=nota;
	/*
	_delay_ms(250);
	_delay_ms(250);
	*/
	delete_seg(0.5);
}
void Negra(uint8_t nota){
	OCR0=nota;
	/*
	_delay_ms(200);
	_delay_ms(133);
	*/
	delete_seg(0.333);
}

void Corchea(uint8_t nota){
	OCR0=nota;
	_delay_ms(167);
}

void Scorchea(uint8_t nota){
	OCR0=nota;
	_delay_us(83300);
}


int main(void)
{
	sei();	
	
	DDRB|=~(0<<0);
	
	
	//Configuracion del timer
	TIFR=3;
	TIMSK=2;
	TCNT0=0;
	TCCR0=0b00011011;
	//OCR0=15; // valor para que este en 0 grados
	
	
    while (1) 
    {
		Scorchea(Db5);
		Scorchea(C5);
		Scorchea(B4);
		Scorchea(Bb4);
		
		Scorchea(C5);
		Scorchea(B4);
		Scorchea(Bb4);
		Scorchea(A4);
		
		Scorchea(B4);
		Scorchea(Bb4);
		Scorchea(A4);
		Scorchea(Ab4);
		
		Scorchea(Bb4);
		Scorchea(A4);
		Scorchea(Ab4);
		Scorchea(G4);
		
		Scorchea(A4);
		Scorchea(Ab4);
		Scorchea(G4);
		Scorchea(Gb4);
		
		Scorchea(Ab4);
		Scorchea(G4);
		Scorchea(Gb4);
		Scorchea(F4);
		
		Scorchea(G4);
		Scorchea(Gb4);
		Scorchea(F4);
		Scorchea(E4);
		
		Scorchea(Gb4);
		Scorchea(F4);
		Scorchea(E4);
		Scorchea(B3);
		
		NegraPunto(B4);
		NegraPunto(Db5);
		Negra(D5);
		
		Corchea(B4);
		Negra(Db5);
		NegraPunto(D5);
		
		Negra(A4);
		
		NegraPunto(B4);
		NegraPunto(Db5);
		Negra(D5);
		
		Corchea(B4);
		Negra(Db5);
		NegraPunto(D5);
		
		Corchea(A4);
		Corchea(Bb4);
		NegraPunto(B4);
		NegraPunto(Db5);
		Negra(D5);
		Corchea(B4);
		Negra(Db5);
		NegraPunto(D5);
		
		Corchea(A5);
		Corchea(Bb5);
		NegraPunto(B5);
		NegraPunto(Db6);
		Negra(D6);
		Corchea(B5);
		Negra(Db6);
		NegraPunto(D6);
		
		Negra(A5);
		
		Corchea(Ab4);
		Negra(Db5);
		Corchea(Ab4);
		Negra(Db5);
		Negra(Ab4);
		Negra(D4);
		
		Corchea(Ab4);
		Negra(D4);
		
		Corchea(Gb4);
		Corchea(Ab4);
		NegraPunto(A4);
		
		//
		Scorchea(D4);
		Scorchea(Eb4);
		Scorchea(E4);
		Scorchea(F4);
		
		Scorchea(Gb4);
		Scorchea(F4);
		Scorchea(E4);
		Scorchea(Eb4);
		
		Scorchea(D4);
		Scorchea(Eb4);
		Scorchea(E4);
		Scorchea(F4);
		
		Scorchea(Gb4);
		Scorchea(G4);
		Scorchea(Ab4);
		Scorchea(A4);
		
		Scorchea(Bb4);
		Scorchea(A4);
		Scorchea(Ab4);
		Scorchea(G4);
		
		Scorchea(Gb4);
		Scorchea(F4);
		Scorchea(E4);
		Scorchea(Eb4);
		//
		Corchea(Ab4);
		Negra(Db5);
		Corchea(Ab4);
		Negra(Db5);
		Negra(Ab4);
		Negra(D4);
		Corchea(Ab4);
		Negra(D4);
		Corchea(Gb4);
		Corchea(Ab4);
		
		NegraPunto(D4);
		Negra(Db4);
		Negra(B4);
		Negra(Db4);
		Negra(Db4);
		
		
		
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

ISR (TIMER0_OVF_vect)
{
	// Código de la función de interrupción.
	// No requiere limpiar el flag respectivo. El flag se limpia por hardware
}
ISR (TIMER0_COMP_vect)
{
	// Código de la función de interrupción.
	// No requiere limpiar el flag respectivo. El flag se limpia por hardware
}

