#include <avr/interrupt.h>
#include "uartstream.h"


int main (void)
{

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
