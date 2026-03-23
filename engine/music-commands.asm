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
*   Begin playing a square wave tone at the given frequency.
*
* - IN:      D = Phase increment (frequency * 65536 / AudioSamplingRate)
*            For example: 440 Hz = 440 * 65536 / 2000 = 14418 = $3852
* - OUT:     none
* - Trashed: A, B, X
***********************************************************
*
Music_Start
            std         Music_PhaseInc
            clr         Music_PhaseAccum
            clr         Music_PhaseAccum+1
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
*   Stop music playback.
*
* - IN:      none
* - OUT:     none
* - Trashed: A
***********************************************************
*
Music_Stop
            clr         Music_Playing
            * If sound effects are still playing, let them finish naturally
            tst         Sound_ChannelsPlaying
            bne         MusicStopDone@
            * No sound effects: shut down audio
            orcc        #$50                    * disable interrupts
 IFEQ SOUND_METHOD-2
            lda         #(PIA1B_Ctrl&$F7)       * clear CB2 (disable audio on SC77526)
            sta         $FF23
 ENDC
            jmp         System_DisableAudioInterrupt
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

