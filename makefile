###############################################################################
## Makefile for DynoSprite

# paths
SRCDIR = ./engine
GAMEDIR ?= ./game
SCRIPTDIR = ./scripts
BUILDDIR = ./build
TOOLDIR = ./tools
TILEDIR = $(GAMEDIR)/tiles
LEVELDIR = $(GAMEDIR)/levels
SPRITEDIR = $(GAMEDIR)/sprites
OBJECTDIR = $(GAMEDIR)/objects
SOUNDDIR = $(GAMEDIR)/sounds
IMAGEDIR = $(GAMEDIR)/images
GENASMDIR = $(BUILDDIR)/asm
GENGFXDIR = $(BUILDDIR)/gfx
GENOBJDIR = $(BUILDDIR)/obj
GENTMPDIR = $(BUILDDIR)/tmp
GENLISTDIR = $(BUILDDIR)/list
GENDISKDIR = $(BUILDDIR)/disk

# lists of source game assets
TILEDESC = $(wildcard $(TILEDIR)/??-*.json)
LEVELSRC = $(wildcard $(LEVELDIR)/??-*.asm)
SPRITEDSC = $(wildcard $(SPRITEDIR)/??-*.json)
OBJECTCSRC = $(wildcard $(OBJECTDIR)/??-*.c)
OBJECTCSRC2ASM = $(patsubst %.c, %.asm, $(OBJECTCSRC))
OBJECTSRC = $(wildcard $(OBJECTDIR)/??-*.asm)
SOUNDSRC = $(wildcard $(SOUNDDIR)/??-*.wav)
IMAGESRC = $(wildcard $(IMAGEDIR)/??-*.png)
LEVELSRC = $(wildcard $(LEVELDIR)/??-*.asm)
LEVELCSRC = $(wildcard $(LEVELDIR)/??-*.c)
LEVELCSRC2ASM = $(patsubst %.c, %.asm, $(LEVELCSRC))
LEVELDSC = $(wildcard $(LEVELDIR)/??-*.json)

# lists of build products based on game assets
TILESRC = $(patsubst $(TILEDIR)/%.json, $(GENGFXDIR)/tileset%.txt, $(TILEDESC))
MASKSRC = $(patsubst $(TILEDIR)/%.txt, $(GENGFXDIR)/tileset%_mask.txt, $(TILEDESC))
PALSRC = $(patsubst $(TILEDIR)/%.txt, $(GENGFXDIR)/palette%.txt, $(TILEDESC))
SPRITESRC = $(patsubst $(SPRITEDIR)/%.json, $(GENGFXDIR)/sprite%.txt, $(SPRITEDSC))
SPRITERAW := $(patsubst $(SPRITEDIR)/%.json, $(GENOBJDIR)/sprite%.raw, $(SPRITEDSC))
OBJECTRAW := $(patsubst $(OBJECTDIR)/%.asm, $(GENOBJDIR)/object%.raw, $(OBJECTSRC) $(OBJECTCSRC2ASM))
SOUNDRAW := $(patsubst $(SOUNDDIR)/%.wav, $(GENOBJDIR)/sound%.raw, $(SOUNDSRC))
LEVELRAW := $(patsubst $(LEVELDIR)/%.asm, $(GENOBJDIR)/level%.raw, $(LEVELSRC) $(LEVELCSRC2ASM))
MAPSRC := $(patsubst $(LEVELDIR)/%.json, $(GENGFXDIR)/tilemap%.txt, $(LEVELDSC))


# output ASM files generated from sprites
SPRITEASMSRC := $(patsubst $(SPRITEDIR)/%.txt, $(GENASMDIR)/sprite%.asm, $(filter %.txt, $(SPRITEDSC)))

# paths to dependencies
ASSEMBLER = lwasm
EMULATOR = $(TOOLDIR)/mame64

# make sure build products directories exist
$(shell mkdir -p $(GENASMDIR))
$(shell mkdir -p $(GENGFXDIR))
$(shell mkdir -p $(GENOBJDIR))
$(shell mkdir -p $(GENLISTDIR))
$(shell mkdir -p $(GENDISKDIR))

# assembly source files
LOADERSRC = $(addprefix $(SRCDIR)/, constants.asm \
                                    datastruct.asm \
                                    decompress.asm \
                                    disk.asm \
                                    globals.asm \
                                    graphics-bkgrnd.asm \
                                    graphics-image.asm \
                                    graphics-sprite.asm \
                                    graphics-text.asm \
                                    input.asm \
                                    loader.asm \
                                    macros.asm \
                                    main.asm \
                                    math.asm \
                                    memory.asm \
                                    menu.asm \
                                    object.asm \
                                    sound.asm \
                                    system.asm \
                                    utility.asm)

# files to be added to Coco3 disk image
READMEBAS = $(GENDISKDIR)/README.BAS
LOADERBIN = $(GENDISKDIR)/BANDITS.BIN
DATA_TILES = $(GENDISKDIR)/TILES.DAT
DATA_OBJECTS = $(GENDISKDIR)/OBJECTS.DAT
DATA_LEVELS = $(GENDISKDIR)/LEVELS.DAT
DATA_SOUNDS = $(GENDISKDIR)/SOUNDS.DAT
DATA_IMAGES = $(GENDISKDIR)/IMAGES.DAT
DISKFILES = $(READMEBAS) $(LOADERBIN) $(DATA_TILES) $(DATA_OBJECTS) $(DATA_LEVELS) $(DATA_SOUNDS) $(DATA_IMAGES)

# game directory files to be included in core pass2 assembly
ASM_TILES = $(GENASMDIR)/gamedir-tiles.asm
ASM_OBJECTS = $(GENASMDIR)/gamedir-objects.asm
ASM_LEVELS = $(GENASMDIR)/gamedir-levels.asm
ASM_SOUNDS = $(GENASMDIR)/gamedir-sounds.asm
ASM_IMAGES = $(GENASMDIR)/gamedir-images.asm

# core assembler pass outputs
PASS1LIST = $(GENLISTDIR)/dynosprite-pass1.lst
PASS2LIST = $(GENLISTDIR)/dynosprite-pass2.lst
SYMBOLASM = $(GENASMDIR)/dynosprite-symbols.asm

# retrieve the audio sampling rate
AUDIORATE = $(shell grep -E "AudioSamplingRate\s+EQU\s+[0-9]+" $(SRCDIR)/globals.asm | grep -oE "[0-9]+")

# options
ASMFLAGS = -I $(GENASMDIR)
ifneq ($(RELEASE), 1)
  ASMFLAGS += --define=DEBUG
  CFLAGS += -DDEBUG
endif
ifeq ($(SPEEDTEST), 1)
  ASMFLAGS += --define=SPEEDTEST
endif
ifeq ($(VISUALTIME), 1)
  ASMFLAGS += --define=VISUALTIME
endif
ifeq ($(CPU),6309)
  ASMFLAGS += --define=CPU=6309
  LOADERSRC += $(SRCDIR)/graphics-blockdraw-6309.asm
  MAMESYSTEM = coco3h
else
  CPU = 6809
  ASMFLAGS += --define=CPU=6809
  LOADERSRC += $(SRCDIR)/graphics-blockdraw-6809.asm
  MAMESYSTEM = coco3
endif
ifeq ($(OBJPAGES),)
  ASMFLAGS += --define=OBJPAGES=2
else
  ASMFLAGS += --define=OBJPAGES=$(OBJPAGES)
endif
ifeq ($(OBJPAGEGUARD),)
  ASMFLAGS += --define=OBJPAGEGUARD=256
else
  ASMFLAGS += --define=OBJPAGEGUARD=$(OBJPAGEGUARD)
endif
ifeq ($(MAMEDBG), 1)
  MAMEFLAGS += -debug
endif

# output disk image filename
TARGET = $(BUILDDIR)/BNDT$(CPU).DSK

# build targets
targets:
	@echo "DynoSprite makefile. "
	@echo "  Targets:"
	@echo "    all            == Build disk image"
	@echo "    clean          == remove binary and output files"
	@echo "    test           == run test in MAME"
	@echo "  Build Options:"
	@echo "    RELEASE=1      == build without bounds checking / SWI instructions"
	@echo "    SPEEDTEST=1    == run loop during idle and count time for analysis"
	@echo "    VISUALTIME=1   == set screen width to 256 and change border color"
	@echo "    CPU=6309       == build with faster 6309-specific instructions"
	@echo "    OBJPAGES=1     == num of pages to use levels and objects"
	@echo "    OBJPAGEGUARD=0 == num bytes to reserve at top of each object code page"
	@echo "  Debugging Options:"
	@echo "    MAMEDBG=1      == run MAME with debugger window (for 'test' target)"

# this special target is used to prevent gnu make from deleting the intermediate sprite .txt and .asm files
SECONDARY: $(SPRITESRC) $(SPRITEASMSRC)

all: $(TARGET)

clean:
	rm -rf $(GENASMDIR) $(GENGFXDIR) $(GENOBJDIR) $(GENDISKDIR) $(GENLISTDIR) $(GENTMPDIR)

test:
	$(EMULATOR) $(MAMESYSTEM) -flop1 $(TARGET) $(MAMEFLAGS) -window -waitvsync -resolution 640x480 -video opengl -rompath ~/Applications/mame/roms

# build rules
# 0. Parse options file
$(GENASMDIR)/defaults-config.asm: $(GAMEDIR)/defaults-config.json
	$(SCRIPTDIR)/build-config.py $< $@

# 1a. Generate text Palette and Tileset files from images
$(GENGFXDIR)/tileset%.txt $(GENGFXDIR)/tilemask%.txt $(GENGFXDIR)/palette%.txt: $(TILEDIR)/%.json $(SCRIPTDIR)/gfx-process.py
	$(SCRIPTDIR)/gfx-process.py gentileset $< $(GENGFXDIR)/palette$*.txt $(GENGFXDIR)/tileset$*.txt $(GENGFXDIR)/tilemask$*.txt

# 1b. Generate text Tilemap files from images
$(GENGFXDIR)/tilemap%.txt: $(LEVELDIR)/%.json $(TILESRC) $(PALSRC) $(SCRIPTDIR)/gfx-process.py
	$(SCRIPTDIR)/gfx-process.py gentilemap $< $(GENGFXDIR) $@

# 1c. Generate Sprite files from images
$(GENGFXDIR)/sprite%.txt: $(SPRITEDIR)/%.json $(PALSRC) $(SCRIPTDIR)/gfx-process.py
	$(SCRIPTDIR)/gfx-process.py gensprites $< $(GENGFXDIR) $@

# 2. Compile sprites to 6809 assembly code
$(GENASMDIR)/sprite%.asm: $(GENGFXDIR)/sprite%.txt $(SCRIPTDIR)/sprite2asm.py
	$(SCRIPTDIR)/sprite2asm.py $< $@ $(CPU)

# 3. Assemble sprites to raw machine code
$(GENOBJDIR)/sprite%.raw: $(GENASMDIR)/sprite%.asm
	$(ASSEMBLER) $(ASMFLAGS) -r -o $@ --list=$(GENLISTDIR)/sprite$*.lst --symbols $<

# 4. Run first-pass assembly of DynoSprite engine
$(PASS1LIST): $(LOADERSRC) $(GENASMDIR)/defaults-config.asm
	$(ASSEMBLER) $(ASMFLAGS) --define=PASS=1 -b -o /dev/null --list=$(PASS1LIST) --symbols $(SRCDIR)/main.asm

# 5. Extract symbol addresses from DynoSprite engine
$(SYMBOLASM): $(SCRIPTDIR)/symbol-extract.py $(PASS1LIST)
	$(SCRIPTDIR)/symbol-extract.py $(PASS1LIST) $(SYMBOLASM)

# 6a. Compile C Object handling routines to raw
$(GENOBJDIR)/object%.raw: $(OBJECTDIR)/%.c $(SRCDIR)/datastruct.asm $(SYMBOLASM)
	cd $(OBJECTDIR) ; ../../scripts/cmoc-wrapper.py $(ASMFLAGS) $(CFLAGS) -I../../$(SRCDIR) -I$(GENASMDIR)/ --output-dir=../../$(GENTMPDIR) --file-type=object $(notdir $<)
	cd $(OBJECTDIR) ; mv ../../$(GENTMPDIR)/$(patsubst %.c,%.bin,$(notdir $<)) ../../$@
	cd $(OBJECTDIR) ; mv ../../$(GENTMPDIR)/$(patsubst %.c,%.map,$(notdir $<)) ../../$(GENLISTDIR)/$(patsubst %.raw,%.lst,$(notdir $@))

# 6b. Assemble Object handling routines to raw machine code
$(GENOBJDIR)/object%.raw: $(OBJECTDIR)/%.asm $(SRCDIR)/datastruct.asm $(SYMBOLASM)
	$(ASSEMBLER) $(ASMFLAGS) -r -I $(SRCDIR) -I $(GENASMDIR)/ -o $@ --list=$(GENLISTDIR)/object$*.lst --symbols $<

# 7. Assemble Level handling routines to raw machine code
# 6a. Compile C Level handling routines to raw
# 7a. Compile C Level handling routines to raw
$(GENOBJDIR)/level%.raw: $(LEVELDIR)/%.c $(SRCDIR)/datastruct.asm $(SYMBOLASM)
	cd $(LEVELDIR) ; ../../scripts/cmoc-wrapper.py $(ASMFLAGS) $(CFLAGS) -I../../$(SRCDIR) -I$(GENASMDIR)/ --output-dir=../../$(GENTMPDIR) --file-type=level $(notdir $<)
	cd $(LEVELDIR) ; mv ../../$(GENTMPDIR)/$(patsubst %.c,%.bin,$(notdir $<)) ../../$@
	cd $(LEVELDIR) ; mv ../../$(GENTMPDIR)/$(patsubst %.c,%.map,$(notdir $<)) ../../$(GENLISTDIR)/$(patsubst %.raw,%.lst,$(notdir $@))

# 6b. Assemble Level handling routines to raw machine code
# 7b. Assemble Level handling routines to raw machine code
$(GENOBJDIR)/level%.raw: $(LEVELDIR)/%.asm $(SRCDIR)/datastruct.asm $(SYMBOLASM)
	$(ASSEMBLER) $(ASMFLAGS) -r -I $(SRCDIR) -I $(GENASMDIR)/ -o $@ --list=$(GENLISTDIR)/level$*.lst --symbols $<

# 8. Build Object data file and game directory assembler code
$(DATA_OBJECTS) $(ASM_OBJECTS): $(SCRIPTDIR)/build-objects.py $(SPRITERAW) $(OBJECTRAW)
	$(SCRIPTDIR)/build-objects.py $(GENOBJDIR) $(GENLISTDIR) $(GENDISKDIR) $(GENASMDIR)

# 9. Build Level data file and game directory assembler code
$(DATA_LEVELS) $(ASM_LEVELS): $(SCRIPTDIR)/build-levels.py $(PASS1LIST) $(LEVELRAW) $(MAPSRC) $(LEVELDSC)
	$(SCRIPTDIR)/build-levels.py $(LEVELDIR) $(PASS1LIST) $(GENGFXDIR) $(GENOBJDIR) $(GENLISTDIR) $(GENDISKDIR) $(GENASMDIR)

#10. Build Tileset data file and game directory assembler code
$(DATA_TILES) $(ASM_TILES): $(SCRIPTDIR)/build-tiles.py $(TILESRC) $(PALSRC)
	$(SCRIPTDIR)/build-tiles.py $(GENGFXDIR) $(GENOBJDIR) $(GENDISKDIR) $(GENASMDIR)

#11. Resample audio files
$(GENOBJDIR)/sound%.raw: $(SOUNDDIR)/%.wav
	echo Converting audio waveform: $<
	ffmpeg -v warning -i $< -acodec pcm_u8 -f u8 -ac 1 -ar $(AUDIORATE) -af aresample=$(AUDIORATE):filter_size=256:cutoff=1.0 $@

#12. Build Sound data file and game directory assembler code
$(DATA_SOUNDS) $(ASM_SOUNDS): $(SCRIPTDIR)/build-sounds.py $(SOUNDRAW)
	$(SCRIPTDIR)/build-sounds.py  $(GENOBJDIR) $(GENDISKDIR) $(GENASMDIR)

#13. Build Images data file and game directory assembler code
$(DATA_IMAGES) $(ASM_IMAGES): $(SCRIPTDIR)/build-images.py $(IMAGESRC)
	$(SCRIPTDIR)/build-images.py  $(IMAGEDIR) $(GENDISKDIR) $(GENASMDIR)

#14. Run final assembly pass of DynoSprite engine and relocate code sections
$(LOADERBIN): $(LOADERSRC) $(ASM_TILES) $(ASM_OBJECTS) $(ASM_LEVELS) $(ASM_SOUNDS) $(ASM_IMAGES) $(SCRIPTDIR)/binsectionmover.py
	$(ASSEMBLER) $(ASMFLAGS) --define=PASS=2 -b -I $(GENASMDIR)/ -o $(LOADERBIN) --list=$(PASS2LIST) $(SRCDIR)/main.asm
	$(SCRIPTDIR)/binsectionmover.py $(LOADERBIN) 0e00-1fff 4000 e000-ffff 6000

#15. Generate the README.BAS document
$(READMEBAS): $(SCRIPTDIR)/build-readme.py $(GAMEDIR)/readme-bas.txt
	$(SCRIPTDIR)/build-readme.py $(GAMEDIR)/readme-bas.txt $(READMEBAS)

#16. Create Coco disk image
$(TARGET): $(DISKFILES)
	rm -f $(TARGET)
	imgtool create coco_jvc_rsdos $(TARGET)
	for f in $(filter $(READMEBAS), $(DISKFILES)); do imgtool put coco_jvc_rsdos $(TARGET) $$f `basename $$f` --ftype=basic --ascii=ascii; done
	for f in $(filter-out $(READMEBAS), $(DISKFILES)); do imgtool put coco_jvc_rsdos $(TARGET) $$f `basename $$f`; done

.PHONY: all clean test

.PRECIOUS: $(OBJECTCSRC2ASM) $(LEVELCSRC2ASM)

