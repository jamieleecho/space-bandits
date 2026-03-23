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
*
* Music_Playing states:
*   0 = not playing
*   1 = playing normally
*   2 = fading out (play to next zero crossing, then stop)
*********************************************************************************


***********************************************************
* Music_RefillBuffer
*   Generate 256 samples into Sound_PageBuffer using wavetable
*   lookup. The high byte of the phase accumulator (0-255) indexes
*   into Music_WaveTable.
*
*   When Music_Playing = 2 (fade-out), generates samples until the
*   waveform is near center ($7C-$83), then fills the rest with
*   center value to avoid pops.
*
*   Note: serial bit ($02) is always OR'd into samples. This is
*   required for DAC6 and harmless for Orchestra-90.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_RefillBuffer
            ldu         #Sound_PageBuffer       * U = output buffer pointer
            ldy         Music_PhaseAccum        * Y = 16-bit phase accumulator
            lda         Music_Playing
            cmpa        #2
            lbeq        MusicRefillFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
* --- Normal playback ---
MusicRefillLoop@
            ldd         Music_PhaseInc          * D = phase increment
            leay        d,y                     * Y += D (advance phase)
            tfr         y,d                     * A = phase high byte
            tfr         a,b                     * B = table index (0-255, unsigned)
            ldx         #Music_WaveTable        * X = wavetable base
            abx                                 * X = table + index
            lda         ,x                      * A = waveform sample
            ora         #2                      * serial out bit
            sta         ,u+                     * store to output buffer
            cmpu        #Sound_PageBuffer+256
            bne         MusicRefillLoop@
            sty         Music_PhaseAccum
            rts

* --- Fade-out path (Music_Playing = 2) ---
* Generate samples until waveform is near center ($7C-$83),
* then fill remainder with center value. Avoids pops on stop.
MusicRefillFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
MusicFadeLoop@
            ldd         Music_PhaseInc
            leay        d,y
            tfr         y,d
            tfr         a,b
            ldx         #Music_WaveTable
            abx
            lda         ,x                      * A = sample value
            cmpa        #$7C                    * near center?
            blo         MusicFadeStore@         * no, below range
            cmpa        #$84
            blo         MusicFadeCross@         * yes, at zero crossing
MusicFadeStore@
            ora         #2                      * serial bit
            sta         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicFadeLoop@
            sty         Music_PhaseAccum        * didn't cross yet, try next buffer
            rts
MusicFadeCross@
            lda         #$82                    * center ($80) + serial bit
MusicFadeFill@
            sta         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicFadeFill@
            clr         Music_Playing           * done fading
            sty         Music_PhaseAccum
            rts

