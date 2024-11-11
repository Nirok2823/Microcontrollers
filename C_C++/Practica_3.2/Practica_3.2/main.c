/*
 * Practica_3.2: teclado y LCD
 *
 * Created: 02/02/24
 * Author : Andre Nicasio Romo
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
#include "lcd.h"
//#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************
#define Pin_Teclado PINA
#define Puerto_teclado PORTA

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

uint8_t search(uint8_t auxPin, volatile uint8_t *j){
	switch (auxPin)
	{
		case 0xEB:
		*j=4;
		return 0;
		break;
		
		case 0x77:
		*j=7;
		return 1;
		break;
		
		case 0x7B:
		*j=7;
		return 2;
		break;
		
		case 0x7D:
		*j=7;
		return 3;
		break;
		
		case 0xB7:
		*j=6;
		return 4;
		break;
		
		case 0xBB:
		*j=6;
		return 5;
		break;
		
		case 0xBD:
		*j=6;
		return 6;
		break;
		
		case 0xD7:
		*j=5;
		return 7;
		break;
		
		case 0xDB:
		*j=5;
		return 8;
		break;
		
		case 0xDD:
		*j=5;
		return 9;
		break;
		
		case 0xE7:
		*j=4;
		return 10; //borrar 1
		break;
		
		case 0xED:
		*j=4;
		return 11; //borrar todo
		break;
	}
	return 20;
}

void Teclado(volatile uint8_t *cont, char key_pad[]){
	
	Puerto_teclado|=(0xFF<<0); //estado inicial 0b11111111
	uint8_t aux;
	uint8_t j;
	
	for(int i=1; i<4; i++){
		Puerto_teclado^=(1<<i); // se pone un 0 en la posicion i
		
		if(i!=1){
			
			Puerto_teclado|=(1<<(i-1));
		}
		
		_delay_us(1);
		
		aux=search(Pin_Teclado, &j);
		
		if(aux<10 && *cont<10){
			lcd_putc(key_pad[aux]);
			*cont+=1;
			Traba(&Pin_Teclado,j); 
		}
		else if(aux==10 && *cont!=0){
			lcd_gotoxy((*cont-1),0);
			lcd_putc(key_pad[aux]);
			*cont-=1;
			lcd_gotoxy((*cont),0);
			Traba(&Pin_Teclado,j);
		} 
		
		else if(aux==11){
			lcd_clrscr();
			*cont=0;
			lcd_gotoxy((*cont),0);
			Traba(&Pin_Teclado,j);
		}
				
	}
  
}


int main(void)
{
	DDRA|=(0x0F<<0); //se definen como entrada A0-A3 y como salida A4-A6
	PORTA|=(0xFF<<0); //estado inicial 0b11111111
	lcd_init(LCD_DISP_ON);
    /* Codigo principal */
	char key_pad[12]={'0','1','2','3','4','5','6','7','8','9',' ',-1};
	uint8_t cont=0;
    while (1) 
    {
		Teclado(&cont, key_pad);
		
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

