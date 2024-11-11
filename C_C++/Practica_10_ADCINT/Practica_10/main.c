/*
 * Practica_10: Temperatura
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

volatile uint8_t dhrs=2;
volatile uint8_t uhrs=3;

volatile uint8_t dmin=5;
volatile uint8_t umin=9;

volatile uint8_t dseg=3;
volatile uint8_t useg=0;

volatile uint8_t cont=0;
volatile uint8_t flag=0;
volatile uint8_t cont_s=0;

volatile uint8_t d1=0;
volatile uint8_t d2=0;
volatile uint8_t d3=0;

volatile long temp=0;
volatile long aux=0;

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}


void digitos(long timeC, volatile uint8_t *d, volatile uint8_t *c, volatile uint8_t *m){
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

void delay_s(uint8_t seg){
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

float Temperatura(){
	return 10*(((ADCH*70)/255)-20);
}

int main(void)
{
	sei();
	
	DDRD|=~(0x0F<<0); //todos los pines de Entrada
	PORTD=0xEF;
	
	DDRB=255;
	PORTB=0;	
	
	GIFR|=(7<<5); //todas las interrupciones
	MCUCR|=(1<<1); //flanco de bajada
	GICR|=(1<<6); //para usar la interrucpion 0	
	
	ADMUX=0b01100000;
	ADCSRA=0b10111011;
	SFIOR=0b01000000;
	
	//Configuracion del timer
	TCNT0|=(0<<0); // 0b0000_0000
	TIFR|=(1<<1); // 0b0000_0011
	TIFR|=(1<<0); 
	TIMSK|=(1<<1); // 0b0000_0010
	TCCR0|=(1<<3); //
	TCCR0|=(1<<2); //
	TCCR0|=(1<<0); //0b0000_1101
	
	OCR0=243; // valor para que este en 0 grados
	
	lcd_init(LCD_DISP_ON);
	
    lcd_puts("00:00:00");
	
	
    while (1) 
    {
		lcd_gotoxy(0,0);
		lcd_putc(dhrs+48);
		lcd_putc(uhrs+48);
		lcd_gotoxy(3,0);
		
		lcd_putc(dmin+48);
		lcd_putc(umin+48);
		lcd_gotoxy(6,0);
		
		lcd_putc(dseg+48);
		lcd_putc(useg+48);
		
		if(flag==1){
			lcd_gotoxy(0,1);
			lcd_puts("Temp:");
			
			if (temp<0) lcd_putc('-');
			
			lcd_putc(d1+48);
			lcd_putc(d2+48);
			lcd_putc('.');
			lcd_putc(d3+48);
			
		}
		
		if(flag==2){
			lcd_clrscr();
			cont_s=0;
			flag=0;
			lcd_puts("00:00:00");
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

ISR (TIMER0_COMP_vect)
{
	cont+=1;
	if (cont==4){
		useg+=1;
		cont=0;
		
		if(flag==1) cont_s+=1;
		if(cont_s==5) flag=2;
		
		if(useg==10){
			useg=0;
			dseg+=1;
		}
		
		if(dseg==6){
			dseg=0;
			umin+=1;
		}
		
		if(umin==10){
			umin=0;
			dmin+=1;
		}
		
		if(dmin==6){
			dmin=0;
			uhrs+=1;
		}
		
		if(uhrs==10){
			uhrs=0;
			dhrs+=1;
		}
		
		if(dhrs==2 && uhrs==4){
			dhrs=0;
			uhrs=0;
			dmin=0;
			umin=0;
			dseg=0;
			useg=0;
		}	
	}
}


ISR (INT0_vect)
{
	//Traba(&PIND,2);
}


ISR (ADC_vect)
{
	PORTB=255;
	_delay_ms(1000);
	PORTB=0;	aux=ADCH;
	temp=((10*(aux*70)/255)-(20*10));
	flag=1;
	digitos(temp,&d1,&d2,&d3);

}



