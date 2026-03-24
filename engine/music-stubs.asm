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
*
* Controlled by MUSIC_VOICES (0-3). When 0, all stubs are no-ops.
*********************************************************************************


 IFEQ MUSIC_VOICES
* --- MUSIC_VOICES=0: all stubs are no-ops ---
Music_Start
Music_Start1
Music_Start2
Music_Stop
Music_Stop1
Music_Stop2
Music_RefillBuffer
Music_MixIntoBuffer
            rts

 ELSE
* --- MUSIC_VOICES >= 1 ---

***********************************************************
* Music_Start (stub) — set voice 0 frequency
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
* Music_Stop (stub) — stop all voices (fade-out)
***********************************************************
*
Music_Stop
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Music_Stop_Impl
            puls        a
            sta         $FFA2
            rts

***********************************************************
* Music_RefillBuffer (stub)
***********************************************************
*
Music_RefillBuffer
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Music_RefillBuffer_Impl
            puls        a
            sta         $FFA2
            rts

***********************************************************
* Music_MixIntoBuffer (stub)
***********************************************************
*
Music_MixIntoBuffer
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Music_MixIntoBuffer_Impl
            puls        a
            sta         $FFA2
            rts

 IFGE MUSIC_VOICES-2
***********************************************************
* Music_Start1 (stub) — set voice 1 frequency
***********************************************************
*
Music_Start1
            pshs        a
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            lda         1,s
            jsr         Music_Start1_Impl
            puls        a
            sta         $FFA2
            puls        a,pc

***********************************************************
* Music_Stop1 (stub) — stop voice 1 only
***********************************************************
*
Music_Stop1
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Music_Stop1_Impl
            puls        a
            sta         $FFA2
            rts

 ELSE
* MUSIC_VOICES=1: voice 1 stubs are no-ops
Music_Start1
Music_Stop1
            rts
 ENDC

 IFGE MUSIC_VOICES-3
***********************************************************
* Music_Start2 (stub) — set voice 2 frequency
***********************************************************
*
Music_Start2
            pshs        a
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            lda         1,s
            jsr         Music_Start2_Impl
            puls        a
            sta         $FFA2
            puls        a,pc

***********************************************************
* Music_Stop2 (stub) — stop voice 2 only
***********************************************************
*
Music_Stop2
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Music_Stop2_Impl
            puls        a
            sta         $FFA2
            rts

 ELSE
* MUSIC_VOICES<3: voice 2 stubs are no-ops
Music_Start2
Music_Stop2
            rts
 ENDC

 ENDC


***********************************************************
* Music_WaveTable
*   128-byte half sine wave lookup table (first half only).
*   Values range from $80 (center) up to $8A (peak) and back.
*   Amplitude is ±$0A (±10) from center. With 3 voices the max
*   combined amplitude is ±30, leaving headroom for SFX mixing.
*   The second half of the waveform is generated by negating
*   (two's complement) the lookup value, since the sine wave
*   is symmetric: sample[128+i] = $100 - sample[i].
*
*   This MUST remain in the secondary code page because
*   Music_RefillBuffer (FIRQ context) references it
*   and $4000 may not have the music code page mapped at that time.
***********************************************************
*
 IFGE MUSIC_VOICES-1
Music_WaveTable
            fcb     $80,$80,$80,$81,$81,$81,$81,$82,$82,$82,$82,$83,$83,$83,$83,$84
            fcb     $84,$84,$84,$84,$85,$85,$85,$85,$86,$86,$86,$86,$86,$87,$87,$87
            fcb     $87,$87,$87,$88,$88,$88,$88,$88,$88,$88,$89,$89,$89,$89,$89,$89
            fcb     $89,$89,$89,$89,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
            fcb     $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$89,$89,$89
            fcb     $89,$89,$89,$89,$89,$89,$89,$88,$88,$88,$88,$88,$88,$88,$87,$87
            fcb     $87,$87,$87,$87,$86,$86,$86,$86,$86,$85,$85,$85,$85,$84,$84,$84
            fcb     $84,$84,$83,$83,$83,$83,$82,$82,$82,$82,$81,$81,$81,$81,$80,$80
 ENDC

