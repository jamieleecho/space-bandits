*********************************************************************************
* DynoSprite - music-commands.asm
* Copyright (c) 2026, Space Bandits contributors
* All rights reserved.
*
* Music engine commands and data, residing in the secondary code page ($E000).
* Music_Start, Music_Stop, and the note frequency table.
*********************************************************************************


***********************************************************
* Music_Start
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
Music_Start
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
* Music_Stop
*   Begin fade-out: Music_RefillBuffer will continue generating
*   samples until the waveform crosses center, then stop.
*   This avoids pops from abrupt amplitude changes.
*
* - IN:      none
* - OUT:     none
* - Trashed: A
***********************************************************
*
Music_Stop
            lda         Music_Playing
            beq         MusicStopDone@          * already stopped
            lda         #2                      * set fade-out state
            sta         Music_Playing
MusicStopDone@
            rts


***********************************************************
* Music Note Table
*   Pre-calculated phase increments for musical notes.
*   Phase increment = note_freq * 65536 / 2000
*   Values are 16-bit words.
*
*   Usage: ldx #Music_NoteTable
*          ldd octave*24+note*2,x   * load phase increment
*          jsr Music_Start
***********************************************************
*
* Octave 3 (C3=131Hz to B3=247Hz)
Music_NoteTable
            fdb     4286            * C3  = 130.81 Hz
            fdb     4541            * C#3 = 138.59 Hz
            fdb     4811            * D3  = 146.83 Hz
            fdb     5097            * D#3 = 155.56 Hz
            fdb     5400            * E3  = 164.81 Hz
            fdb     5722            * F3  = 174.61 Hz
            fdb     6062            * F#3 = 185.00 Hz
            fdb     6423            * G3  = 196.00 Hz
            fdb     6804            * G#3 = 207.65 Hz
            fdb     7209            * A3  = 220.00 Hz
            fdb     7638            * A#3 = 233.08 Hz
            fdb     8092            * B3  = 246.94 Hz
* Octave 4 (C4=262Hz to B4=494Hz)
            fdb     8573            * C4  = 261.63 Hz (middle C)
            fdb     9083            * C#4 = 277.18 Hz
            fdb     9623            * D4  = 293.66 Hz
            fdb     10195           * D#4 = 311.13 Hz
            fdb     10801           * E4  = 329.63 Hz
            fdb     11444           * F4  = 349.23 Hz
            fdb     12124           * F#4 = 369.99 Hz
            fdb     12845           * G4  = 392.00 Hz
            fdb     13609           * G#4 = 415.30 Hz
            fdb     14418           * A4  = 440.00 Hz
            fdb     15275           * A#4 = 466.16 Hz
            fdb     16183           * B4  = 493.88 Hz
* Octave 5 (C5=523Hz to B5=988Hz)
            fdb     17146           * C5  = 523.25 Hz
            fdb     18166           * C#5 = 554.37 Hz
            fdb     19246           * D5  = 587.33 Hz
            fdb     20390           * D#5 = 622.25 Hz
            fdb     21603           * E5  = 659.26 Hz
            fdb     22887           * F5  = 698.46 Hz
            fdb     24248           * F#5 = 739.99 Hz
            fdb     25690           * G5  = 783.99 Hz
            fdb     27217           * G#5 = 830.61 Hz
            fdb     28836           * A5  = 880.00 Hz
            fdb     30551           * A#5 = 932.33 Hz
            fdb     32367           * B5  = 987.77 Hz

* Note index constants (offset in bytes from start of octave, each entry is 2 bytes)
MUSIC_NOTE_C            equ     0
MUSIC_NOTE_CS           equ     2
MUSIC_NOTE_D            equ     4
MUSIC_NOTE_DS           equ     6
MUSIC_NOTE_E            equ     8
MUSIC_NOTE_F            equ     10
MUSIC_NOTE_FS           equ     12
MUSIC_NOTE_G            equ     14
MUSIC_NOTE_GS           equ     16
MUSIC_NOTE_A            equ     18
MUSIC_NOTE_AS           equ     20
MUSIC_NOTE_B            equ     22

* Octave offsets (in bytes, 12 notes * 2 bytes each = 24 bytes per octave)
MUSIC_OCTAVE_3          equ     0
MUSIC_OCTAVE_4          equ     24
MUSIC_OCTAVE_5          equ     48


***********************************************************
* Music_WaveTable
*   256-byte sine wave lookup table.
*   Values range from $50 (low) to $B0 (high), centered at $80.
*   The phase accumulator high byte (0-255) indexes this table.
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
            fcb     $80,$7F,$7E,$7C,$7B,$7A,$79,$78,$77,$75,$74,$73,$72,$71,$70,$6F
            fcb     $6E,$6D,$6B,$6A,$69,$68,$67,$66,$65,$64,$63,$62,$62,$61,$60,$5F
            fcb     $5E,$5D,$5C,$5C,$5B,$5A,$59,$59,$58,$57,$57,$56,$56,$55,$55,$54
            fcb     $54,$53,$53,$52,$52,$52,$51,$51,$51,$51,$51,$50,$50,$50,$50,$50
            fcb     $50,$50,$50,$50,$50,$50,$51,$51,$51,$51,$51,$52,$52,$52,$53,$53
            fcb     $54,$54,$55,$55,$56,$56,$57,$57,$58,$59,$59,$5A,$5B,$5C,$5C,$5D
            fcb     $5E,$5F,$60,$61,$62,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6D
            fcb     $6E,$6F,$70,$71,$72,$73,$74,$75,$77,$78,$79,$7A,$7B,$7C,$7E,$7F

