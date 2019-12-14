
CC = sdcc
AS = sdasz80
LD = sdldz80
IHEX2CMD = ./ihex2cmd/ihex2cmd
CFLAGS = -mz80 --std-sdcc99 --opt-code-size --vc -I./fat32
ASFLAGS = -l
LDFLAGS = -mjwx -b _CODE=0x5200 -l $(SDCC_PATH)/lib/z80/z80.lib

OBJS = \
	crt0.rel \
	fectrl.rel \
	gui_utils.rel \
	./fat32/fat_access.rel \
	./ldosbioscall.rel \
	./fat32/fat_filelib.rel \
	./fat32/fat_misc.rel \
	./fat32/fat_string.rel \
	./fat32/fat_table.rel \
	./fat32/fat_write.rel \
	./fat32/fat_cache.rel

%.rel: %.c
	$(CC) $(CFLAGS) -o $*.rel -c $< 

%.rel: %.s
	$(AS) $(ASFLAGS) -o $@ $< 

%.cmd: %.ihx
	$(IHEX2CMD) $< $@

all: file.cmd

file.ihx: $(OBJS) Makefile
	$(LD) $(LDFLAGS) -i file.ihx $(OBJS)

clean:
	rm -f *.rel
	rm -f *.lk
	rm -f *.lst
	rm -f *~
	rm -f *.noi
	rm -f *.ihx
	rm -f *.map
	rm -f *.asm
	rm -f *.sym
	rm -f *.cmd
	rm -f fat32/*.rel
	rm -f fat32/*.lk
	rm -f fat32/*.lst
	rm -f fat32/*~
	rm -f fat32/*.noi
	rm -f fat32/*.ihx
	rm -f fat32/*.map
	rm -f fat32/*.asm
	rm -f fat32/*.sym
	rm -f fat32/*.cmd
