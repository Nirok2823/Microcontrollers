/*
 * Practica_4: Dado
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
#include <avr/interrupt.h>	 //Para poder manejar interrupciones

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

uint8_t cont=0; //contador del timer
uint8_t cursor=0; //posicion de mi cursor
uint8_t flag=1; //1 estado de espera, 2 estado escribiendo
char auxChar=63; //65-90 = A-Z & 64=" "

void print_char(volatile char *aux){
	cont=0;
	TCNT0|=(0<<0); // Reiniciamos el timer y contador
	*aux+=1;
	
	if(*aux==91) *aux=64;
	
	if(*aux!=64) lcd_putc(*aux);
	
	else lcd_putc(' ');
	
	lcd_gotoxy(cursor, 0); 
	
}

//ascii 65-90 y caracter en blanco 255
int main(void)
{
	sei();
	
	TCNT0|=(0<<0); // 0b0000_0000
	TIFR|=(1<<1); // 0b0000_0011
	TIMSK|=(1<<1); // 0b0000_0010
	TCCR0|=(1<<3); //
	TCCR0|=(1<<2); //
	TCCR0|=(1<<1); //0b0000_1101
	OCR0=243;
	// Se termina de configurar el timer 
	
	DDRA|=~(1<<0); //0b1111_1110
	PORTA|=(1<<0); //0b0000_0001
	
	lcd_init(LCD_DISP_ON); // se inicializa el lcd
	lcd_command(LCD_DISP_ON_CURSOR);
	
	TCCR0=0b00001000; //Timer apagado
	
    while (1) 
    {
		if(cero_en_bit(&PINA,0)){
			
			if(TCCR0==0b00001000 && flag==1) {
				TCCR0+=5;// se activa el timer
				flag=2; // cambia  a estado escribir
			}
			
			if (cursor<16){
				print_char(&auxChar);
				
			}
			else{
				cursor=0;
				lcd_clrscr();
				flag=1;
			}
			
			Traba(&PINA,0);
		}
		
		if(flag==1 && TCCR0==0b00001101) {
			TCCR0-=5;
			TCNT0=0;
		}
		
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

ISR (TIMER0_COMP_vect )
{
	
	cont+=1;
	if(cont==4){
		cont=0; 
		flag-=1; // Si paso el tiempo regreso a estado de espera
		cursor+=1; //Aumento la posicion del cursor
		lcd_gotoxy(cursor, 0);
		auxChar=63; 
	}
	//Traba(&PINA,0);
}
