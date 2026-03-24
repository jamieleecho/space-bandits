*********************************************************************************
* DynoSprite - music-stubs.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music engine stubs residing in the secondary code page ($E000).
* These swap the tertiary music code page into $4000-$5FFF via $FFA2,
* call the implementation, then restore the previous page mapping.
*
* Music_WaveTable remains here (secondary page) because it is accessed by
* Music_RefillBuffer during FIRQ, when $4000 may have sprite code mapped.
*********************************************************************************


***********************************************************
* Music_Start (stub)
*   Swap in the music code page and call Music_Start_Impl.
*
* - IN:      D = Phase increment (frequency * 65536 / AudioSamplingRate)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_Start
            pshs        a                   * save A (high byte of D parameter)
            lda         $FFA2               * read current $4000-$5FFF page
            pshs        a                   * save it on stack
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2               * map music code page to $4000
            lda         1,s                 * restore original A from stack
            jsr         Music_Start_Impl    * call implementation at $4000 with D intact
            puls        a                   * restore saved $FFA2 value
            sta         $FFA2               * restore previous $4000-$5FFF mapping
            puls        a,pc                * discard saved A and return


***********************************************************
* Music_Stop (stub)
*   Swap in the music code page and call Music_Stop_Impl.
*
* - IN:      none
* - OUT:     none
* - Trashed: A
***********************************************************
*
Music_Stop
            lda         $FFA2               * read current $4000-$5FFF page
            pshs        a                   * save it on stack
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2               * map music code page to $4000
            jsr         Music_Stop_Impl     * call implementation at $4000
            puls        a                   * restore saved $FFA2 value
            sta         $FFA2               * restore previous $4000-$5FFF mapping
            rts


***********************************************************
* Music_MixIntoBuffer
*   Add music samples into an existing Sound_PageBuffer that
*   already contains sound effect data. Each music sample is
*   converted to a signed offset from center ($80) and added
*   to the existing buffer contents.
*
*   Called as a tail-call from Sound_RefillBuffer when both
*   SFX and music are active simultaneously.
*
*   This lives in the secondary code page (not primary) to save
*   space. The secondary page is always mapped at $E000 during
*   FIRQ since disk I/O disables interrupts before unmapping it.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_MixIntoBuffer
            ldu         #Sound_PageBuffer       * U = buffer pointer
            ldy         Music_PhaseAccum        * Y = 16-bit phase accumulator
            lda         Music_Playing
            cmpa        #2
            beq         MusicMixFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
* --- Normal playback: add music to existing SFX buffer ---
MusicMixLoop@
            ldd         Music_PhaseInc          * D = phase increment
            leay        d,y                     * Y += D (advance phase)
            tfr         y,d                     * A = phase high byte
            tfr         a,b                     * B = phase high byte (for ABX)
            andb        #$7F                    * B = half-table index (0-127)
            ldx         #Music_WaveTable        * X = wavetable base (128 entries)
            abx                                 * X = table + index
            ldb         ,x                      * B = waveform sample from first half
            tsta                                * test bit 7 of original phase byte
            bpl         MusicMixStore@          * if positive half (0-127), use sample as-is
            negb                                * negate for second half (128-255)
MusicMixStore@
            subb        #$80                    * convert to signed offset from center
            addb        ,u                      * add to existing SFX sample
            stb         ,u+                     * store mixed result
            cmpu        #Sound_PageBuffer+256
            bne         MusicMixLoop@
            sty         Music_PhaseAccum
            rts

* --- Fade-out path: mix with fade until zero crossing ---
MusicMixFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
MusicMixFadeLoop@
            ldd         Music_PhaseInc
            leay        d,y
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MusicMixFadeCheck@
            negb
MusicMixFadeCheck@
            cmpb        #$7C                    * near center?
            blo         MusicMixFadeStore@      * no, below range
            cmpb        #$84
            blo         MusicMixFadeCross@      * yes, at zero crossing
MusicMixFadeStore@
            subb        #$80                    * convert to signed offset from center
            addb        ,u                      * add to existing SFX sample
            stb         ,u+                     * store mixed result
            cmpu        #Sound_PageBuffer+256
            bne         MusicMixFadeLoop@
            sty         Music_PhaseAccum        * didn't cross yet, try next buffer
            rts
MusicMixFadeCross@
            * Zero crossing reached — stop music. Remaining buffer keeps SFX only.
            clr         Music_Playing
            sty         Music_PhaseAccum
            rts


***********************************************************
* Music_WaveTable
*   128-byte half sine wave lookup table (first half only).
*   Values range from $80 (center) up to $B0 (peak) and back.
*   The second half of the waveform is generated by negating
*   (two's complement) the lookup value, since the sine wave
*   is symmetric: sample[128+i] = $100 - sample[i].
*
*   This MUST remain in the secondary code page because
*   Music_RefillBuffer (primary page, FIRQ context) references it
*   and $C000 may not have the music code page mapped at that time.
***********************************************************
*
Music_WaveTable
            fcb     $80,$81,$82,$84,$85,$86,$87,$88,$89,$8B,$8C,$8D,$8E,$8F,$90,$91
            fcb     $92,$93,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9E,$9F,$A0,$A1
            fcb     $A2,$A3,$A4,$A4,$A5,$A6,$A7,$A7,$A8,$A9,$A9,$AA,$AA,$AB,$AB,$AC
            fcb     $AC,$AD,$AD,$AE,$AE,$AE,$AF,$AF,$AF,$AF,$AF,$B0,$B0,$B0,$B0,$B0
            fcb     $B0,$B0,$B0,$B0,$B0,$B0,$AF,$AF,$AF,$AF,$AF,$AE,$AE,$AE,$AD,$AD
            fcb     $AC,$AC,$AB,$AB,$AA,$AA,$A9,$A9,$A8,$A7,$A7,$A6,$A5,$A4,$A4,$A3
            fcb     $A2,$A1,$A0,$9F,$9E,$9E,$9D,$9C,$9B,$9A,$99,$98,$97,$96,$95,$93
            fcb     $92,$91,$90,$8F,$8E,$8D,$8C,$8B,$89,$88,$87,$86,$85,$84,$82,$81

