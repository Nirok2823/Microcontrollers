/*
 * Titulo
 *
 * Created: Fecha
 * Author : Nombre
 */ 

#define  F_CPU 1000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
//#include <avr/interrupt.h>	 //Para poder manejar interrupciones

//PROTOTIPADO DE FUNCIONES PARA PODER UTILIZARLAS DESDE CUALQUIER "LUGAR"
//*************************************************************************
uint8_t cero_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
uint8_t uno_en_bit(volatile uint8_t *LUGAR, uint8_t BIT);
//*************************************************************************
#define conservar_dec 0xF0
#define conservar_uni 0x0F
void Swap(uint8_t *reg_sum, uint8_t *reg_Diplay){
	uint8_t Decenas=(*reg_sum>>4);
	uint8_t Unidades=(*reg_sum<<4);
	*reg_Diplay&=0;
	*reg_Diplay|=Decenas;
	*reg_Diplay|=Unidades;
}
void Sumar(uint8_t *reg_sum){
	uint8_t aux=(*reg_sum<<4);
	if(aux==0x90){
		*reg_sum&= conservar_dec;
		*reg_sum+=0x10;
	}
	else{
		*reg_sum+=1;
	}
}

void Restar(uint8_t *reg_sum){
	uint8_t aux=(*reg_sum<<4);
	if(aux==0x00){
		*reg_sum&= conservar_dec;
		*reg_sum-=0x10;
		*reg_sum+=0x09;
	}
	else{
		*reg_sum-=1;
	}
}


int main(void)
{
	DDRA|=~(0x81<<0);
	PORTA|=(0x81<<0);
	
	DDRC|=~(0<<0);
	PORTC|=(0<<0);
	uint8_t reg_suma=0;
	uint8_t reg_Display=0;
	
    /* Codigo principal */
    while (1) 
    {
		if(cero_en_bit(&PINA,0)){
			if(reg_suma<0x19){
			Sumar(&reg_suma);
			Swap(&reg_suma,&reg_Display);
			PORTC=reg_Display;
			}
			_delay_ms(50);
			while(cero_en_bit(&PINA,0)){
				
			}
			_delay_ms(50);
		}
		
		if(cero_en_bit(&PINA,7)){
			if(reg_suma>0){
			Restar(&reg_suma);
			Swap(&reg_suma,&reg_Display);
			PORTC=reg_Display;
			}
			_delay_ms(50);
			while(cero_en_bit(&PINA,7)){	
			}
			_delay_ms(50);
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

