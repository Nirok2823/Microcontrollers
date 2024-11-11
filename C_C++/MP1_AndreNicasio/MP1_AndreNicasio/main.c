/*
 * Examen Parcial 1
 *
 * Created: 22/02/24
 * Author : Andre Nicasio Romo
 */ 
#define  F_CPU 4000000UL
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

uint8_t flag_int=0;
uint8_t randomN=0;
uint8_t otro_rd=0;
int tiempo_ms=0;
uint8_t unidad, decima, centecima, milesima;

void Traba(volatile uint8_t *Lugar, uint8_t Bit){
	_delay_ms(50);
	while(cero_en_bit(&*Lugar, Bit)){}
	_delay_ms(50);
}

void delay_s(uint8_t seg){
	uint8_t auxCont;
	uint8_t aux_seg=0;
	
	while(aux_seg<seg){
		auxCont=0;
		if (flag_int==0) break;
		while (auxCont<16){
			if (flag_int==0) break;
			_delay_us(62500);
			auxCont+=1;
		}
		aux_seg+=1;
	}
}

void digitos(int timeC, uint8_t *u, uint8_t *d, uint8_t *c, uint8_t *m){
	*u= (timeC/1000); //valor de la unidad
	while(timeC>=1000){
		timeC-=1000;
	}
	*d= timeC/100;
	while(timeC>=100){
		timeC-=100;
	}
	*c= timeC/10;
	while(timeC>=10){
		timeC-=10;
	}
	*m=timeC;
}

void reiniciar(){
	PORTD^=(1<<7); //Apagamos el led en D7
	TCCR0-=5; //Se desactia el timer
	TCNT0=0; //se reinicia el contador
	lcd_clrscr();
	tiempo_ms=0;
	flag_int=0;
}


int main(void)
{
	sei();
	
	DDRD|=(0xFF<<0);
	DDRD^=(1<<2); // se declara como Entrada el d2
	PORTD|=(1<<2); //pull up en el boton de la interrupcion
	
	// interrupciones en d2
	GIFR|=(7<<5); //todas las interrupciones
	MCUCR|=(1<<3); //flanco de bajada
	GICR|=(1<<6); //para usar la interrucpion 0
	//
	
	TCNT0|=(0<<0); // 0b0000_0000
	TIFR|=(1<<1); // 0b0000_0011
	TIMSK|=(1<<1); // 0b0000_0010
	TCCR0=0b00001101; //0b0000_1101 prescaler de 1024 y modo cnt para contar de 1ms en un ms
	OCR0=3; //para contar de un ms en un ms
	// Se termina de configurar el timer 
	
	
	
	lcd_init(LCD_DISP_ON); // se inicializa el lcd
	//lcd_command(LCD_DISP_ON_CURSOR);
	
	TCCR0=0b00001000; //Timer apagado
	
	
    while (1) 
    {
		if( flag_int == 0 ){
			lcd_puts("Iniciando...");
			while(flag_int==0){
				randomN=2;
				while (randomN<11)
				{
					randomN+=1;
				}
			}
				
		}
		
		if( flag_int==1){
			lcd_clrscr();
			lcd_gotoxy(0,1);
			lcd_puts("Listo?");
			delay_s(otro_rd);
			if(flag_int!=0){
			lcd_clrscr();
			PORTD|=(1<<7); //prendemos el led en D7
			TCCR0+=5; //Se activa el timer
			while(flag_int==1){ //me hago menso a la espera de presionar el boton
				if(tiempo_ms==4000){
					flag_int=2;
					lcd_gotoxy(3,1);
					lcd_puts("Excediste tpo.");
					delay_s(2);
					reiniciar();
					
				}
			}
			
			}
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
	tiempo_ms+=1;
}

ISR (INT0_vect)
{
	
	if(flag_int==0){
		otro_rd=randomN;
	    flag_int+=1;
		TCNT0=0;
	}
	
	else if (flag_int == 1){
		if(cero_en_bit(&PIND,7)){
			lcd_clrscr();
			lcd_puts("Todavia no!!");
			PORTD|=(1<<7);
			delay_s(1);
			PORTD^=(1<<7);
			delay_s(1);
			PORTD|=(1<<7);
			delay_s(1);
			PORTD^=(1<<7);
			delay_s(1);
			PORTD|=(1<<7);
			delay_s(1);
			PORTD^=(1<<7);
			delay_s(1);
			TCNT0=0; //se reinicia el contador
			lcd_clrscr();
			tiempo_ms=0;
			flag_int=0;
			
		}
		else{
			TCCR0-=5; //Se desactia el timer
			digitos(tiempo_ms, &unidad,&decima,&centecima,&milesima);
			lcd_gotoxy(5,0);
			lcd_puts("Tpo:");
			lcd_putc(unidad+48);
			lcd_putc('.');
			lcd_putc(decima+48);
			lcd_putc(centecima+48);
			lcd_putc(milesima+48);
			lcd_puts("s.");
			delay_s(2);
			//reiniciar();
			PORTD^=(1<<7); //Apagamos el led en D7
			
			TCNT0=0; //se reinicia el contador
			lcd_clrscr();
			tiempo_ms=0;
			flag_int=0;
			
		}
		
	}
	Traba(&PIND,2);
	// Código de la función de interrupción.
	// No requiere limpiar el flag respectivo. El flag se limpia por hardware
}

