CC = xtensa-lx106-elf-gcc
CFLAGS = -I. -mlongcalls
LDLIBS = -nostdlib -Wl,--start-group -lmain -lnet80211 -lwpa -llwip -lpp -lphy -lc -Wl,--end-group -lgcc
LDFLAGS = -Teagle.app.v6.ld

brewmcu-0x00000.bin: brewmcu
	esptool.py elf2image $^

brewmcu: brewmcu.o

brewmcu.o: brewmcu.c

flash: brewmcu-0x00000.bin
	esptool.py write_flash 0 brewmcu-0x00000.bin 0x10000 brewmcu-0x10000.bin

clean:
	rm -f brewmcu brewmcu.o brewmcu-0x00000.bin brewmcu-0x10000.bin
