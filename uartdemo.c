#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include "uartstream.h"



volatile uint8_t delayCounter;	// Ticks remaining counter

/*
 * Timer0 overflow interrupt
 */

ISR(TIMER0_OVF_vect)
{
	if(delayCounter) delayCounter--;
}


int main (void)
{
	/* set pin 5 of PORTB for output*/
	DDRB |= _BV(DDB5);
	/* Set up timer 0 for 1.024ms interrupts */
	TCCR0B |= (_BV(CS01) | _BV(CS00)); // Prescaler 16000000/64 =  250KHz
	TIMSK0 |= _BV(TOIE0); // Enable timer overflow interrupt
	TCNT0 = 0; // Zero out the timer
	
	/* Initialize UART */
	stdout = stdin = uartstream_init(9600);
	
	
	sei(); // Enable global interrupts
 
	while(1) {
		char buffer[32];
		fgets(buffer, 31, stdin);
		printf("%s", buffer);
	
	}
 
 return 0;
}
