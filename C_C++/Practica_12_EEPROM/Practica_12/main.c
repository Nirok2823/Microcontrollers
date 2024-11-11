/*
 * Practica_12: Memoria EEPROM y timer
 *
 * Created: 14/03/24
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
#define Pin_Teclado PINB
#define Puerto_teclado PORTB

uint8_t dato;
uint8_t new_dat;
uint8_t flag=0;
int dir=0;
int tope=0;
int conversion=0;
uint8_t medicion;
uint8_t cen,dec,uni;


void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

void digitos(long timeC, uint8_t *d, uint8_t *c, uint8_t *m){
	if(timeC<0){
		timeC*=-1;
	}
	
	*d=(timeC/100);
	while(timeC>=100){
		timeC-=100;
	}
	*c= (timeC/10);
	while(timeC>=10){
		timeC-=10;
	}
	*m=timeC;
}

void EEPROM_write(uint8_t Dir, uint8_t Dat)
{
	while(uno_en_bit(&EECR,EEWE)){}
		
	EEAR=Dir;
	EEDR=Dat;
	cli();
	
	EECR|=(1<<EEMWE);
	EECR|=(1<<EEWE);
	
	sei();
}

uint8_t EEPROM_read(uint8_t Dir)
{
	while(uno_en_bit(&EECR,EEWE)){}
	
	EEAR=Dir;
	EECR|=(1<<EERE);
	return EEDR;
}
/*
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

void _fill_array(){
	for(int i=0; i<512; i++){
		datos[i]=0;
	}
}
*/
void print_from_eeprom(){
	lcd_clrscr();
	lcd_puts("Dir:");
	digitos(dir,&cen,&dec,&uni);
	lcd_putc(cen+48);
	lcd_putc(dec+48);
	lcd_putc(uni+48);
	lcd_gotoxy(0,1);
	dato=EEPROM_read(dir);
	digitos(dato,&cen,&dec,&uni);
	lcd_putc(dec+48);
	lcd_putc('.');
	lcd_putc(uni+48);
	lcd_putc('v');
}
void Teclado(){
	char aux='?';
	Puerto_teclado|=(0xFF<<0); //estado inicial 0b11111111
	
	for(int i=0; i<4; i++){
		Puerto_teclado^=(1<<i); // se pone un 0 en la posicion i
		
		if(i!=0){
			
			Puerto_teclado|=(1<<(i-1));
		}
		
		_delay_us(1);
		
		for(int j=4; j<8; j++){
			
			switch(i){
				case 3:
				
				switch (j){
								
					case 4:
					if(cero_en_bit(&Pin_Teclado,j)){
					aux='<';//print >
					
					Traba(&Pin_Teclado,j);
					}
					break;
					
					case 6:
					if(cero_en_bit(&Pin_Teclado,j)){
						aux='>';//print <
						
						Traba(&Pin_Teclado,j);
					}
					break;
					
					case 7:
					if(cero_en_bit(&Pin_Teclado,j)){
						aux='+';//print +
						
						Traba(&Pin_Teclado,j);
					}
					break;
				}
				break;
			}
			
		}
  }
  
  if(aux=='+'&& flag==0){
	  TCCR0-=5;
	  flag=1;
	  dir-=1;
	  tope=dir;
	  // se apaga el timer para que no se entre en la interrupcion
	  print_from_eeprom();
  }
  else if(aux=='<' && flag==1){
	  dir-=1;
	  if(dir<0){
		  dir=-1;
		  lcd_clrscr();
		  lcd_puts("Sin lectura");
	  }
	  else print_from_eeprom();
  }
  
  else if(aux=='>' && flag==1){
	  dir+=1;
	  if(dir>tope){
		  dir=tope+1;
		lcd_clrscr();
		lcd_puts("Sin lectura");
	  }
	  else print_from_eeprom();
  }
  else if(aux=='+'&& flag==1){
	  TCNT0=0;
	  TCCR0+=5;
	  flag=0;
	  dir=0;
	  tope=0;
	  lcd_clrscr();
	  lcd_puts("Sensando...");
  }
  
}




int main(void)
{
	sei();
	DDRB|=(0x0F<<0); //se definen como entrada A0-A3 y como salida A4-A6
	PORTB|=(0xFF<<0); //estado inicial 0b11111111
	
	//Adc
	ADMUX=0b01100000;
	ADCSRA=0b10111011;
	SFIOR=0b01100000;// trigger con el timer comp 0;
	//
	
	//Timer
	TCNT0|=(0<<0); // 0b0000_0000
	TIFR|=(1<<1); // 0b0000_0011
	TIFR|=(1<<0);
	TIMSK|=(1<<1); // 0b0000_0010
	TCCR0|=(1<<3); //
	TCCR0|=(1<<2); //
	TCCR0|=(1<<0); //0b0000_1101
	OCR0=243;
	lcd_init(LCD_DISP_ON);
    /* Codigo principal */
	//uint8_t cont=0;
	//ini_eeprom();
	//_fill_array();
	lcd_puts("Sensando...");
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

ISR (TIMER0_COMP_vect){
	
}

ISR (ADC_vect)
{
	if(dir>=512){
		dir=512;
		lcd_clrscr();
		lcd_puts("EEPROM Llena");
		
	}
	else{
		medicion=ADCH;
		conversion=medicion*50;
		conversion/=255;
		EEPROM_write(dir,conversion);
		dir+=1;
	}
	
	
}


