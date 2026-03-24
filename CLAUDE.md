# Space Bandits - Development Guide

## Project Overview
Space Bandits is a Space Invaders-style game for the **Tandy Color Computer 3 (CoCo 3)**. It uses a modified [DynoSprite](https://github.com/richard42/dynosprite) engine for efficient resource management on severely constrained hardware.

### Hardware Constraints (CoCo 3)
- **CPU:** Motorola 6809 at 1.7897725 MHz (optional 6309 with ~29% speedup)
- **RAM:** 512KB, bank-switched in 8KB blocks via GIME chip
- **Graphics:** 320x200, 16 colors from a 64-color palette, double-buffered
- **Sound:** Digital audio via CPU-driven DAC (no hardware sound chip)
- **Cycles per frame:** ~29,860 at 60Hz — every cycle counts
- **Address space:** 16-bit (64KB visible at a time)

### Dual Platform
- **CoCo 3 version:** The real target. 6809/6309 assembly + CMOC C, built via Makefile + Docker.
- **macOS version:** Testing/development aid. Xcode project in `Space Bandits/`, has 49 OCUnit tests.

## Repository Structure

```
engine/          # DynoSprite engine (25 .asm files) — core graphics, sound, input, memory
game/
  objects/       # 13 object groups — mostly C
  levels/        # 3 levels (JSON config + C/ASM code + tilemap images)
  sprites/       # 13 sprite groups (JSON definitions + PNG sheets)
  tiles/         # 3 tilesets (JSON + PNG)
  sounds/        # 5 WAV sound effects
  images/        # 3 splash screen PNGs
  shared/        # Utility code (FixedPoint math, sprite state machine, music sequencer)
  hires/         # High-resolution asset variants
scripts/         # Python build tools (sprite compiler, graphics processing, compression)
tools/           # External tools (CMOC, MAME, lwasm, etc.)
assets/          # Additional resources
cfg/             # Configuration files
doc/             # Documentation (DynoSpriteUsage.txt, AddressMap.txt, Benchmarks.txt)
Space Bandits/   # macOS Xcode project (testing/development port)
```

### Naming Convention
Game assets use `XX-descriptivename` prefix (two-digit index for ordering).

## Building

### CoCo 3 Build (Docker)
```bash
./coco-dev              # Start Docker environment (jamieleecho/coco-dev)
make all                # Build disk image (BNDT6809.DSK)
make all CPU=6309       # Build 6309-optimized version (BNDT6309.DSK)
exit                    # Exit Docker
make test               # Run in MAME emulator (needs tools/mame64 symlink)
```

### Build Options
- `RELEASE=1` — Release build (no bounds checking)
- `CPU=6309` — 6309-specific optimizations
- `SPEEDTEST=1` — Performance measurement mode
- `VISUALTIME=1` — Frame timing via border color (forces 256x200)
- `MAMEDBG=1` — Launch with MAME debugger
- `OBJPAGES=N` — Object memory pages (default 2)
- `MUSIC_VOICES=N` — Number of music voices, 0-3 (default 3). 0 disables music entirely.
- `FAST_BACKGROUND=1` — Use fast CC-register tile drawing (risk of pixel corruption from interrupts)
- `VERBOSE_ERRORS=0` — Reduce error display to PC+S only (saves ~150 bytes in primary page)
- `INCLUDE_RANDOM=1` — Include `Util_Random` and `Util_RandomRange16` (default off)
- `DISK_DEBUG=1` — Enable debug checks in disk I/O routines (default off)

### macOS Build
```bash
open "Space Bandits/Space Bandits.xcodeproj"
# Build & Run from Xcode, or:
xcodebuild -project "Space Bandits/Space Bandits.xcodeproj" -scheme "Space Bandits" build
```

### Prerequisites
- **CoCo 3:** Docker (uses `jamieleecho/coco-dev` image with lwasm, CMOC, decb, ffmpeg)
- **Testing:** MAME emulator symlinked at `tools/mame64`
- **macOS:** Xcode (SDL2 framework included in repo)

## Build Pipeline (16 Steps)
The Makefile orchestrates a complex pipeline: JSON config parsing → graphics generation → sprite compilation to ASM → assembly → engine build → symbol extraction → object/level/tileset/sound/image packaging → final link + relocation → disk image creation. Output is 16 files on a CoCo disk image.

## DynoSprite Engine

### Key Concepts
- **Tilemapped background:** 16x16 tiles, scrollable (max 2000x68 tiles), 2px horizontal / 1px vertical increments
- **Sprite system:** Dynamically compiled draw/erase routines (Python generates 6809/6309 ASM)
- **Object system:** Standard interface via data tables (COT, SGT, SDT, ODT)
- **Virtual memory:** 8KB bank-switched pages for levels, objects, sprites
- **Double-buffered graphics** with smooth scrolling
- **2-voice audio** (internal DAC or Orchestra-90)

### Memory Map (Key Regions)
- `$2000-$3FFF` — Main code and globals (Direct Page at `$2000`)
- `$4000-$5FFF` — Level/Object code or graphics aperture
- `$6000-$BFFF` — Graphics output window
- `$C000-$DFFF` — Sprite erase data
- `$E000-$FFFF` — Interrupt vectors and secondary code

### Documentation
- `doc/DynoSpriteUsage.txt` — Comprehensive engine guide (architecture, data structures, content creation)
- `doc/AddressMap.txt` — Full memory layout and GIME mappings
- `doc/Benchmarks.txt` — Performance data and optimization results

## Game Architecture

### Objects (13 Groups)
| ID | Name | Language | Description |
|----|------|----------|-------------|
| 01 | Numerals | ASM | HEX score display |
| 02 | Balls | ASM | Demo marbles |
| 03 | Bad Guys | C | Enemy invaders (5 animation frames) |
| 04 | Ship | C | Player ship with explosion |
| 05 | Missiles | C | Player projectiles |
| 06 | Game Over | C | Game over screen |
| 07 | Bad Missiles | C | Enemy projectiles |
| 08 | Ship Counter | C | Lives display |
| 09 | Boss | C | Boss invader |
| 10 | Little Guy | C | Player character with walk/jump animations (8 frames) |
| 11 | Bird | C | Flying NPC, hides when hit for 180 frames, respawns randomly |
| 12 | Cat | C | AI with 3 moods: sleep, chase bird (with jumping), snuggle player (14 frames) |
| 13 | Cloud | C | Parallax cloud, moves 1px per 8 scroll increments |

### Levels
1. **Persei** (Level 01) — "Omicron Persei 8 Invades": 352x224 playfield, 45 enemies (5x9 grid), 3 waves, boss encounter
2. **Space** (Level 02) — Second level, similar structure
3. **Chirico** (Level 03) — "Piazza Metafisica": 640x224 scrolling playfield, player character, 3 birds, cat, parallax cloud

### Sprites (13 Groups)
Each sprite group has a JSON descriptor and PNG sheet in `game/sprites/`. The sprite compiler generates optimized 6809/6309 ASM draw/erase routines from these.

| ID | Name | Frames | Description |
|----|------|--------|-------------|
| 01 | numerals | — | HEX digit display |
| 02 | balls | — | Demo marbles |
| 03 | badguy | 22+ | Enemy invaders with explosion |
| 04 | ship | 12+ | Player ship with explosion |
| 05 | missile | — | Player projectiles |
| 06 | gameover | — | Game over text |
| 07 | badmissile | — | Enemy projectiles |
| 08 | shipcounter | — | Lives display |
| 09 | boss1 | — | Boss invader |
| 10 | littleguy | 8 | Player character: walk left/right, center, jump |
| 11 | bird | 3 | Wings up/level/down |
| 12 | cat | 14 | Sleep, sit, walk, snuggle, chase animations |
| 13 | cloud | 1 | Parallax cloud |

### Tilesets
| ID | Name | Description |
|----|------|-------------|
| 01 | moon | Moon surface tileset |
| 02 | space | Space background tileset |
| 03 | chirico | De Chirico-inspired cityscape (640x224) |

### Sounds
| ID | Constant | File | Description |
|----|----------|------|-------------|
| 1 | SOUND_LASER | `01-laser.wav` | Laser fire |
| 2 | SOUND_EXPLOSION | `02-explosion.wav` | Explosion |
| 3 | SOUND_CLICK | `03-click.wav` | Boss hit |
| 4 | SOUND_BOINK | `04-boink.wav` | Jump |
| 5 | SOUND_OUCH | `05-ouch.wav` | Bird collision |

### Game State
```c
typedef struct GameGlobals {
    byte initialized, numShips, gameState;
    byte score[3];           // 3-digit BCD
    word shootCounter[3];
    byte counter, gameWave, numInvaders;
} GameGlobals;
```

## Scrolling and Background Coordinates

### Gfx_BkgrndNewX / Gfx_BkgrndNewY
- **Never use `Gfx_BkgrndLastX` / `Gfx_BkgrndLastY`** in game code.
- Each level's `CalculateBkgrndNewXY` function (e.g., `ChiricoCalculateBkgrndNewXY` in `game/levels/03-chirico.c`) is responsible for setting `Gfx_BkgrndNewX` / `Gfx_BkgrndNewY`.
- All objects should **read** `Gfx_BkgrndNewX` for screen-relative position calculations. Objects should **not write** to `Gfx_BkgrndNewX`.
- Each positive increment of `Gfx_BkgrndNewX` scrolls the screen by 2 pixels.
- Max value: `(play_area_width - 320) / 2`.

### Screen Coordinate Calculation
- **Horizontal:** Screen X (in half-pixel units) = `globalX / 2 - Gfx_BkgrndNewX`. The screen is 160 units wide (320 pixels). Each increment of `Gfx_BkgrndNewX` = 2 pixels.
- **Vertical:** Screen Y = `globalY - Gfx_BkgrndNewY`. No multiplication — `Gfx_BkgrndNewY` is in pixels directly. Value of 0 = top of play area. Max = `play_area_height - 200`.
- To check if an object is on-screen, compare its screen X/Y against `[0, SCREEN_WIDTH]`/`[0, SCREEN_HEIGHT]` accounting for the object's half-width/half-height.

### Scroll Speed Limitation
The CoCo 3 can scroll at most **2 units of `Gfx_BkgrndNewX` (4 pixels) horizontally** or **4 pixels of `Gfx_BkgrndNewY` vertically** per frame. Rather than snapping the camera to the target position, `CalculateBkgrndNewXY` should clamp the per-frame scroll delta to these maximums, creating a smooth "catch up" effect when the player moves fast or jumps.

### Parallax
- For parallax effects (e.g., clouds), objects can compute their `globalX` based on `Gfx_BkgrndNewX` with a reduced ratio (e.g., move 1 pixel per 8 scroll increments).

## Sound System

Sound constants are defined in `game/objects/object_info.h`. See the Sounds table above for current IDs.

### Playing Sounds
Call `PlaySound(SOUND_ID)` from any object's C code. On CoCo 3 this invokes `Sound_Play` in assembly; on macOS it goes through `DSSoundManager` using AVAudioPlayer. Max 2 simultaneous sounds on both platforms.

### Adding a New Sound
1. Add WAV file to `game/sounds/` with `XX-name.wav` naming (XX = next number)
2. Add `#define SOUND_NAME XX` to `game/objects/object_info.h`
3. Add file reference, build file, copy phase entry, and group entry to the Xcode pbxproj (see "Adding Files to the Xcode Project" below)

## Music System

The music engine provides 3-voice wavetable synthesis using a 128-byte half-sine lookup table with 16-bit phase accumulators. Music plays simultaneously with sound effects by mixing into the audio buffer.

### Architecture (CoCo 3)
The music code is split across three code pages:
- **Primary page** (`engine/music.asm`): Empty — all code moved to secondary/tertiary pages to save space.
- **Secondary page** (`engine/music-stubs.asm`): Page-swapping stubs for all music APIs, `Music_WaveTable` (128-byte half-sine, ±10 amplitude), and stubs for `Music_RefillBuffer`/`Music_MixIntoBuffer`.
- **Tertiary page** (`engine/music-commands.asm` at `$4000`): `Music_Start/Stop` implementations, `Music_RefillBuffer_Impl` (3-voice sample generation), `Music_MixIntoBuffer_Impl` (3-voice SFX mixing). Swapped in via `$FFA2` on demand.

### Architecture (macOS)
`DSSoundManager.m` uses `AVAudioEngine` with `AVAudioSourceNode`. Three independent sine oscillators are mixed in the render callback.

### Playing Music from C Code
```c
#include "dynosprite.h"

/* Start a tone on a voice. phaseInc = freq * 65536 / AudioSamplingRate */
MusicStart(phaseInc);    /* voice 0 */
MusicStart1(phaseInc);   /* voice 1 */
MusicStart2(phaseInc);   /* voice 2 */

/* Stop voices */
MusicStop();    /* fade-out all voices */
MusicStop1();   /* silence voice 1 only */
MusicStop2();   /* silence voice 2 only */

/* Passing phaseInc=0 silences a voice without stopping music */
MusicStart1(0); /* equivalent to MusicStop1() */
```

### Phase Increment Formula
`phaseInc = frequency_Hz * 65536 / AudioSamplingRate`

`AudioSamplingRate` is 2000 (defined in `engine/globals.asm`). Examples:
| Note | Freq (Hz) | Phase Increment |
|------|-----------|-----------------|
| C3   | 130.81    | 4286            |
| A3   | 220.00    | 7209            |
| C4   | 261.63    | 8573            |
| A4   | 440.00    | 14418           |

### Music Sequencer
A reusable header-only sequencer is available in `game/shared/sequencer.h`. Include it in any level's C code to get automatic song playback with looping.

#### Song Data Format
Songs are defined as parallel arrays — one for phase increments, one for durations (in ticks):
```c
static word melody_notes[] = {PHASE_C3, PHASE_E3, PHASE_G3, 0 /* rest */};
static byte melody_durs[]  = {2, 2, 2, 1, 0 /* end=loop */};
```
- Duration 0 marks end of track (loops to start)
- Phase increment 0 is a rest (silence that voice)

#### Sequencer API
```c
#include "../shared/sequencer.h"

/* Start a 3-voice song. NULL for unused voices. */
SequencerPlay(v0_notes, v0_durs,    /* voice 0: melody */
              v1_notes, v1_durs,    /* voice 1: harmony */
              v2_notes, v2_durs,    /* voice 2: harmony */
              tempo);               /* frames per tick */

/* Call once per frame from CalculateBkgrndNewXY */
SequencerTick();

/* Stop with fade-out */
SequencerStop();
```

Each level that includes `sequencer.h` gets its own static copy of the sequencer code and state (no cross-page memory issues). Song data arrays are defined in the level's own `.c` file.

#### Example (level 3 — Moonlight Sonata)
```c
/* Arpeggiated triplets on voice 0, sustained chord tones on voices 1+2 */
SequencerPlay(moon_v0_notes, moon_v0_durs,
              moon_v1_notes, moon_v1_durs,
              moon_v2_notes, moon_v2_durs, 20);
```

### Voice Count Configuration
Set `MUSIC_VOICES=N` (0-3) in the Makefile to control how many voices are compiled:
- `MUSIC_VOICES=0` — All music APIs become no-ops. No music code or wavetable emitted.
- `MUSIC_VOICES=1` — Voice 0 only. `MusicStart1/2` and `MusicStop1/2` are no-ops.
- `MUSIC_VOICES=2` — Voices 0+1.
- `MUSIC_VOICES=3` — All 3 voices (default).

### Performance
- **1 voice**: ~6% CPU at 2000 Hz sample rate
- **3 voices**: ~18% CPU at 2000 Hz sample rate
- Buffer refill: 256 samples every 128ms
- Music mixes with SFX by adding signed offsets to the existing audio buffer

### SFX Coexistence
When sound effects are playing, the FIRQ audio handler fills the buffer with SFX first, then `Music_MixIntoBuffer` adds music on top by converting each voice's wavetable sample to a signed offset from center ($80) and adding it to the existing buffer. When no SFX is playing, `Music_RefillBuffer` writes directly to the buffer.

## Object Visibility and Off-Screen Hiding

For scrolling levels, objects must not be drawn if **any part** of the sprite would be clipped **vertically** by the top or bottom screen edges. Horizontal clipping is handled by the engine. Use the `active` field on the COB:

```c
/* In the object's Update function, after all state updates: */
int screenY = (int)cob->globalY - (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
if (screenY - HALF_HEIGHT < 0 || screenY + HALF_HEIGHT > SCREEN_HEIGHT) {
    cob->active = OBJECT_UPDATE_ACTIVE;  /* update only, don't draw */
} else {
    cob->active = OBJECT_ACTIVE;         /* update and draw */
}
```

Active flag values: `OBJECT_INACTIVE` (0), `OBJECT_UPDATE_ACTIVE` (1), `OBJECT_DRAW_ACTIVE` (2), `OBJECT_ACTIVE` (3).

**Important:** The `Active` value in the level JSON must match the object's initial visibility. If an object starts off-screen (based on `BkgrndStartX`/`BkgrndStartY`), set its `Active` to `1` (`OBJECT_UPDATE_ACTIVE`) in the JSON, not `3`. The object's Update function will set it to `OBJECT_ACTIVE` once it scrolls into view.

## Collision Detection

Objects use bounding-box collision with half-width/half-height constants. Use `findObjectByGroup()` from `object_info.h` to locate other objects:

```c
DynospriteCOB *target = findObjectByGroup(
    DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, TARGET_GROUP_IDX);
if (target) {
    int dx = (int)cob->globalX - (int)target->globalX;
    int dy = (int)cob->globalY - (int)target->globalY;
    if (dx < 0) dx = -dx;
    if (dy < 0) dy = -dy;
    if (dx < (MY_HALF_WIDTH + TARGET_HALF_WIDTH) &&
        dy < (MY_HALF_HEIGHT + TARGET_HALF_HEIGHT)) {
        /* collision! */
    }
}
```

To check collision against **all** objects of a group (e.g., multiple birds), iterate the object table directly:

```c
DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
DynospriteCOB *endObj = obj + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
for (; obj < endObj; obj++) {
    if (obj->groupIdx == TARGET_GROUP_IDX) {
        /* check collision with obj */
    }
}
```

## Development Guidelines

### Performance Is Everything
- The CPU has ~29,860 cycles per frame. Profile with `SPEEDTEST=1` or `VISUALTIME=1`.
- Prefer assembly for hot paths. C (via CMOC) is acceptable for object logic.
- The sprite compiler (`scripts/sprite2asm.py`) generates optimized unrolled ASM — don't hand-write sprite routines.
- 6309 builds are ~29% faster; test both CPU targets.

### Adding Game Content
- **New object:** Create `game/objects/XX-name/` with JSON descriptor + C or ASM source. Follow existing patterns.
- **New sprite:** Add PNG to `game/sprites/`, create JSON descriptor. The build pipeline compiles sprites to ASM automatically. **Important:** Sprite PNGs must be indexed-color images whose palette indices match the tileset image for the level they appear on. The transparent color (typically `(255,0,255)` magenta) does not need to be in the tileset palette but must still be at a consistent index in the sprite's PNG palette.
- **New level:** Create `game/levels/XX-name.json` (config) + `XX-name.c` (level code with Init and CalculateBkgrndNewXY). Also requires:
  - A level image `game/images/XX-levelN.png` (132x96 indexed PNG, preview/splash for the level)
  - A corresponding entry in `game/images/images.json` (one entry per level, with BackgroundColor, ForegroundColor, ProgressColor for the loading screen)
  - Set `FirstLevel` in `game/defaults-config.json` to change the default level
- **New sound:** Add WAV to `game/sounds/`. ffmpeg resamples automatically during build.
- **New tileset:** Add PNG + JSON to `game/tiles/`. The background is tiled using 16x16 pixel tiles extracted from the tileset image. **Maximum 127 unique tiles** per tileset. The tileset JSON format is:
  ```json
  {
    "Image": "XX-name.png",
    "TileSetStart": [0, 1],
    "TileSetSize": [width, height]
  }
  ```
  Note: `TileSetStart` Y is `16` to skip the palette block (see below).

### Tileset Palette Convention
The 16-color CoCo 3 palette for each level is defined by the **first 16 rows** of the tileset PNG image.

#### Palette Block Layout
- The top 16 rows encode palette indices 0–15, left to right.
- Each color is `image_width / 16` pixels wide and 16 pixels tall (one tile height).
- **Index 0 must be the background color.**
- Actual tile data starts at row 16. Set `TileSetStart` Y to `16` in the tileset JSON.
- `TileSetSize` height covers only the tile area (excludes the palette block).

#### Color Values
- RGB channel values must be **0, 1, 2, or 3** (CoCo 3 native 2-bit-per-channel, 64 colors total).
- In 8-bit PNG terms: 0→0, 1→85, 2→170, 3→255.
- The build pipeline's auto-matcher (`gfx-process.py`) will find exact matches since these are valid CoCo 3 colors.

#### Unused Palette Slots
If fewer than 16 colors are needed, fill remaining slots in this priority order:
1. White (3,3,3)
2. Black (0,0,0)
3. Grey (2,2,2)
4. Dark grey (1,1,1)
5. Pure red shades
6. Pure green shades
7. Pure blue shades

Skip any already present in the palette.

#### Sprite Palette Matching
Sprite PNGs must be **indexed-color images** that use the **same palette indices** as the tileset image for their level. For example, if palette index 5 is `(0,0,0)` black in the tileset, then black pixels in the sprite must also use index 5. The transparent color (typically `(255,0,255)` magenta) should be placed at **index 16** (outside the 16-color tileset palette). The sprite JSON's `"Palette"` value must be set to the **tileset number** for the level (e.g., `3` for level 3, `4` for level 4).

#### Choosing the Best Palette
When creating a tileset, analyze all pixels across **both** the tileset image and the sprite PNGs used on that level (excluding transparent key colors like `(255,0,255)`). Sort by pixel count to prioritize the most-used colors. This ensures the shared 16-color palette is optimized for the full visual output of the level.
- See `doc/DynoSpriteUsage.txt` for detailed content creation guides.

### Adding Files to the Xcode Project (pbxproj)
When adding new game source/resource files, the Xcode project file (`Space Bandits/Space Bandits.xcodeproj/project.pbxproj`) must be updated. Find existing entries for a similar object (e.g., search for `11-bird` or `12-cat`) and follow the same pattern.

#### File type conventions
- **`.c` source:** `explicitFileType = sourcecode.cpp.objcpp`, `fileEncoding = 4`, `path = "../game/objects/XX-name.c"`, `sourceTree = SOURCE_ROOT`
- **`.h` header:** `lastKnownFileType = sourcecode.c.h`, `path = "../game/objects/XX-name.h"`, `sourceTree = SOURCE_ROOT`
- **`.json` sprite descriptor:** `fileEncoding = 4`, `lastKnownFileType = text.json`, `path = "XX-name.json"`, `sourceTree = "<group>"` (filename only, group path handles the rest)
- **`.png` sprite image:** `lastKnownFileType = image.png`, `path = "XX-name.png"`, `sourceTree = "<group>"`
- **`.wav` sound:** `lastKnownFileType = audio.wav`, `path = "XX-name.wav"`, `sourceTree = "<group>"`

#### Sections to update (6 total)
1. **PBXBuildFile** — Add build file entries for `.c` (in Sources), and for each resource (`.json`, `.png`, `.wav`) in the appropriate Copy Files phase
2. **PBXFileReference** — Add file reference entries for `.c`, `.h`, `.json`, `.png` (or `.wav`)
3. **PBXGroup "objects"** — Add `.h` and `.c` references to the objects group children
4. **PBXGroup "sprites"** (or "sounds", "levels", etc.) — Add resource file references to the appropriate group children
5. **PBXCopyFilesBuildPhase** — Add resource build file refs to the correct copy phase ("Copy sprites Files", "Copy sounds Files", etc.)
6. **PBXSourcesBuildPhase** — Add `.c` build file ref

#### Validation
Always validate after editing: `plutil -lint "Space Bandits/Space Bandits.xcodeproj/project.pbxproj"`

### Code Style
- Engine code: 6809/6309 assembly (lwasm syntax)
- Game object/level code: CMOC C (subset of C targeting 6809) or assembly
- Build scripts: Python 3
- macOS port: Objective-C with OCUnit tests

### Testing
- **CoCo 3:** Manual testing via `make test` (MAME emulator). Use `MAMEDBG=1` for debugging.
- **macOS:** `xcodebuild ... test` runs 49 OCUnit tests covering graphics, objects, input, and resources.
- CI runs both CoCo 3 Docker build and macOS tests on every push.

## CI/CD
- **build.yml** — Every push: Docker CoCo 3 build + macOS Xcode build/test
- **make-release.yml** — Manual: Creates GitHub release with 6809 DSK, 6309 DSK, and macOS binary
- **bump-version.yml** — Version management
