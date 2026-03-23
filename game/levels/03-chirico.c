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

/* Phase increments for notes in octave 3 */
#define PHASE_C4 4286
#define PHASE_D4 4811
#define PHASE_E4 5400
#define PHASE_F4 5722
#define PHASE_G4 6423
#define PHASE_A4 7209

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
        if (slot == 0) return PHASE_C4;
        if (slot == 2) return PHASE_A4;
        return PHASE_G4;  /* slots 1 and 3 */
    }
    /* Phrase B: F E D C */
    if (phrase == 1 || phrase == 5) {
        if (slot == 0) return PHASE_F4;
        if (slot == 1) return PHASE_E4;
        if (slot == 2) return PHASE_D4;
        return PHASE_C4;
    }
    /* Phrase C: G F E D */
    if (slot == 0) return PHASE_G4;
    if (slot == 1) return PHASE_F4;
    if (slot == 2) return PHASE_E4;
    return PHASE_D4;
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
            globals->counter = 0;
            note = getTwinkleNote(globals->gameWave);
            if (globals->gameWave < TWINKLE_LENGTH - 1) {
                globals->gameWave++;
            } else {
                globals->gameWave = 0;
            }
            if (note) {
                MusicStart(note);
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
