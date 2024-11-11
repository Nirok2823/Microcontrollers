/*
 * Practica_3.1: teclado y LCD
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

void Teclado(volatile uint8_t *cont){
	
	Puerto_teclado|=(0xFF<<0); //estado inicial 0b11111111
	
	if (*cont<10)
	{
	
	for(int i=1; i<4; i++){
		Puerto_teclado^=(1<<i); // se pone un 0 en la posicion i
		
		if(i!=1){
			
			Puerto_teclado|=(1<<(i-1));
		}
		
		_delay_us(1);
		
		for(int j=4; j<8; j++){
			
			switch(i){
				
				case 1:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_clrscr();//limpiar
					*cont=0;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('9');//print 9
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('6');//print 6
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 7:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('3');//print 3
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
				
				case 2:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('0');//0
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('8');//print 8
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('5');//print 5
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 7:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('2');//print 2
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
				
				case 3:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
						lcd_gotoxy((*cont-1),0);  
						lcd_putc(' ');//0
						*cont-=1;
						lcd_gotoxy((*cont),0); 
						Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('7');//print 7
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('4');//print 4
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 7:
					if(cero_en_bit(&Pin_Teclado,j)){
					lcd_putc('1');//print 1
					*cont+=1;
					Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
			}
			
		}
	}
  }
  else{
	  Puerto_teclado=0b11111101;
	  _delay_us(1);
	  
	  if (cero_en_bit(&Pin_Teclado,4))
	  {
		  lcd_clrscr();
		  *cont=0;
		  Traba(&Pin_Teclado,4);
	  }
	  
	  Puerto_teclado=0b11110111;
	  _delay_us(1);
	  
	  if(cero_en_bit(&Pin_Teclado,4)){
		  lcd_gotoxy((*cont-1),0);
		  lcd_putc(' ');
		  *cont-=1;
		  lcd_gotoxy((*cont),0);
		  Traba(&Pin_Teclado,4);
	  }
	  
  }
}




int main(void)
{
	DDRA|=(0x0F<<0); //se definen como entrada A0-A3 y como salida A4-A6
	PORTA|=(0xFF<<0); //estado inicial 0b11111111
	lcd_init(LCD_DISP_ON);
    /* Codigo principal */
	uint8_t cont=0;
    while (1) 
    {
		Teclado(&cont);
		
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

