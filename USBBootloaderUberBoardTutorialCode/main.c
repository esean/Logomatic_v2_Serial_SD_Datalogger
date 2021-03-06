//Included Libraries for the LPC2148 ARM
#include "LPC214x.h"		//Holds general addresses for the LPC2148 (Register Names, Interrupts addresses, Port Names/Numbers etc...)

//General Definitions for Code Readability
//The pin numbers were found on the UberBoard v2 Schematic
#define RED_LED		(1<<2)	//The Red LED is on Port 0-Pin 18
#define GREEN_LED	(1<<11)	//The Green LED is on Port 0-Pin 19
#define USB_LED     (1<<31)

//*******************************************************
//					Function Prototypes
//*******************************************************
void delay_ms(int count);	//Tell the compiler we are going to be using a functions called "delay_ms"

int main (void)
{
//*******************************************************
//					Initialization
//*******************************************************
IODIR0 |= RED_LED | GREEN_LED | USB_LED;	//Set the Red, Green and Blue LED pins as outputs
IOSET0 = RED_LED | GREEN_LED | USB_LED;	//Initially turn all of the LED's off

//*******************************************************
//					Main Code
//*******************************************************
while(1){	//Now that everything is initialized, let's run an endless program loop
	IOCLR0 = RED_LED;	//Turn on the Red LED
	IOSET0 = GREEN_LED;	//Make sure Green and Blue are off
	delay_ms(333);		//Leave the Red LED on for 1/3 of a second
	IOCLR0 = GREEN_LED;	//Now turn the Green LED on
	IOSET0 = RED_LED;	//and turn off Red and Blue
	delay_ms(333);		//Leave the Green LED on for 1/3 of a second
}

return 0;
}


//Usage: delay_ms(1000);
//Inputs: int count: Number of milliseconds to delay
//The function will cause the firmware to delay for "count" milleseconds.
void delay_ms(int count)
{
    int i;
    count *= 10000;
    for (i = 0; i < count; i++)	//We are going to count to 10000 "count" number of times
        asm volatile ("nop");		//"nop" means no-operation.  We don't want to do anything during the delay
}
