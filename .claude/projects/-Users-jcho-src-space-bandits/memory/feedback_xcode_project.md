---
name: Xcode project file conventions
description: How to correctly add game source files to the Space Bandits Xcode project (pbxproj)
type: feedback
---

When adding game files (objects, levels, etc.) to the Xcode project, use the conventions Xcode itself uses — not the conventions from the older bulk-imported files.

**Source files (.c, .h) under game/:**
- Use `sourceTree = SOURCE_ROOT` with path relative to the Xcode project root: `../game/objects/10-littleguy.c`
- Do NOT use `sourceTree = "<group>"` with deep relative paths like `../../../../game/objects/...`
- For .c files that contain `#ifdef __cplusplus` / CMOC C code, set `explicitFileType = sourcecode.cpp.objcpp` so Xcode compiles them as Objective-C++. Using `lastKnownFileType = sourcecode.c.c` will fail because the game code uses C++ extern blocks and Objective-C bridge patterns.
- Header files use `lastKnownFileType = sourcecode.c.h`

**Resource files (.json, .png) under game/sprites, game/tiles, game/images:**
- These groups already have a `path` set (e.g., `path = ../../../game/sprites`), so child file references use just the filename with `sourceTree = "<group>"`. This part worked fine.

**Why:** My initial attempt used the wrong path convention and file type for source files. Xcode created a "Recovered References" group for the orphaned reference and the file wasn't actually compiled. The user had to add it manually to show me the correct pattern.

**How to apply:** When adding new game source files to the pbxproj, always use `sourceTree = SOURCE_ROOT` with `../game/...` paths, and `explicitFileType = sourcecode.cpp.objcpp` for .c files. Validate with `plutil -lint` after editing.
