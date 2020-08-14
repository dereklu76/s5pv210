CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
CP=arm-none-eabi-objcopy
LDSCRIPT=gboot.lds
MKV210=../doc/mkv210

all : gboot210.bin gboot.bin gboot.elf  

gboot210.bin : gboot.bin
	$(MKV210) $< $@

gboot.bin : gboot.elf
	$(CP) -O binary gboot.elf gboot.bin

gboot.elf : start.o
	$(LD) -T$(LDSCRIPT) $^ -o $@

%.o : %.S
	$(CC) -c -g $^

%.o : %.c
	$(CC) -c -g $^

.PHONY : all clean

clean:
	rm -rf *.o *.elf *.bin
