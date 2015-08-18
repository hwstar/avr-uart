avr-uart
========

An interrupt-driven UART Library for 8-bit AVR microcontrollers and stream support for printf/scanf

Derived from work by Peter Fleury, Andy Gock.
This is a fork of https://github.com/andygock/avr-uart

This fork provides one extra function uartstream_init() and sets the receive and TX buffers to 16 bytes.

FILE *uartstream_init(uint32_t baudrate)

Initializes uart #0 baud rate and interrupt handler. Returns a file handle pointer which can be used
for both reading and writing.

Once you have the file handle, you can assign it to stdout and stdin so that libc functions
such as printf() and scanf() can be used send and receive data using the uart.



 
