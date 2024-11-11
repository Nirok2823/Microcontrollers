#define  F_CPU 2000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
//#include <avr/interrupt.h>	 //Para poder manejar interrupciones
#include "lcd.h"

#define pin PINC

void imp(char, char, unsigned int);
void hacerse_menso();

int main(){
	
	//LCD
	DDRD=0xFF;
	PORTD=0;
	
	//Botones
	DDRC=0;
	PORTC=0xFF; //Pullup a todas
	
	//SS
	DDRA=0xFF;
	PORTA=0xFF;
	
	//mosi,miso,sck
	DDRB=0xA0; //Salida - Entrada - Salida
	PORTB=0x40; //Entrada - Salida - Entrada
	
	
	SPSR=0b10000001; //SPI2X=1
	SPCR=0b01110100; //Frecuecnia de 1/2
	
	lcd_init(LCD_DISP_ON);
	lcd_clrscr();
	lcd_puts("Spi -> <-\nBidireccional");
	
	char btn, esc, pot;
	unsigned int v;
	
	while(1){
		do{
			btn=PINC;
		}while(btn==0xFF);
		
		hacerse_menso();
		
		switch(btn){
			case 0xFE:{
				pot=1;
				esc=0xBF; //Esclavo del bit 6
				break;
			}
			case 0xFB:{
				pot=2;
				esc=0xBF;
				break;
			}
			case 0xEF:{
				pot=1;
				esc=0x7F; //Esclavo del bit 7
				break;
			}
			case 0xBF:{
				pot=2;
				esc=0x7F;
				break;
			}
			default:{
				continue;
				esc=0xFF;
				pot=0;
				break;
			}
		}
		
		PORTA=esc;
		
		SPDR=pot;	//Mandamos qué pot queremos
		while((SPSR&0x80)==0){
			//Nadota en lo que el SPIF sea 0
		}
		PORTA=0xFF;
		
		_delay_ms(250); //Nos aguantamos tantito en lo que chambea el ADC
		
		PORTA=esc;
		SPDR=0;		//Mandamos 0 para leer lo que nos va a mandar el otro
		while((SPSR&0x80)==0){
			//nadotota
		}
		PORTA=0xFF; //Le dejamos de hablar
		
		
		v=SPDR;		//Guardamos el dato
		v=(v*50)/255;
		imp(pot,esc,v);
		
		
	}
	
}


void imp(char pot, char esc, unsigned int v){
	
	char esclavo;
	
	if(esc==0xBF){
		esclavo='6';
		}else{
		esclavo='7';
	}
	
	lcd_clrscr();
	lcd_puts("Pot:");
	lcd_putc(pot + 48);
	lcd_puts(" Esclavo:");
	lcd_putc(esclavo);
	lcd_gotoxy(0,1);
	lcd_puts("Voltios: ");
	lcd_putc((v/10) + 48);
	lcd_putc('.');
	lcd_putc((v%10)+48);
	lcd_puts(" V");
	

}

void hacerse_menso(){
	_delay_ms(50);
	while(pin!=0xFF){
		//Se hace menso
	}
	_delay_ms(50);
}