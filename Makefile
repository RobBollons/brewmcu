CC = xtensa-lx106-elf-gcc
CFLAGS = -I. -mlongcalls
LDLIBS = -nostdlib -Wl,--start-group -lmain -lnet80211 -lwpa -llwip -lpp -lphy -lc -Wl,--end-group -lgcc
LDFLAGS = -Teagle.app.v6.ld

TARGET = brewmcu

SOURCES := $(wildcard src/*.c)
INCLUDES := $(wildcard src/*.h)
OBJECTS := $(SOURCES:src/%.c=obj/%.o)

.PHONY: clean remove tags flash

bin/$(TARGET): $(OBJECTS)
	@$(CC) $(OBJECTS) $(CFLAGS) -o $@ $(LDFLAGS) $(LDLIBS)
	@echo "Linking complete!"

$(OBJECTS): obj/%.o : src/%.c
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

bin/$(TARGET)-0x00000.bin: bin/$(TARGET)
	esptool.py elf2image $^

clean:
	@rm -rf $(OBJECTS)
	@echo "Cleanup complete!"

mkdirs:
	mkdir bin obj

remove: clean
	@rm -rf bin/$(TARGET)
	@echo "Executable removed!"

tags:
	ctags -R --fields=+iaS --extras=+q .

flash: bin/$(TARGET)-0x00000.bin
	esptool.py write_flash 0 bin/brewmcu-0x00000.bin 0x10000 bin/brewmcu-0x10000.bin
