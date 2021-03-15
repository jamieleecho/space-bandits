# Space Bandits README
Space Bandits is a CoCo 3 and macOS video game based on the
[Dynosprite](https://github.com/richard42/dynosprite) engine.

The CoCo version requires a 512K Coco 3 with a disk system (either 5 1/4"
floppy drive, or CoCo SDC card, or CoCoNET ROM Pak, or similar). The macOS
version requires macOS 10.14 or later to run.

README Sections
  1. Requirements and Pre-requisites for building Space Bandits
  2. Building Space Bandits
  3. Other Documentation
  4. Getting Started


# 1. Requirements and Pre-requisites
The CoCo 3 version of Space Bandits can be built on any x86 system that runs
Docker 20 or later. The macOS version of Dynosprite requires a macOS compatible
computer running XCode 11.2 or later.

## 1.1 CoCo 3 Version Build Instructions

```
ln -s ~/Applications/mame/mame64 tools/mame64 # or whereever your mame64 is
sudo -s    # Linux only, also see https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
./coco-dev # start virtual linux environment
make all   # builds `build/BNDT6809.dsk`
exit       # exit virtual linux environment
make test  # start the MESS emulator with the disk image
```

## 1.2 macOS Version Build Instructions

```
open "Space Bandits/Space Bandits.xcodeproj"
```

Select `Product->Run`

## 1.3 Using GitHub Actions
Whenever a new tag is created or updated, the
[make-release.yml](https://github.com/jamieleecho/space-bandits/blob/main/.github/workflows/make-release.yml)
GitHub action is run which will create a new release [here](https://github.com/jamieleecho/space-bandits/releases)
that contains both the CoCo 3 and macOS versions.


# 2. Building the CoCo 3 version of Space Bandits
Type `make` by itself to view all available build options:
```
 $ make
DynoSprite makefile. 
  Targets:
    all            == Build disk image
    clean          == remove binary and output files
    test           == run test in MAME
  Build Options:
    RELEASE=1      == build without bounds checking / SWI instructions
    SPEEDTEST=1    == run loop during idle and count time for analysis
    VISUALTIME=1   == set screen width to 256 and change border color
    CPU=6309       == build with faster 6309-specific instructions
    OBJPAGES=1     == num of pages to use levels and objects
    OBJPAGEGUARD=0 == num bytes to reserve at top of each object code page
  Debugging Options:
    MAMEDBG=1      == run MAME with debugger window (for 'test' target)
```

Special notes about audio conversion:
 - if you encounter errors from `ffmpeg` during the audio conversion step,
   you may choose to use `sox` instead of `ffmpeg` by replacing the command
   in step 10 of the makefile with the following command:

```
   sox $< -r $(AUDIORATE) -c 1 -u -1 $@
```

Special notes about build targets:
 - `make all` will build a file called BNDT6809.DSK, while `make all CPU=6309`
    will build a file called BNDT6309.DSK
 - `make test` will run the MESS emulator with the 6809 disk image.  You must
    use `make test CPU=6309` to run with the 6309 disk image.
 - `make clean` will not delete either disk image, but will delete all other
    build products.

Special notes about build options:
 - Release builds will be slightly faster than debug builds, by eliminating
   bounds checking.  You can also include debug code in your game-specific
   assembly source code, using the `IFDEF DEBUG` / `ENDC` macros.
 - The SPEEDTEST option can be used to gather precise debugging data by
   measuring the number of idle CPUs cycles spent waiting for the next vertical
   retrace interrupt after a frame has been drawn.  To use this:
   1. Make a build and examine the list file: "build/list/dynosprite-pass2.lst"
   2. Find the address of this line in main.asm:
                    jsr         Gfx_SpriteEraseOffscreen
   3. Start MESS with `make test MAMEDBG=1`.  Set a breakpoint at the address
      found in step 2, using a command like: "bk $XXXX"
   4. Press F5 to start and run the game until it breaks in the main loop.
   5. Keep pressing F5 to generate each new frame, and observe the values in
      the registers.  A and B will contain the (signed) distance in bytes
      (horizontal, A register) or rows (vertical, B register) with which the
      background plane was scrolled during the last frame redraw.  X will
      contain the number of idle loop iterations which occurred before the
      vertical retrace interrupt was triggered.  This loop is 15 CPU cycles
      long for the 6809 build, and 14 CPU cycles long for the 6309 build.  The
      total number of CPU cycles in each 60Hz video field is 29,860.
 - The VISUALTIME option can be used to see a visual representation of the
   timing characteristics of your game.  When this option is enabled, the
   256x200 graphics mode is used instead of 320x200, and the border color is
   used to show when the game's main loop is busy.  During the first 60hz video
   field when a new frame is being drawn, the border color will be blue while
   the game is processing and/or drawing, and black while in the idle loop,
   waiting for the next vertical retrace.  If the game engine doesn't finish
   drawing a new frame within one 60hz video field time, then the border color
   will change to green.  If the engine is still not finished when the 3rd
   video field time begins, the border color will be changed to red.  So if you
   only see blue and black in the border, then your game should be running at
   60hz all of the time.  If you see green border, then you are dropping to
   30hz for some frames, and if you see red then you are dropping to 20hz.


# 3. Other Documentation
The doc/ folder contains the following additional documentation files:
```
  AddressMap.txt      - CPU/GIME 8k block mappings during various operations in
                        the DynoSprite engine, plus order and contents of data
                        stored on heap
  Benchmarks.txt      - Various benchmarking data gathered during development
  DynoSpriteUsage.txt - How DynoSprite works, and how it can be used to build a
                        game
  Todo.txt            - Notes regarding various features and enhancements which
                        may be added in the future
```


# 4. Getting Started
To get an overall understanding of how Space Bandits and DynoSprite works,
and how an author can use DynoSprite to build his or her game, read the
DynoSpriteUsage.txt guide and follow the instructions included within.


# 5. Credits
## Space Ship
James M Weisbecker

## Aliens
Unity Store - Retro Alien Pack

## Earth Rise
NASA

## Laser Sound
freesound.org - The bizniss

## Explosion Sound
freesound.org - tommccann

## Song Sound
www.looperman.com
November Vibe by Raw X Limits

## Lrrr
camo.githubusercontent.com

## Explosions
opengameart.org - Chuzco


