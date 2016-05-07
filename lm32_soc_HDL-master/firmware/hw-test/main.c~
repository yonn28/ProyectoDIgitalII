/**
 * 
 */

#include "soc-hw.h"


int main()
{
	/*
	char a;
	while(1){
		a=uart_getchar();
		uart_putchar(a);

	}
	*/
	/*
	char name;
	while(1){
		name=uart_getchar();
 		switch (name){
		 case'n':
			uart_putstr("james");
			break;
		case'p':
			uart_putstr( "rodig");
			break;
		case'c':
			uart_putstr( "5461561165");
			break;

		}
			
	}
	*/
//---------------------------------------------------------------------------	
	//gpio_set_dir(0xFF);//uncomented in order to use blink




	
	/*
	// blink works
	unsigned  int  time;
	unsigned  int time2;

	while(1){
		
		for(time=50000; time>0; time--){gpio_set_out(0xFF);}
		for(time2=50000; time2>0; time2--){gpio_set_out(0x00);}
	}
	*/
	/*
	unsigned  int  time;
	while(1){
		for(time=500000; time>0; time--){gpio_set_out(0x01);}
		for(time=500000; time>0; time--){gpio_set_out(0x02);}
		for(time=500000; time>0; time--){gpio_set_out(0x04);}
		for(time=500000; time>0; time--){gpio_set_out(0x08);}
		for(time=500000; time>0; time--){gpio_set_out(0x10);}
		for(time=500000; time>0; time--){gpio_set_out(0x20);}
		for(time=500000; time>0; time--){gpio_set_out(0x40);}
		for(time=500000; time>0; time--){gpio_set_out(0x80);}

	}
	*/
	/*
	char name;
	while(1){
		name=uart_getchar();
 		switch (name){
		case'a':
			gpio_set_out(0x01);
			break;
		case's':
			gpio_set_out(0x02);
			break;
		case'd':
			gpio_set_out(0x04);
			break;
		case'f':
			gpio_set_out(0x08);
			break;
		case'g':
			gpio_set_out(0x10);
			break;
		case'h':
			gpio_set_out(0x20);
			break;
		case'j':
			gpio_set_out(0x40);
			break;
		case'k':
			gpio_set_out(0x80);
			break;
		default:
			uart_putstr( "invalido");
			break;			

		}
		name=name;
	}
	*/		
//-----------------------------------------------------------------------------	
/*
	gpio_set_dir(0xF0);
	
	char b;
	char output;

	while(1){
	output=(gpio_get_in());
	b=output<<4;	
	gpio_set_out(b);

	}
	*/
//--------------------------------------------------------------------
//spi TEST 
	/*	
   	char b;
	spi_setDiv(0x05);
	spi_set_CS(0x01);
	spi_send(0x64);
	b=spi_getChar();
	spi_send(b);

	*/
	//this spi works temperature
	
	
	gpio_set_dir(0xFF);
	SPI_begin();
	spi_Writte(0x80,0xE6);
	while(1){
		char a=spi_read(0x02);// most significative bite
		char b=spi_read(0x01);
		gpio_set_out(b);
		uart_putstr("most sig");
		uart_putchar(" "+a);
		uart_putstr("less sig");
		uart_putchar(""+b);
	}

}




