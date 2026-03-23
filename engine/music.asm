*********************************************************************************
* DynoSprite - music.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music synthesis engine for CoCo 3.
* Uses wavetable lookup with a 16-bit phase accumulator.
*
* This file contains Music_RefillBuffer, which must reside in the primary
* code page ($2000-$3FFF) since it is called from the FIRQ handler chain.
* Music_Start, Music_Stop, note table, and wavetable data are in
* music-commands.asm (secondary code page at $E000).
*********************************************************************************


***********************************************************
* Music_RefillBuffer
*   Generate 256 samples into Sound_PageBuffer using wavetable
*   lookup. The high byte of the phase accumulator (0-255) indexes
*   into Music_WaveTable.
*
*   Called from Sound_RefillBuffer when music is active and no
*   sound effects are playing.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_RefillBuffer
            ldu         #Sound_PageBuffer       * U = output buffer pointer
            ldy         Music_PhaseAccum        * Y = 16-bit phase accumulator
            tst         Sound_OutputMode
            beq         MusicRefillDAC6@
* --- Orchestra-90 path ---
MusicRefillOrc90Loop@
            ldd         Music_PhaseInc          * D = phase increment
            leay        d,y                     * Y += D (advance phase)
            tfr         y,d                     * A = phase high byte
            tfr         a,b                     * B = table index (0-255, unsigned)
            ldx         #Music_WaveTable        * X = wavetable base
            abx                                 * X = table + index
            lda         ,x                      * A = waveform sample
            sta         ,u+                     * store to output buffer
            cmpu        #Sound_PageBuffer+256
            bne         MusicRefillOrc90Loop@
            sty         Music_PhaseAccum
            rts
* --- DAC6 path (internal 6-bit DAC) ---
MusicRefillDAC6@
MusicRefillDAC6Loop@
            ldd         Music_PhaseInc          * D = phase increment
            leay        d,y                     * Y += D (advance phase)
            tfr         y,d                     * A = phase high byte
            tfr         a,b                     * B = table index (0-255, unsigned)
            ldx         #Music_WaveTable        * X = wavetable base
            abx                                 * X = table + index
            lda         ,x                      * A = waveform sample
            ora         #2                      * set serial out bit for DriveWire
            sta         ,u+                     * store to output buffer
            cmpu        #Sound_PageBuffer+256
            bne         MusicRefillDAC6Loop@
            sty         Music_PhaseAccum
            rts

