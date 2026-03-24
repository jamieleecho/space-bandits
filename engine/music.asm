*********************************************************************************
* DynoSprite - music.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music synthesis engine for CoCo 3 — 3-voice wavetable.
*
* Music_RefillBuffer and Music_MixIntoBuffer are in music-stubs.asm
* (secondary code page at $E000). The secondary page is always mapped
* during FIRQ since disk I/O disables interrupts before unmapping it.
*
* Music_Start/Stop implementations are in music-commands.asm (tertiary
* code page at $4000), called via stubs in music-stubs.asm.
*
* This file is intentionally empty — all music code has been moved to
* the secondary and tertiary pages to free primary page space.
*********************************************************************************

