#
# User-specified variables
#

# Programmer type for avrdude

PROGRAMMER = arduino	# Use arduino boot loader

# Serial port device name

SERIALPORT = /dev/ttyUSB0

# Serial port baud rate

BAUDRATE = 57600

# Project name

PROJECT  = uartdemo

# Project object files
# The first one is mandatory, add more .o files separated by spaces.

OBJS           = $(PROJECT).o uartstream.o uart.o

# Optimization

OPTIMIZE       = -O2

# CPU clock frequency

DEFS           = -DF_CPU=16000000

# Libraries

LIBS           =


# Set one and only one of these

#MCU_TARGET     = at90s2313
#MCU_TARGET     = at90s2333
#MCU_TARGET     = at90s4414
#MCU_TARGET     = at90s4433
#MCU_TARGET     = at90s4434
#MCU_TARGET     = at90s8515
#MCU_TARGET     = at90s8535
#MCU_TARGET     = atmega128
#MCU_TARGET     = atmega1280
#MCU_TARGET     = atmega1281
#MCU_TARGET     = atmega1284p
#MCU_TARGET     = atmega16
#MCU_TARGET     = atmega163
#MCU_TARGET     = atmega164p
#MCU_TARGET     = atmega165
#MCU_TARGET     = atmega165p
#MCU_TARGET     = atmega168
MCU_TARGET = atmega328p
#MCU_TARGET     = atmega169
#MCU_TARGET     = atmega169p
#MCU_TARGET     = atmega2560
#MCU_TARGET     = atmega2561
#MCU_TARGET     = atmega32
#MCU_TARGET     = atmega324p
#MCU_TARGET     = atmega325
#MCU_TARGET     = atmega3250
#MCU_TARGET     = atmega329
#MCU_TARGET     = atmega3290
#MCU_TARGET     = atmega48
#MCU_TARGET     = atmega64
#MCU_TARGET     = atmega640
#MCU_TARGET     = atmega644
#MCU_TARGET     = atmega644p
#MCU_TARGET     = atmega645
#MCU_TARGET     = atmega6450
#MCU_TARGET     = atmega649
#MCU_TARGET     = atmega6490
#MCU_TARGET     = atmega8
#MCU_TARGET     = atmega8515
#MCU_TARGET     = atmega8535
#MCU_TARGET     = atmega88
#MCU_TARGET     = attiny2313
#MCU_TARGET     = attiny24
#MCU_TARGET     = attiny25
#MCU_TARGET     = attiny26
#MCU_TARGET     = attiny261
#MCU_TARGET     = attiny44
#MCU_TARGET     = attiny45
#MCU_TARGET     = attiny461
#MCU_TARGET     = attiny84
#MCU_TARGET     = attiny85
#MCU_TARGET     = attiny861

#
# End of user-specified variables
#

CC             = avr-gcc


.PHONY:	clean burn

override CFLAGS        = -g -Wall $(OPTIMIZE) -mmcu=$(MCU_TARGET) $(DEFS)
override LDFLAGS       = -Wl,-Map,$(PROJECT).map

OBJCOPY        = avr-objcopy
OBJDUMP        = avr-objdump

all: $(PROJECT).elf lst text eeprom

# Linking rule

$(PROJECT).elf: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
	avr-size $@ -A

# How to turn .c files into .o files
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# Remove all non-source files

clean:
	rm -rf *.o $(PROJECT).elf *.eps *.png *.pdf *.bak 
	rm -rf *.lst *.map $(EXTRA_CLEAN_FILES)

# Burn the hex file using avrdude

burn: all
	-killall gtkterm
	-sleep 1
	avrdude -F -V -c $(PROGRAMMER) -p $(MCU_TARGET) -P $(SERIALPORT) -U flash:w:$(PROJECT).hex -b $(BAUDRATE)


lst:  $(PROJECT).lst

%.lst: %.elf
	$(OBJDUMP) -h -S $< > $@

# Rules for building the .text rom images

text: hex

hex:  $(PROJECT).hex


%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

%.srec: %.elf
	$(OBJCOPY) -j .text -j .data -O srec $< $@

%.bin: %.elf
	$(OBJCOPY) -j .text -j .data -O binary $< $@


eeprom: ehex

ehex:  $(PROJECT)_eeprom.hex


%_eeprom.hex: %.elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@ \
	|| { echo empty $@ not generated; exit 0; }


FIG2DEV                 = fig2dev
EXTRA_CLEAN_FILES       = *.hex *.bin *.srec

dox: eps png pdf

eps: $(PROJECT).eps
png: $(PROJECT).png
pdf: $(PROJECT).pdf

%.eps: %.fig
	$(FIG2DEV) -L eps $< $@

%.pdf: %.fig
	$(FIG2DEV) -L pdf $< $@

%.png: %.fig
	$(FIG2DEV) -L png $< $@
