ASSEMBLER = nasm

OUTPUT_DIR = target
MAIN = boot#.s
OUT = termboot.bin
ASM_FLAGS = -f bin

# Wondering why I diddnt use object linking? Cause that would be a headache

# Inputs
all: pre-build
	$(ASSEMBLER) $(ASM_FLAGS) $(MAIN).asm -o $(OUTPUT_DIR)/$(OUT)

DRIVE = drive.img # Input variable
flash:
	# Remember to set the DRIVE variable to flash it to the drive you want
	dd if=$(OUTPUT_DIR)/$(OUT) of=$(DRIVE)
# Inputs


.PHONY: clean pre-build

pre-build:
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -rf $(DRIVE)
	rm -rf $(OUTPUT_DIR)
