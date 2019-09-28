CODEFILES := $(shell find src -type f)
BINARY := rom.bin

ASOURCES:=$(filter %.asm,$(CODEFILES))
AOBJECTS:=$(ASOURCES:%.asm=build/%.asm.o)


LD := i386-elf-ld

default: build/rom.bin


build:
	@mkdir -p build

build/rom.elf: build $(AOBJECTS)
	@echo " LNK " $@
	@$(LD) $(LDFLAGS) $(AOBJECTS) -T rom.ld -o $@


build/rom.bin: build/rom.elf
	@echo " BIN " $<
	@i386-elf-objcopy -O binary --pad-to 0x10000 build/rom.elf build/rom.bin


build/%.asm.o: %.asm
	@mkdir -p $(dir $@)
	@echo " ASM " $<
	@nasm -f elf $(AFLAGS) -o $@ $<


clean:
	rm -rf build
