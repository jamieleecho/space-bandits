*********************************************************************************
* DynoSprite - music-commands.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music engine command implementations, residing in the tertiary code page
* ($4000). These are called via stubs in the secondary code page (music-stubs.asm)
* that swap this page in/out of $4000-$5FFF via $FFA2.
*
* Music_WaveTable remains in the secondary code page (music-stubs.asm)
* for accessibility during FIRQ and from game code.
*********************************************************************************


***********************************************************
* Music_Start_Impl — set voice 0 frequency and start music
*
* - IN:      D = Phase increment (0 to silence voice 0)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_Start_Impl
            std         Music_PhaseInc0
            lda         Music_Playing
            beq         MusicColdStart@
            lda         #1                      * cancel any fade-out (state 2 -> 1)
            sta         Music_Playing
            rts
MusicColdStart@
            lda         #1
            sta         Music_Playing
            * If sound effects are already running, the FIRQ is active and
            * music will start automatically when effects finish.
            tst         Sound_ChannelsPlaying
            bne         MusicStartDone@
            * No sound effects playing: we need to start the audio system
            jsr         Music_RefillBuffer_Impl * direct call (same page, no stub needed)
            ldx         #Sound_PageBuffer
            stx         System_SndBufferPtr
            lda         ,x                      * load first sample
            tst         Sound_OutputMode
            beq         MusicStartDAC6@
MusicStartOrc90@
            sta         $FF7A
            sta         $FF7B
            bra         MusicStartAudio@
MusicStartDAC6@
            ora         #2                      * serial out bit
            sta         $FF20
            lda         #(PIA1B_Ctrl|$08)       * enable audio on SC77526
            sta         $FF23
MusicStartAudio@
            ldd         #(3579545/AudioSamplingRate)-1
            jmp         System_EnableAudioInterrupt
MusicStartDone@
            rts


***********************************************************
* Music_Start1_Impl — set voice 1 frequency
*   If music is not playing, starts it.
*
* - IN:      D = Phase increment
* - OUT:     none
* - Trashed: A, B
***********************************************************
*
Music_Start1_Impl
            std         Music_PhaseInc1
            tst         Music_Playing
            bne         >
            * Music not yet active — start it via voice 0 path
            ldd         Music_PhaseInc0
            bra         Music_Start_Impl
!           lda         #1                      * cancel any fade-out
            sta         Music_Playing
            rts


***********************************************************
* Music_Start2_Impl — set voice 2 frequency
*
* - IN:      D = Phase increment
* - OUT:     none
* - Trashed: A, B
***********************************************************
*
Music_Start2_Impl
            std         Music_PhaseInc2
            tst         Music_Playing
            bne         >
            ldd         Music_PhaseInc0
            bra         Music_Start_Impl
!           lda         #1
            sta         Music_Playing
            rts


***********************************************************
* Music_Stop_Impl — stop all voices (begin fade-out)
*
* - IN:      none
* - OUT:     none
* - Trashed: A
***********************************************************
*
Music_Stop_Impl
            lda         Music_Playing
            beq         MusicStopDone@          * already stopped
            lda         #2                      * set fade-out state
            sta         Music_Playing
MusicStopDone@
            rts


***********************************************************
* Music_Stop1_Impl — silence voice 1 only
*
* - IN:      none
* - OUT:     none
* - Trashed: A, B
***********************************************************
*
Music_Stop1_Impl
            ldd         #0
            std         Music_PhaseInc1
            rts


***********************************************************
* Music_Stop2_Impl — silence voice 2 only
*
* - IN:      none
* - OUT:     none
* - Trashed: A, B
***********************************************************
*
Music_Stop2_Impl
            ldd         #0
            std         Music_PhaseInc2
            rts


***********************************************************
* Music_RefillBuffer_Impl
*   Generate 256 samples into Sound_PageBuffer by mixing 3 voices.
*   Each voice uses the half-wavetable with its own phase accumulator.
*   Voices with PhaseInc=0 are silent (phase stays at 0, table[0]=$80,
*   offset=0 after centering).
*
*   When Music_Playing = 2 (fade-out), generates samples until the
*   mixed waveform is near center, then fills with center value.
*
*   Note: serial bit ($02) is always OR'd into samples.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_Sample    rmb     1
*
Music_RefillBuffer_Impl
            ldu         #Sound_PageBuffer       * U = output buffer pointer
            lda         Music_Playing
            cmpa        #2
            lbeq        MusicRefillFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
* --- Normal 3-voice playback ---
MusicRefillLoop@
            lda         #$80                    * A = running sum, start at center
            sta         Music_Sample
            * --- Voice 0 ---
            ldy         Music_PhaseAccum0
            ldd         Music_PhaseInc0
            leay        d,y
            sty         Music_PhaseAccum0
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         V0Store@
            negb
V0Store@    subb        #$80
            addb        Music_Sample
            stb         Music_Sample
            * --- Voice 1 ---
            ldy         Music_PhaseAccum1
            ldd         Music_PhaseInc1
            leay        d,y
            sty         Music_PhaseAccum1
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         V1Store@
            negb
V1Store@    subb        #$80
            addb        Music_Sample
            stb         Music_Sample
            * --- Voice 2 ---
            ldy         Music_PhaseAccum2
            ldd         Music_PhaseInc2
            leay        d,y
            sty         Music_PhaseAccum2
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         V2Store@
            negb
V2Store@    subb        #$80
            addb        Music_Sample
            orb         #2                      * serial out bit
            stb         ,u+                     * store mixed sample
            cmpu        #Sound_PageBuffer+256
            bne         MusicRefillLoop@
            rts

* --- Fade-out path (Music_Playing = 2) ---
MusicRefillFade
            andcc       #$AF                    * re-enable interrupts so VSync is not delayed
MusicFadeLoop@
            lda         #$80
            sta         Music_Sample
            * --- Voice 0 ---
            ldy         Music_PhaseAccum0
            ldd         Music_PhaseInc0
            leay        d,y
            sty         Music_PhaseAccum0
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         FV0Store@
            negb
FV0Store@   subb        #$80
            addb        Music_Sample
            stb         Music_Sample
            * --- Voice 1 ---
            ldy         Music_PhaseAccum1
            ldd         Music_PhaseInc1
            leay        d,y
            sty         Music_PhaseAccum1
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         FV1Store@
            negb
FV1Store@   subb        #$80
            addb        Music_Sample
            stb         Music_Sample
            * --- Voice 2 ---
            ldy         Music_PhaseAccum2
            ldd         Music_PhaseInc2
            leay        d,y
            sty         Music_PhaseAccum2
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         FV2Store@
            negb
FV2Store@   subb        #$80
            addb        Music_Sample
            * B = final mixed sample — check if near center
            cmpb        #$7C
            blo         MusicFadeStore@
            cmpb        #$84
            blo         MusicFadeCross@
MusicFadeStore@
            orb         #2
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            lbne        MusicFadeLoop@
            rts                                 * didn't cross yet, try next buffer
MusicFadeCross@
            lda         #$82                    * center ($80) + serial bit
MusicFadeFill@
            sta         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicFadeFill@
            clr         Music_Playing
            rts


***********************************************************
* Music_MixIntoBuffer_Impl
*   Add 3-voice music samples into an existing Sound_PageBuffer
*   that already contains sound effect data.
*
* - IN:      none (DP may be invalid if called from FIRQ)
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_MixSample     rmb     1
*
Music_MixIntoBuffer_Impl
            ldu         #Sound_PageBuffer
            lda         Music_Playing
            cmpa        #2
            beq         MusicMixFade
            andcc       #$AF
* --- Normal 3-voice mix into SFX buffer ---
MusicMixLoop@
            clr         Music_MixSample         * signed offset accumulator starts at 0
            * --- Voice 0 ---
            ldy         Music_PhaseAccum0
            ldd         Music_PhaseInc0
            leay        d,y
            sty         Music_PhaseAccum0
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MV0Store@
            negb
MV0Store@   subb        #$80
            addb        Music_MixSample
            stb         Music_MixSample
            * --- Voice 1 ---
            ldy         Music_PhaseAccum1
            ldd         Music_PhaseInc1
            leay        d,y
            sty         Music_PhaseAccum1
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MV1Store@
            negb
MV1Store@   subb        #$80
            addb        Music_MixSample
            stb         Music_MixSample
            * --- Voice 2 ---
            ldy         Music_PhaseAccum2
            ldd         Music_PhaseInc2
            leay        d,y
            sty         Music_PhaseAccum2
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MV2Store@
            negb
MV2Store@   subb        #$80
            addb        Music_MixSample
            addb        ,u                      * add to existing SFX sample
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicMixLoop@
            rts

* --- Fade-out path: mix 3 voices with fade until zero crossing ---
MusicMixFade
            andcc       #$AF
MusicMixFadeLoop@
            clr         Music_MixSample
            * --- Voice 0 ---
            ldy         Music_PhaseAccum0
            ldd         Music_PhaseInc0
            leay        d,y
            sty         Music_PhaseAccum0
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MFV0Store@
            negb
MFV0Store@  subb        #$80
            addb        Music_MixSample
            stb         Music_MixSample
            * --- Voice 1 ---
            ldy         Music_PhaseAccum1
            ldd         Music_PhaseInc1
            leay        d,y
            sty         Music_PhaseAccum1
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MFV1Store@
            negb
MFV1Store@  subb        #$80
            addb        Music_MixSample
            stb         Music_MixSample
            * --- Voice 2 ---
            ldy         Music_PhaseAccum2
            ldd         Music_PhaseInc2
            leay        d,y
            sty         Music_PhaseAccum2
            tfr         y,d
            tfr         a,b
            andb        #$7F
            ldx         #Music_WaveTable
            abx
            ldb         ,x
            tsta
            bpl         MFV2Store@
            negb
MFV2Store@  subb        #$80
            addb        Music_MixSample
            * B = signed music offset sum — check if near center (0)
            cmpb        #$FC                    * -4 in signed
            blt         MusicMixFadeStore@
            cmpb        #$04
            blt         MusicMixFadeCross@
MusicMixFadeStore@
            addb        ,u                      * add to existing SFX sample
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            lbne        MusicMixFadeLoop@
            rts                                 * didn't cross yet, try next buffer
MusicMixFadeCross@
            clr         Music_Playing
            rts

