#define  F_CPU 2000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include "lcd.h"
//#include <avr/interrupt.h>	 //Para poder manejar interrupciones

#define pin PINA

void hacerse_menso();
char leer1();
char leer2(char*);

int main(){
	//Teclado
	DDRA=0xF0; //salidas__entradas
	PORTA=0xFF; // 5V__Pullups
	
	//LCD
	DDRC=0xFF;
	PORTC=0;
	
	//mosi/miso/etc
	DDRB=0xFF;
	PORTB=0xFF;
	
	SPSR=0b10000001; // f=1/2
	SPCR=0b01010000;
	
	lcd_init(LCD_DISP_ON);
	char n;
	unsigned long v;
	unsigned char v1,v2;
	
	while(1){
		
		v=0;
		lcd_clrscr();
		lcd_puts("Selct Vlt");
		lcd_gotoxy(0,1);
		
		//Leemos centenas
		do{
			n=leer1();
			n=leer2(&n);
		}while(n>4);
		
		lcd_putc(n+48);
		//_delay_ms(500);
		lcd_putc('.');
		v+=100*n;
		
		//Leemos decenas
		do{
			n=leer1();
			n=leer2(&n);
		}while(n>9);
		lcd_putc(n+48);
		v+=10*n;
		
		do{
			n=leer1();
			n=leer2(&n);
		}while(n>9);
		lcd_putc(n+48);
		v+=n;
		
		v=(v*255)/500;
		//v=(v<<6);
		v1=(unsigned char) (v>>2);
		v2=(unsigned char) (v<<6);
		//v1=0b00111110;
		//v2=0b11000000;
		
		do{
			n=leer1();
			n=leer2(&n);
		}while(n!=10); //Ya para mandarlo al DAC
		
		//Parte del SPI
		PORTB&=0xEF; //Seleccionamos el esclavo
		SPDR=v1;
		while((SPSR&0x80)==0){
			//Nadotota
		}
		SPDR=v2;
		while((SPSR&0x80)==0){
			//Nadototota
		}
		PORTB=0xFF; //Le dejamos de hablar
		
		lcd_clrscr();
		lcd_puts("Listo!");
		_delay_ms(500);
		
		
	}
	
	
}

char leer1(){
	register char aux=0;
	while(1){
		
		for(char i=0; i<4; i++){
			PORTA=0xFF^(1<<(7-i)); //Se le hace XOR a los bits para apagar la fila que queremos
			_delay_us(1);
			aux=PINA;
			if((aux & 0x0F) != 0x0F){
				hacerse_menso();
				return (aux & 0x0F) | (i<<4);
			}
		}
	}
}

char leer2(char * n){
	switch(*n){
		case 0x07:{
			return 1;
		}
		case 0x0B:{
			return 2;
		}
		case 0x0D:{
			return 3;
		}
		case 0x17:{
			return 4;
		}
		case 0x1B:{
			return 5;
		}
		case 0x1D:{
			return 6;
		}
		case 0x27:{
			return 7;
		}
		case 0x2B:{
			return 8;
		}
		case 0x2D:{
			return 9;
		}
		case 0x37:{
			//return 10;
			return 17;
		}
		case 0x3B:{
			return 0;
		}
		case 0x3D:{
			//return 11;
			return 10;
		}
		default:{
			return 17;
		}
	}
}


void hacerse_menso(){
	_delay_ms(50);
	
	while(1){
		if((PINA&0x0F) == 0x0F){ break;}
	}
	
	_delay_ms(50);
}