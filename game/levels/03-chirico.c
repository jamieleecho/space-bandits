#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/10-littleguy.h"

#define CHIRICO_PLAY_AREA_WIDTH 640
#define CHIRICO_MAX_SCROLL ((CHIRICO_PLAY_AREA_WIDTH - SCREEN_WIDTH) / 2)

/* Phase increments: freq * 65536 / 2000
 * Octave 2 (bass) */
#define PHASE_C2   2143
#define PHASE_Cs2  2270
#define PHASE_B2   4046
/* Octave 3 */
#define PHASE_C3   4286
#define PHASE_Cs3  4541
#define PHASE_D3   4811
#define PHASE_Ds3  5097
#define PHASE_E3   5400
#define PHASE_F3   5722
#define PHASE_Fs3  6062
#define PHASE_G3   6423
#define PHASE_Gs3  6804
#define PHASE_A3   7209
#define PHASE_B3   8092
/* Octave 4 */
#define PHASE_C4   8573
#define PHASE_Cs4  9083
#define PHASE_D4   9623
#define PHASE_Ds4  10195
#define PHASE_E4   10801
#define PHASE_Gs4  13609

#include "../shared/sequencer.h"

/*
 * Moonlight Sonata (1st movement) — Beethoven
 * Key: C# minor
 *
 * The iconic triplet arpeggiation: bass note + two upper voices
 * forming broken chords. Simplified for 3 voices.
 *
 * Voice 0: upper triplet arpeggiation (repeating 3-note pattern)
 * Voice 1: middle chord tone (sustained)
 * Voice 2: bass octave (sustained)
 *
 * Original triplet pattern per half-bar: G#-C#-E repeated
 * We arpeggiate on voice 0 and sustain the other voices.
 *
 * Tempo: 20 frames/tick (~3 notes/sec, adagio feel)
 *
 * Bars 1-2:  C#m  (C#-E-G#)     bass: C#2
 * Bars 3-4:  C#m  (C#-E-G#)     bass: B2
 * Bars 5-6:  A    (A-C#-E)      bass: A3
 * Bars 7-8:  F#m  (F#-A-C#)     bass: F#3
 * Bars 9-10: C#m/G# (G#-C#-E)  bass: G#3
 * Bars 11-12: C#m  (C#-E-G#)    bass: C#3
 */

/* Voice 0: arpeggiated triplets — 3 notes per chord, 1 tick each */
static word moon_v0_notes[] = {
    /* Bars 1-2: C#m arpeggio x4 */
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    /* Bars 3-4: C#m arpeggio x4 (same pattern, bass changes) */
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    /* Bars 5-6: A major arpeggio x4 */
    PHASE_A3,  PHASE_Cs4, PHASE_E4,
    PHASE_A3,  PHASE_Cs4, PHASE_E4,
    PHASE_A3,  PHASE_Cs4, PHASE_E4,
    PHASE_A3,  PHASE_Cs4, PHASE_E4,
    /* Bars 7-8: F#m arpeggio x4 */
    PHASE_Fs3, PHASE_A3,  PHASE_Cs4,
    PHASE_Fs3, PHASE_A3,  PHASE_Cs4,
    PHASE_Fs3, PHASE_A3,  PHASE_Cs4,
    PHASE_Fs3, PHASE_A3,  PHASE_Cs4,
    /* Bars 9-10: G#-C#-E arpeggio x4 */
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    /* Bars 11-12: C#m resolve x4 */
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4,
    PHASE_Gs3, PHASE_Cs4, PHASE_E4
};
static byte moon_v0_durs[] = {
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    1,1,1, 1,1,1, 1,1,1, 1,1,1,
    0  /* loop */
};

/* Voice 1: sustained middle tone — one per 2-bar phrase (12 ticks each) */
static word moon_v1_notes[] = {
    PHASE_E3,   /* Bars 1-2:   C#m — E */
    PHASE_E3,   /* Bars 3-4:   C#m — E */
    PHASE_E3,   /* Bars 5-6:   A   — E */
    PHASE_Cs3,  /* Bars 7-8:   F#m — C# */
    PHASE_E3,   /* Bars 9-10:  C#m — E */
    PHASE_E3    /* Bars 11-12: C#m — E */
};
static byte moon_v1_durs[] = {
    12, 12, 12, 12, 12, 12,
    0  /* loop */
};

/* Voice 2: bass note — one per 2-bar phrase (12 ticks each) */
static word moon_v2_notes[] = {
    PHASE_Cs2,  /* Bars 1-2:   C#2 */
    PHASE_B2,   /* Bars 3-4:   B2 */
    PHASE_A3,   /* Bars 5-6:   A3 */
    PHASE_Fs3,  /* Bars 7-8:   F#3 */
    PHASE_Gs3,  /* Bars 9-10:  G#3 */
    PHASE_Cs3   /* Bars 11-12: C#3 */
};
static byte moon_v2_durs[] = {
    12, 12, 12, 12, 12, 12,
    0  /* loop */
};


void ChiricoInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 1;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;

    SequencerPlay(moon_v0_notes, moon_v0_durs,
                  moon_v1_notes, moon_v1_durs,
                  moon_v2_notes, moon_v2_durs, 20);
}


byte ChiricoCalculateBkgrndNewXY() {
    /* Scroll the background to keep little guy at screen center */
    DynospriteCOB *guyCob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, LITTLEGUY_GROUP_IDX);
    if (guyCob) {
        int scroll = (int)(guyCob->globalX / 2) - 80;
        if (scroll < 0) {
            scroll = 0;
        } else if (scroll > CHIRICO_MAX_SCROLL) {
            scroll = CHIRICO_MAX_SCROLL;
        }
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = scroll;
    }

    SequencerTick();

    return 0;
}


RegisterLevel(ChiricoInit, ChiricoCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
