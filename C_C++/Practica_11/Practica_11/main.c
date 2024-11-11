/*
 * Practica_11: Memoria EEPROM
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
#define Pin_Teclado PINB
#define Puerto_teclado PORTB

uint8_t datos[4]={0,0,0,0};
uint8_t new_dat;

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

void EEPROM_write(uint8_t Dir, uint8_t Dat)
{
	while(uno_en_bit(&EECR,EEWE)){}
		
	EEAR=Dir;
	EEDR=Dat;
	//cli();
	
	EECR|=(1<<EEMWE);
	EECR|=(1<<EEWE);
	
	//sei();
}

uint8_t EEPROM_read(uint8_t Dir)
{
	while(uno_en_bit(&EECR,EEWE)){}
	
	EEAR=Dir;
	EECR|=(1<<EERE);
	return EEDR;
}

void ini_eeprom(){
	for(int i=0; i<4; i++){
		datos[i]=EEPROM_read(i);
	}
	lcd_gotoxy(0,0);
	for(int i=0; i<4; i++){
		lcd_putc(datos[i]+48);
	}
}

void refresh_eeprom(){
	for(int i=0; i<4; i++){
		datos[i]=EEPROM_read(i);
	}
	for(int i=0; i<4; i++){
		
		if(i==0)EEPROM_write(i, new_dat);
		else{
			EEPROM_write(i, datos[i-1]);
		}
	}
	for(int i=0; i<4; i++){
		datos[i]=EEPROM_read(i);
	}
	lcd_gotoxy(0,0);
	for(int i=0; i<4; i++){
		lcd_putc(datos[i]+48);
	}
}

void Teclado(){
	uint8_t aux=20;
	Puerto_teclado|=(0xFF<<0); //estado inicial 0b11111111
	
	for(int i=0; i<4; i++){
		Puerto_teclado^=(1<<i); // se pone un 0 en la posicion i
		
		if(i!=0){
			
			Puerto_teclado|=(1<<(i-1));
		}
		
		_delay_us(1);
		
		for(int j=4; j<8; j++){
			
			switch(i){
				case 0:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
						aux=1;//1
						
						Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
						aux=2;//print 2
						
						Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
						aux=3;//print 3
						
						Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
				
				case 1:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=4;//4
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=5;//print 5 
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=6;//print 6
					
					Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
				
				case 2:
				
				switch (j){
					
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=7;//7
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=8;//print 8
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=9;//print 9
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
				}
				break;
				
				case 3:
				
				switch (j){
								
					case 5:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux=0;//print 0
					
					Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
			}
			
		}
  }
  if (aux!=20){
	  new_dat=aux;
	  refresh_eeprom();
  }
}




int main(void)
{
	DDRB|=(0x0F<<0); //se definen como entrada A0-A3 y como salida A4-A6
	PORTB|=(0xFF<<0); //estado inicial 0b11111111
	lcd_init(LCD_DISP_ON);
    /* Codigo principal */
	//uint8_t cont=0;
	ini_eeprom();
    while (1) 
    {
		Teclado();
		
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

