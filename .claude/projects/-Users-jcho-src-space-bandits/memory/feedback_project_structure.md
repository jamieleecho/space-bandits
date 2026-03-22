---
name: Project structure lessons for adding game content
description: Non-obvious conventions for adding levels, objects, sprites, tilesets, and images to Space Bandits
type: feedback
---

Key things that aren't obvious from reading any single file:

**File layout is flat, not nested:**
- Objects are `game/objects/XX-name.c` and `.h` directly — no subdirectories per object.
- Levels are `game/levels/XX-name.c` and `.json` directly — no subdirectories per level.
- Sprites, tiles, sounds, and images are also flat.

**Numbering matters and must be consistent across file types:**
- Object group numbers (e.g., 10) must match across: the `.c`/`.h` filename prefix, the sprite JSON `Group` field, and the `GroupID` referenced in level JSON.
- Level numbers must match across: the level `.c`/`.json` filename prefix, the splash image prefix (`game/images/XX-levelN.png`), and the index in `images.json`.

**Sprite sheets are per-group, not global:**
- Each sprite group JSON can reference its own PNG file. You don't have to add sprites to the shared `01-sprites.png`. Creating a separate small PNG per group works fine.

**CoCo 3 palette constraint:**
- Each channel is 2 bits: values are 0, 85, 170, or 255 only. This gives 64 possible RGB colors.
- Each screen/tileset uses at most 16 colors. PNGs must be indexed (palette mode 'P').
- Magenta (255, 0, 255) is the standard transparent color for sprites.

**images.json is ordered by index:**
- Entry 0 = main menu, entry 1 = level 1 splash, entry 2 = level 2 splash, etc. Adding a new level means appending to this array.

**Tileset image can match TilemapSize:**
- The tileset PNG dimensions should match the `TilemapSize` in the tileset JSON (or be larger if more tile variety is needed). The existing moon tileset is taller than its TilemapSize because it contains extra tile rows.

**Function naming in RegisterObject/RegisterLevel:**
- Functions passed to `RegisterObject` and `RegisterLevel` use only an initial capital, not camelCase. Examples: `BadguyInit` (not `BadGuyInit`), `ShipcounterClassInit` (not `ShipCounterClassInit`), `GameoverUpdate` (not `GameOverUpdate`), `LittleguyInit` (not `LittleGuyInit`).
- Struct/typedef names CAN be camelCase (`BadGuyObjectState`, `ShipCounterObjectState`) — only the function names follow the single-capital convention.

**DynospriteObject_DataSize and DynospriteObject_InitSize (in object .h files):**
- These are defined inside the `#ifdef DynospriteObject_DataDefinition` block only.
- `DynospriteObject_DataSize` = the size in bytes of the object's state struct (byte = 1, word = 2, etc.). Must match `sizeof(ObjectState)`.
- `DynospriteObject_InitSize` = the number of bytes passed to the object's Init function via `initData`. This data comes from the `InitData` array in the level JSON file. If `InitData` is empty in the JSON, this should be 0.
- Example: a state struct with 1 byte field → DataSize = 1. A state struct with 3 words and 6 bytes → DataSize = 12.

**Object C file patterns:**
- `ClassInit` function must be wrapped in `#ifdef __APPLE__` — it's only used by the macOS build. The CoCo build handles class init differently via the engine.
- All object and level `.c` files are wrapped in `#ifdef __cplusplus extern "C" {` / `#endif` brackets.
- The `active` field in level JSON: `3` = active, `0` = inactive. Not boolean — don't use `1` or `true`.

**Generating pixel art PNGs programmatically:**
- Use Python Pillow to create indexed PNGs: `Image.new('P', (w, h))` with `img.putpalette()` using the CoCo 3 color values.
- Pillow may need to be installed: `pip3 install --break-system-packages Pillow`

**Testing a specific level:**
- Change `FirstLevel` in `game/defaults-config.json` to jump straight to a specific level (e.g., set to 3 to test level 3 without playing through earlier levels).

**When adding a complete new level, you need to create/modify:**
1. `game/tiles/XX-name.json` + `.png` (tileset)
2. `game/sprites/XX-name.json` + `.png` (sprite group, if new objects)
3. `game/objects/XX-name.c` + `.h` (object code, if new objects)
4. `game/levels/XX-name.json` + `.c` (level config + code)
5. `game/images/XX-levelN.png` (splash screen)
6. `game/images/images.json` (add splash entry)
7. Xcode project pbxproj (all new files)

**Why:** During the first level creation, several of these relationships weren't clear and required exploring multiple files to piece together. The numbering consistency requirement in particular caused confusion.

**How to apply:** When creating new game content, use this as a checklist. Verify numbering is consistent across all file types before building.
