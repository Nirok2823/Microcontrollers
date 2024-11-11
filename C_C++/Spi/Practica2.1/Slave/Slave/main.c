#define  F_CPU 2000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays

int main(){
	
	//Puerto ADC
	DDRA=0; //Todas entradas
	
	//Puerto miso/mosi
	DDRB=0x40;
	PORTB=0xBF;
	
	SPSR=0b10000001; //SPI2X=1
	SPCR=0b01100100; //Frecuecnia de 1/2
	
	ADMUX=0b01100000;
	ADCSRA=0b10010011;
	
	unsigned char v;
	char pot=0;
	
	while(1){
		
		while(PIND&0x10){
			//No hace nada en lo que lo llaman
		}
		
		while((SPSR&0x80)==0){
			//Nada en lo que le acaban de decir qué hacer
		}
		
		//Aquí ponemos çuál patita del ADC se va a leer
		pot=SPDR;
		
		ADMUX&=0xE0;
		if(pot==2){
			ADMUX|=7;
		}
		
		
		ADCSRA|=(1<<ADSC);
		while(ADCSRA&0x40){
			//Nadotota
		}
		v=ADCH;
		SPDR=v;
		
		while(PIND&0x10){
			//Nada
		}
		
		while((SPSR&0x80)==0){
			//Ni maíz
		}
		
	}
	
}
