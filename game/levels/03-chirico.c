#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/10-littleguy.h"

#define CHIRICO_PLAY_AREA_WIDTH 640
#define CHIRICO_MAX_SCROLL ((CHIRICO_PLAY_AREA_WIDTH - SCREEN_WIDTH) / 2)

/* Twinkle Twinkle melody parameters */
#define TWINKLE_LENGTH 48
#define TWINKLE_TEMPO 18   /* frames per note (~3.3 notes/sec at 60fps) */

/* Phase increments: freq * 65536 / 2000 */
/* Octave 3 (melody) */
#define PHASE_C3 4286
#define PHASE_D3 4811
#define PHASE_E3 5400
#define PHASE_F3 5722
#define PHASE_G3 6423
#define PHASE_A3 7209
#define PHASE_B3 8092
/* Octave 4 (harmony) */
#define PHASE_C4 8573
#define PHASE_E4 10801
#define PHASE_G4 12845

/*
 * Twinkle Twinkle Little Star melody (6 phrases of 8 beats):
 *   C C G G A A G .  F F E E D D C .
 *   G G F F E E D .  G G F F E E D .
 *   C C G G A A G .  F F E E D D C .
 * Beat pattern per phrase: n0 n0 n1 n1 n2 n2 n3 rest
 * Phrase A: C,G,A,G   Phrase B: F,E,D,C   Phrase C: G,F,E,D
 * Sequence: A B C C A B
 */
static word getTwinkleNote(byte pos) {
    byte beat = pos & 7;
    byte phrase = pos >> 3;
    byte slot;

    if (beat == 7) return 0;  /* rest beat */

    /* Map beat to note slot: 0 0 1 1 2 2 3 */
    if (beat < 2) slot = 0;
    else if (beat < 4) slot = 1;
    else if (beat < 6) slot = 2;
    else slot = 3;

    /* Phrase A: C G A G */
    if (phrase == 0 || phrase == 4) {
        if (slot == 0) return PHASE_C3;
        if (slot == 2) return PHASE_A3;
        return PHASE_G3;  /* slots 1 and 3 */
    }
    /* Phrase B: F E D C */
    if (phrase == 1 || phrase == 5) {
        if (slot == 0) return PHASE_F3;
        if (slot == 1) return PHASE_E3;
        if (slot == 2) return PHASE_D3;
        return PHASE_C3;
    }
    /* Phrase C: G F E D */
    if (slot == 0) return PHASE_G3;
    if (slot == 1) return PHASE_F3;
    if (slot == 2) return PHASE_E3;
    return PHASE_D3;
}

/*
 * Get chord tones (3rd and 5th) for each phrase.
 * Returns the two harmony notes via pointers.
 * Chords:
 *   Phrase A (C,G,A,G): C major (C-E-G) for C slots, G for G, Am for A
 *   Phrase B (F,E,D,C): F major for F, C major for C/E, Dm for D
 *   Phrase C (G,F,E,D): G major for G, F for F, C for E, Dm for D
 *
 * Simplified: one chord per phrase for a clean sound.
 *   Phrase A: C major (E3, G3)
 *   Phrase B: F major (A3, C4)
 *   Phrase C: G major (B3, D3) — but we use (B3, G4/2) for a lighter voicing
 */
static void getTwinkleChord(byte phrase, word *v1, word *v2) {
    if (phrase == 0 || phrase == 4) {
        /* C major: E + G */
        *v1 = PHASE_E3;
        *v2 = PHASE_G3;
    } else if (phrase == 1 || phrase == 5) {
        /* F major: A + C */
        *v1 = PHASE_A3;
        *v2 = PHASE_C4;
    } else {
        /* G major: B + D */
        *v1 = PHASE_B3;
        *v2 = PHASE_D3;
    }
}


void ChiricoInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 1;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = 0;  /* melody note index */
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

    /* Advance melody */
    {
        GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
        globals->counter++;
        if (globals->counter >= TWINKLE_TEMPO) {
            word note;
            word chord1, chord2;
            byte phrase;
            globals->counter = 0;
            note = getTwinkleNote(globals->gameWave);
            phrase = globals->gameWave >> 3;
            if (globals->gameWave < TWINKLE_LENGTH - 1) {
                globals->gameWave++;
            } else {
                globals->gameWave = 0;
            }
            if (note) {
                MusicStart(note);
                getTwinkleChord(phrase, &chord1, &chord2);
                MusicStart1(chord1);
                MusicStart2(chord2);
            } else {
                MusicStop();
            }
        }
    }

    return 0;
}


RegisterLevel(ChiricoInit, ChiricoCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
