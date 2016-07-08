#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      100000000

#define UART_RXBUFSIZE 32


/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
	volatile uint32_t tcr0;
	volatile uint32_t compare0;
	volatile uint32_t counter0;
	volatile uint32_t tcr1;
	volatile uint32_t compare1;
	volatile uint32_t counter1;
} timer_t;

void msleep(uint32_t msec);
void nsleep(uint32_t nsec);

void prueba();
void tic_init();


/***************************************************************************
 * GPIO0
 */
#define PIN1 0x01
#define PIN1 0x02
#define PIN1 0x04
#define PIN1 0x10



typedef struct {
	volatile uint32_t in1;
	volatile uint32_t in2;
	volatile uint32_t out1;
	volatile uint32_t out2;
	volatile uint32_t dir1;
	volatile uint32_t dir2;
	
} gpio_t;

char gpio_get_in1();
char gpio_get_in2();
char gpio_get_dir1();
char gpio_get_dir2();
void gpio_set_out1(char temp1);
void gpio_set_out2(char temp2);
void gpio_set_dir1(char temp3);
void gpio_set_dir2(char temp4);




/***************************************************************************
 * UART0
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart_init();
void uart_putchar(char c);
void uart_putstr(char *str);
char uart_getchar();

/***************************************************************************
 * SPI0
 */


typedef struct {
   volatile uint32_t Readed;//00000
   volatile uint32_t statusWritte;// 00100 //16 8 4 2 1//4
   volatile uint32_t statusRead; // 01000 //16 8 4 2 1 //8
   volatile uint32_t adressWritte; // 01100 //16 8 4 2 1 //12
   volatile uint32_t byteTowritte; 
   volatile uint32_t adressRead;
   volatile uint32_t begin;
   volatile uint32_t divisor;
} spi_t;

void spi_Writte(char adrr,char value);
char spi_read(char Addr);
void SPI_begin();
void spi_setDiv(char f);


/***************************************************************************
 * I2C0
 */

/*
Busy
ByteReadedOne
ByteReadedTwo
ByteConfigurationOne
ByteConfigurationTwo
Start
*/

typedef struct {
   volatile uint32_t Busy;
   volatile uint32_t ByteReadedOne;
   volatile uint32_t ByteReadedTwo;
   volatile uint32_t ByteConfigurationOne;
   volatile uint32_t ByteConfigurationTwo;
   volatile uint32_t Start;
} i2c_t;

void ReadChanel(char ch);
char GetByteOne();
char GetByteTwo();

/*********************************************************************
display
*/

typedef struct {
	volatile uint32_t bcd1;
	volatile uint32_t bcd2;	
        volatile uint32_t bcd3;
	volatile uint32_t bcd4;
	volatile uint32_t bcd5;
	volatile uint32_t bcd6;
	volatile uint32_t bcd7;
	volatile uint32_t bcd8;
	volatile uint32_t point;
	
}Display_t;

void SetDisplay(char Display,char value);
void SetDpDisplay(char display);

/***************************************************************************
 * Pointer to actual components
 */
extern timer_t  *timer0;
extern uart_t   *uart0; 
extern gpio_t   *gpio0; 
extern uint32_t *sram0; 

#endif // SPIKEHW_H
