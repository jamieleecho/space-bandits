/*
 * sequencer.h — 3-voice music sequencer
 *
 * Include this header in any level .c file that needs music playback.
 * Each level gets its own static copy of the sequencer code and state.
 *
 * Song data is defined as parallel arrays in the level's own code:
 *   word notes[] — phase increments (0 = rest, terminates with dur=0)
 *   byte durs[]  — durations in ticks (0 = end of track, loops to start)
 *
 * Usage:
 *   SequencerPlay(v0_notes, v0_durs, v1_notes, v1_durs,
 *                 v2_notes, v2_durs, tempo);
 *   // In CalculateBkgrndNewXY, call once per frame:
 *   SequencerTick();
 *   // To stop:
 *   SequencerStop();
 */

#ifndef _Sequencer_h
#define _Sequencer_h

/* Sequencer state (static per-level) */
static byte seq_playing;
static byte seq_tempo;          /* frames per tick */
static byte seq_tickCounter;    /* counts down to next tick */

static word *seq_notes0;
static byte *seq_durs0;
static word seq_pos0;
static byte seq_rem0;

static word *seq_notes1;
static byte *seq_durs1;
static word seq_pos1;
static byte seq_rem1;

static word *seq_notes2;
static byte *seq_durs2;
static word seq_pos2;
static byte seq_rem2;


/* Start a voice playing its current note (0 = rest/silence) */
static void seq_startVoice0(void) {
    MusicStart(seq_notes0[seq_pos0]);
}

static void seq_startVoice1(void) {
    MusicStart1(seq_notes1[seq_pos1]);
}

static void seq_startVoice2(void) {
    MusicStart2(seq_notes2[seq_pos2]);
}


/* Advance a voice to its next note, looping at end */
static void seq_advanceVoice0(void) {
    seq_pos0++;
    if (seq_durs0[seq_pos0] == 0) {
        seq_pos0 = 0;  /* loop */
    }
    seq_rem0 = seq_durs0[seq_pos0];
    seq_startVoice0();
}

static void seq_advanceVoice1(void) {
    seq_pos1++;
    if (seq_durs1[seq_pos1] == 0) {
        seq_pos1 = 0;
    }
    seq_rem1 = seq_durs1[seq_pos1];
    seq_startVoice1();
}

static void seq_advanceVoice2(void) {
    seq_pos2++;
    if (seq_durs2[seq_pos2] == 0) {
        seq_pos2 = 0;
    }
    seq_rem2 = seq_durs2[seq_pos2];
    seq_startVoice2();
}


/*
 * SequencerPlay — begin playing a 3-voice song.
 *
 * notes0/durs0: voice 0 track (melody)
 * notes1/durs1: voice 1 track (harmony)
 * notes2/durs2: voice 2 track (harmony)
 * tempo: frames per tick
 *
 * Pass NULL/0 for unused voices.
 */
static void SequencerPlay(word *notes0, byte *durs0,
                          word *notes1, byte *durs1,
                          word *notes2, byte *durs2,
                          byte tempo) {
    seq_tempo = tempo;
    seq_tickCounter = tempo;

    seq_notes0 = notes0;
    seq_durs0 = durs0;
    seq_pos0 = 0;
    seq_rem0 = durs0 ? durs0[0] : 0;

    seq_notes1 = notes1;
    seq_durs1 = durs1;
    seq_pos1 = 0;
    seq_rem1 = durs1 ? durs1[0] : 0;

    seq_notes2 = notes2;
    seq_durs2 = durs2;
    seq_pos2 = 0;
    seq_rem2 = durs2 ? durs2[0] : 0;

    /* Start first notes */
    if (notes0) seq_startVoice0();
    if (notes1) seq_startVoice1();
    if (notes2) seq_startVoice2();

    seq_playing = 1;
}


/*
 * SequencerStop — stop all voices with fade-out.
 */
MAYBE_UNUSED static void SequencerStop(void) {
    if (seq_playing) {
        MusicStop();
        seq_playing = 0;
    }
}


/*
 * SequencerTick — call once per frame from CalculateBkgrndNewXY.
 * Advances the sequencer by the number of elapsed 60Hz fields
 * (Obj_MotionFactor + 1) to keep tempo consistent when frames drop.
 * When the tick counter expires, decrements each voice's remaining
 * duration and advances to the next note when it reaches zero.
 */
static void SequencerTick(void) {
    byte elapsed;
    if (!seq_playing) return;

    elapsed = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 1;
    if (elapsed == 0) elapsed = 1;  /* guard against underflow on macOS */
    if (seq_tickCounter > elapsed) {
        seq_tickCounter -= elapsed;
        return;
    }
    seq_tickCounter = seq_tempo;

    /* Advance each active voice */
    if (seq_notes0) {
        seq_rem0--;
        if (seq_rem0 == 0) {
            seq_advanceVoice0();
        }
    }
    if (seq_notes1) {
        seq_rem1--;
        if (seq_rem1 == 0) {
            seq_advanceVoice1();
        }
    }
    if (seq_notes2) {
        seq_rem2--;
        if (seq_rem2 == 0) {
            seq_advanceVoice2();
        }
    }
}

#endif /* _Sequencer_h */
