*********************************************************************************
* DynoSprite - music.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* 3-voice music synthesis engine for CoCo 3.
* Step 1: Single square wave voice using the existing FIRQ/DAC infrastructure.
*
* This file contains Music_RefillBuffer, which must reside in the primary
* code page ($2000-$3FFF) since it is called from the FIRQ handler chain.
* Music_Start, Music_Stop, and the note table are in music-commands.asm
* (secondary code page at $E000).
*********************************************************************************


***********************************************************
* Music_RefillBuffer
*   Generate 256 samples of square wave into Sound_PageBuffer.
*   Called from Sound_RefillBuffer when music is active and no
*   sound effects are playing.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X
***********************************************************
*
Music_RefillBuffer
            ldx         #Sound_PageBuffer
            tst         Sound_OutputMode
            beq         MusicRefillDAC6@
* --- Orchestra-90 path ---
            ldd         Music_PhaseAccum
MusicRefillOrc90Loop@
            addd        Music_PhaseInc
            tsta
            bpl         MusicOrc90Low@
            pshs        b
            ldb         #$D0                    * high sample (~80% amplitude)
            stb         ,x+
            puls        b
            bra         MusicOrc90Next@
MusicOrc90Low@
            pshs        b
            ldb         #$30                    * low sample (~20% amplitude)
            stb         ,x+
            puls        b
MusicOrc90Next@
            cmpx        #Sound_PageBuffer+256
            bne         MusicRefillOrc90Loop@
            std         Music_PhaseAccum
            rts
* --- DAC6 path (internal 6-bit DAC) ---
MusicRefillDAC6@
            ldd         Music_PhaseAccum
MusicRefillDAC6Loop@
            addd        Music_PhaseInc
            tsta
            bpl         MusicDAC6Low@
            pshs        b
            ldb         #$D2                    * high sample ($D0 | $02 serial bit)
            stb         ,x+
            puls        b
            bra         MusicDAC6Next@
MusicDAC6Low@
            pshs        b
            ldb         #$32                    * low sample ($30 | $02 serial bit)
            stb         ,x+
            puls        b
MusicDAC6Next@
            cmpx        #Sound_PageBuffer+256
            bne         MusicRefillDAC6Loop@
            std         Music_PhaseAccum
            rts

