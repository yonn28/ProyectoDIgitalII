#include "soc-hw.h"

uart_t  *uart0  = (uart_t *)   0x20000000;
timer_t *timer0 = (timer_t *)  0x30000000;
gpio_t  *gpio0  = (gpio_t *)   0x40000000;
//uart_t  *uart1  = (uart_t *)   0x20000000;
spi_t   *spi0   = (spi_t *)    0x50000000;
i2c_t   *i2c0   = (i2c_t *)    0x60000000;

isr_ptr_t isr_table[32];
/*
void prueba()
{
	   uart0->rxtx=30;
	   timer0->tcr0 = 0xAA;
	   gpio0->ctrl=0x55;
	   spi0->rxtx=1;
	   spi0->nop1=2;
	   spi0->cs=3;
	   spi0->nop2=5;
	   spi0->divisor=4;
	   i2c0->rxtx=5;
	   i2c0->divisor=5;

}
*/
void tic_isr();
/***************************************************************************
 * IRQ handling
 */
void isr_null()
{
}

void irq_handler(uint32_t pending)
{
	int i;

	for(i=0; i<32; i++) {
		if (pending & 0x01) (*isr_table[i])();
		pending >>= 1;
	}
}

void isr_init()
{
	int i;
	for(i=0; i<32; i++)
		isr_table[i] = &isr_null;
}

void isr_register(int irq, isr_ptr_t isr)
{
	isr_table[irq] = isr;
}

void isr_unregister(int irq)
{
	isr_table[irq] = &isr_null;
}

/***************************************************************************
 * TIMER Functions
 */
void msleep(uint32_t msec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000)*msec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}

void nsleep(uint32_t nsec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000000)*nsec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}


uint32_t tic_msec;

void tic_isr()
{
	tic_msec++;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;
}

void tic_init()
{
	tic_msec = 0;

	// Setup timer0.0
	timer0->compare0 = (FCPU/10000);
	timer0->counter0 = 0;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;

	isr_register(1, &tic_isr);
}


/***************************************************************************
 * UART Functions
 */
void uart_init()
{
	//uart0->ier = 0x00;  // Interrupt Enable Register
	//uart0->lcr = 0x03;  // Line Control Register:    8N1
	//uart0->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart0->div = (FCPU/(57600*16));
}

char uart_getchar()
{   
	while (! (uart0->ucr & UART_DR)) ;
	return uart0->rxtx;
}

void uart_putchar(char c)
{
	while (uart0->ucr & UART_BUSY) ;
	uart0->rxtx = c;
}

void uart_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart_putchar(*c);
		c++;
	}
}
/*******************************************************************************
 GPIO funciones primitivas
*/

char gpio_get_in1(){
	return gpio0->in1;
}

char gpio_get_in2(){
	return gpio0->in2;
}


void gpio_set_out1(char temp1)
{ 
	gpio0->out1=temp1;
 }

void gpio_set_out2(char temp2){

	gpio0->out2=temp2;
}

void gpio_set_dir1(char temp3)
{  
	gpio0->dir1=temp3;
}

void gpio_set_dir2(char temp4){

	gpio0->dir2=temp4;
}

/**********************************************************
SPI
*/



void spi_Writte(char adrr,char value){
	spi0->adressWritte=adrr;
	spi0->byteTowritte=value;
	while((spi0->statusWritte)==0x01);
}
char spi_read(char Addr){
	spi0->adressRead=Addr;
	while((spi0->statusRead)==0x01);
	return spi0->Readed;
}
void SPI_begin(){
	spi0->begin=0x01;
}

void spi_setDiv(char f){
	spi0->divisor=f;
}

/*********************************************************
I2C Conversor
*/

void ReadChanel(char ch){
	switch(ch){
	   case 0x00:
		i2c0->ByteConfigurationOne=0xC3;
	   break;
	   case 0x01:
		i2c0->ByteConfigurationOne=0xD3;
	   break;
	   case 0x02:
		i2c0->ByteConfigurationOne=0xE3;
	   break;
	   case 0x03:
		i2c0->ByteConfigurationOne=0xF3;
	   break;
	   default:
		i2c0->ByteConfigurationOne=0xC3;
	   break;
	}
	i2c0->ByteConfigurationTwo=0X83;//FS 4.096 volts although this is more than electrical especifications,there never be more than 3.6
	i2c0->Start=0x01;
	while((i2c0->Busy)==0x01);
}

char GetByteOne(){
	return i2c0->ByteReadedOne;
}
char GetByteTwo()
{
	return i2c0->ByteReadedTwo;
}






