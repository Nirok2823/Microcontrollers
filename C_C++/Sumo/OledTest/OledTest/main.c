/*
 * OledTest.c
 *
 * Created: 28/05/2024 12:14:32 a. m.
 * Author : Dell
 */ 

#define  F_CPU 8000000UL
#include <avr/io.h>				//Librería general del Microcontrolador
#include <stdint.h>				//Para poder declarar varialbes especiales
#include <util/delay.h>			//Para poder hacer delays
#include <avr/pgmspace.h>
//#include "lcd.h"
#include <avr/interrupt.h>
#include "SSD1306.h"
#include "i2c.h"

int main(void) {
	
	OLED_Init();  //initialize the OLED
	OLED_Clear(); //clear the display (for good measure)
	_delay_ms(50);
	
	OLED_EnableInversion();
	
	while (1) {
		
		
		OLED_SetCursor(1, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		OLED_SetCursor(2, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		OLED_SetCursor(3, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		OLED_SetCursor(4, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		OLED_SetCursor(5, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		OLED_SetCursor(6, 0);        //set the cursor position to (0, 0)
		OLED_Printf("Hello World!"); //Print out some text
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		OLED_Clear();
		OLED_SetCursor(2, 0); 
		OLED_Printf("Awebo!");
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		OLED_Clear();
		OLED_HorizontalGraph(0,50);
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		_delay_ms(250);
		
		
		

	}
	
	return 0; // never reached
}
