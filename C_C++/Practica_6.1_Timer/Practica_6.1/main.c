/*
 * Practica_6.1: Temporizador
 *
 * Created: 15/02/24
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
#define Pin_Teclado PIND
#define Puerto_teclado PORTD
#define restar_dec 0x10
#define conservar_dec 0xF0
#define conservar_uni 0x0F

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

uint8_t search(uint8_t auxPin, volatile uint8_t *j){
	switch (auxPin)
	{
		case 0xD7:
		*j=3;
		return 0;
		break;
		
		case 0xEE:
		*j=0;
		return 1;
		break;
		
		case 0xDE:
		*j=0;
		return 2;
		break;
		
		case 0xBE:
		*j=0;
		return 3;
		break;
		
		case 0xED:
		*j=1;
		return 4;
		break;
		
		case 0xDD:
		*j=1;
		return 5;
		break;
		
		case 0xBD:
		*j=1;
		return 6;
		break;
		
		case 0xEB:
		*j=2;
		return 7;
		break;
		
		case 0xDB:
		*j=2;
		return 8;
		break;
		
		case 0xBB:
		*j=2;
		return 9;
		break;
		
		case 0x77:
		*j=3;
		return 10; //Empezar
		break;
		
		default:
		return 11;
	}
	
	
}

void Teclado(volatile char *cont, volatile uint8_t *reg_N, volatile uint8_t *fg, char pad[]){
	
	Puerto_teclado|=(0xFF<<0); //estado inicial 0b11111111
	uint8_t aux;
	uint8_t j;
	
	for(int i=4; i<8; i++){
		Puerto_teclado^=(1<<i); // se pone un 0 en la posicion i
		
		if(i!=1){
			
			Puerto_teclado|=(1<<(i-1));
		}
		
		_delay_us(1);
		
		aux=search(Pin_Teclado, &j);
		
		if(aux<10 && *cont<3){ //menor igual a 2 digitos
			//mostrar en display
			
			
			if(*cont==0){
				*reg_N|=aux;
				lcd_putc(pad[aux]);
			}
			
			else if (*cont==1){
				lcd_putc(pad[aux]);
				aux=(aux<<4);
				 *reg_N|=aux;
			}
			
			
			*cont+=1;
			
			Traba(&Pin_Teclado,j); 
			
		}
		
		else if(aux==10 && *cont>1){
			*fg+=1;
			OCR0=10;
			Traba(&Pin_Teclado,j); 
			
		}			
	}
  
}
void Swap(uint8_t *reg_sum){
	uint8_t Decenas=(*reg_sum>>4);
	uint8_t Unidades=(*reg_sum<<4);
	*reg_sum&=0;
	*reg_sum|=Decenas;
	*reg_sum|=Unidades;
}

uint8_t convercion_hx_dec(uint8_t hex){
	Swap(&hex);
	uint8_t aux_sum=0;
	while(hex>=0x10){
		hex-=restar_dec;
		aux_sum+=10;
	}
	aux_sum+=hex;
	return aux_sum;
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

void move_servo(uint8_t ntimes, volatile uint8_t *fg){
	uint8_t auxCont;
	while(OCR0!=41){
		auxCont=0;
		
		if(OCR0>30){
			lcd_clrscr();
			lcd_puts("Ya mero mueres!");
		}
		
		while(auxCont<ntimes){
			_delay_ms(250);
			auxCont+=1;
		}
		OCR0+=1;
	}	
	PORTA|=(1<<0);
	PORTB|=(1<<7);
	lcd_clrscr();
	lcd_puts("Muerto!");
	delete_s(2);
}


int main(void)
{
	sei();	
	DDRD|=(0xF0<<0); //se definen como entrada D0-D3 y como Salida D4-D7
	PORTD|=(0xFF<<0); //estado inicial 0b11111111
	
	DDRC|=(0xFF<<0); //todos los pines de salida
	PORTC|=(0<<0);// inciamos en 0's
	
	DDRA|=(0xFF<<0); //todos los pines de salida
	PORTA|=(0<<0);// inciamos en 0's
	
	DDRB|=(0xFF<<0); //todos los pines de salida
	PORTB|=(0<<0);// inciamos en 0's
	
	
	//Configuracion del timer
	TIFR=3;
	TIMSK=3;
	TCNT0=0;
	TCCR0=0b01101011;
	OCR0=10; // valor para que este en 0 grados
	
	
	lcd_init(LCD_DISP_ON);
    /* Codigo principal */
	char key_pad[12]={'0','1','2','3','4','5','6','7','8','9',' ',-1};
	char contador=0;
	uint8_t reg_display=0;
	uint8_t reg_num=0;
	uint8_t flag=0;
    while (1) 
    {
		if (flag==0){
			Teclado(&contador, &reg_display, &flag, key_pad);
			//PORTC=reg_display;
		}
		
		if (flag==1){
			reg_num=convercion_hx_dec(reg_display);
			lcd_clrscr(); 
			lcd_puts("Tienes Tiempo :)");
			move_servo(reg_num, &flag);
			lcd_clrscr();
			reg_display=0;
			PORTA&=~(1<<0);
			PORTB&=~(1<<7);
			flag=0;
			contador=0;
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