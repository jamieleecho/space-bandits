*********************************************************************************
* DynoSprite - music-commands.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music engine command implementations, residing in the tertiary code page
* ($4000). These are called via stubs in the secondary code page (music-stubs.asm)
* that swap this page in/out of $4000-$5FFF via $FFA2.
*
* Controlled by MUSIC_VOICES (0-3). When 0, this file emits nothing.
*********************************************************************************

 IFGE MUSIC_VOICES-1

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


 IFGE MUSIC_VOICES-2
***********************************************************
* Music_Start1_Impl — set voice 1 frequency
***********************************************************
*
Music_Start1_Impl
            std         Music_PhaseInc1
            tst         Music_Playing
            bne         >
            ldd         Music_PhaseInc0
            bra         Music_Start_Impl
!           lda         #1
            sta         Music_Playing
            rts
 ENDC


 IFGE MUSIC_VOICES-3
***********************************************************
* Music_Start2_Impl — set voice 2 frequency
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
 ENDC


***********************************************************
* Music_Stop_Impl — stop all voices (begin fade-out)
***********************************************************
*
Music_Stop_Impl
            lda         Music_Playing
            beq         MusicStopDone@
            lda         #2
            sta         Music_Playing
MusicStopDone@
            rts


 IFGE MUSIC_VOICES-2
***********************************************************
* Music_Stop1_Impl — silence voice 1 only
***********************************************************
*
Music_Stop1_Impl
            ldd         #0
            std         Music_PhaseInc1
            rts
 ENDC


 IFGE MUSIC_VOICES-3
***********************************************************
* Music_Stop2_Impl — silence voice 2 only
***********************************************************
*
Music_Stop2_Impl
            ldd         #0
            std         Music_PhaseInc2
            rts
 ENDC


***********************************************************
* Music_RefillBuffer_Impl
*   Generate 256 samples into Sound_PageBuffer.
*   Number of voices depends on MUSIC_VOICES setting.
***********************************************************
*
Music_Sample    rmb     1
*
Music_RefillBuffer_Impl
            ldu         #Sound_PageBuffer
            lda         Music_Playing
            cmpa        #2
            lbeq        MusicRefillFade
            andcc       #$AF
MusicRefillLoop@
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
            bpl         V0Store@
            negb
V0Store@    subb        #$80
            addb        Music_Sample
 IFGE MUSIC_VOICES-2
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
 ENDC
 IFGE MUSIC_VOICES-3
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
 ENDC
            orb         #2
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicRefillLoop@
            rts

* --- Fade-out path ---
MusicRefillFade
            andcc       #$AF
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
 IFGE MUSIC_VOICES-2
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
 ENDC
 IFGE MUSIC_VOICES-3
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
 ENDC
            cmpb        #$7C
            blo         MusicFadeStore@
            cmpb        #$84
            blo         MusicFadeCross@
MusicFadeStore@
            orb         #2
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            lbne        MusicFadeLoop@
            rts
MusicFadeCross@
            lda         #$82
MusicFadeFill@
            sta         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicFadeFill@
            clr         Music_Playing
            rts


***********************************************************
* Music_MixIntoBuffer_Impl
*   Add music samples into an existing Sound_PageBuffer.
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
MusicMixLoop@
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
            bpl         MV0Store@
            negb
MV0Store@   subb        #$80
            addb        Music_MixSample
 IFGE MUSIC_VOICES-2
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
 ENDC
 IFGE MUSIC_VOICES-3
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
 ENDC
            addb        ,u
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            bne         MusicMixLoop@
            rts

* --- Fade-out path ---
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
 IFGE MUSIC_VOICES-2
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
 ENDC
 IFGE MUSIC_VOICES-3
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
 ENDC
            cmpb        #$FC
            blt         MusicMixFadeStore@
            cmpb        #$04
            blt         MusicMixFadeCross@
MusicMixFadeStore@
            addb        ,u
            stb         ,u+
            cmpu        #Sound_PageBuffer+256
            lbne        MusicMixFadeLoop@
            rts
MusicMixFadeCross@
            clr         Music_Playing
            rts

 ENDC

