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
  objects/       # 9 object groups (ship, missiles, bad guys, boss, etc.) — mostly C
  levels/        # 2 levels (JSON config + C/ASM code + tilemap images)
  sprites/       # 9 sprite groups (JSON definitions + PNG sheets)
  tiles/         # 2 tilesets (JSON + PNG)
  sounds/        # 3 WAV sound effects
  images/        # 3 splash screen PNGs
  shared/        # Utility code (FixedPoint math, sprite state machine)
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

### Objects (9 Groups)
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

### Levels
1. **Persei** (Level 01) — "Omicron Persei 8 Invades": 352x224 playfield, 45 enemies (5x9 grid), 3 waves, boss encounter
2. **Space** (Level 02) — Second level, similar structure

### Game State
```c
typedef struct GameGlobals {
    byte initialized, numShips, gameState;
    byte score[3];           // 3-digit BCD
    word shootCounter[3];
    byte counter, gameWave, numInvaders;
} GameGlobals;
```

## Development Guidelines

### Performance Is Everything
- The CPU has ~29,860 cycles per frame. Profile with `SPEEDTEST=1` or `VISUALTIME=1`.
- Prefer assembly for hot paths. C (via CMOC) is acceptable for object logic.
- The sprite compiler (`scripts/sprite2asm.py`) generates optimized unrolled ASM — don't hand-write sprite routines.
- 6309 builds are ~29% faster; test both CPU targets.

### Adding Game Content
- **New object:** Create `game/objects/XX-name/` with JSON descriptor + C or ASM source. Follow existing patterns.
- **New sprite:** Add PNG to `game/sprites/`, create JSON descriptor. The build pipeline compiles sprites to ASM automatically.
- **New level:** Create `game/levels/XX-name/` with JSON config, tilemap image, and level code (C or ASM).
- **New sound:** Add WAV to `game/sounds/`. ffmpeg resamples automatically during build.
- **New tileset:** Add PNG + JSON to `game/tiles/`.
- See `doc/DynoSpriteUsage.txt` for detailed content creation guides.

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
