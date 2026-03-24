*********************************************************************************
* DynoSprite - music-commands.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music engine command implementations, residing in the tertiary code page
* ($C000). These are called via stubs in the secondary code page (music-stubs.asm)
* that swap this page in/out of $C000-$DFFF via $FFA6.
*
* Music_WaveTable and Music_NoteTable remain in the secondary code page
* (music-stubs.asm) for accessibility during FIRQ and from game code.
*********************************************************************************


***********************************************************
* Music_Start_Impl
*   Begin playing a tone at the given frequency.
*   Phase accumulator is NOT reset, so note transitions are
*   click-free (waveform continues smoothly).
*
* - IN:      D = Phase increment (frequency * 65536 / AudioSamplingRate)
*            For example: 440 Hz = 440 * 65536 / 2000 = 14418 = $3852
* - OUT:     none
* - Trashed: A, B, X, Y, U
***********************************************************
*
Music_Start_Impl
            std         Music_PhaseInc
            * If music is already running, just update the frequency.
            * The next buffer refill will pick up the new phase increment
            * seamlessly — no pointer reset, no timer restart, no pop.
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
            jsr         Music_RefillBuffer
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
* Music_Stop_Impl
*   Begin fade-out: Music_RefillBuffer will continue generating
*   samples until the waveform crosses center, then stop.
*   This avoids pops from abrupt amplitude changes.
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

