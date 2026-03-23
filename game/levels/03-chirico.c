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

/* Phase increments for notes in octave 4 */
#define PHASE_C4 8573
#define PHASE_D4 9623
#define PHASE_E4 10801
#define PHASE_F4 11444
#define PHASE_G4 12845
#define PHASE_A4 14418

/*
 * Twinkle Twinkle Little Star melody (6 phrases of 8 beats):
 *   C C G G A A G .  F F E E D D C .
 *   G G F F E E D .  G G F F E E D .
 *   C C G G A A G .  F F E E D D C .
 * Each phrase has pattern: X X Y Y Z Z Y rest
 * Phrases: A(C,G,A) B(F,E,D) C(G,F,E), sequence: A B C C A B
 */
static word getTwinkleNote(byte pos) {
    byte beat = pos & 7;
    byte phrase = pos >> 3;
    byte slot;

    if (beat == 7) return 0;  /* rest beat */

    /* Map beat to note slot: 0 0 1 1 2 2 1 */
    if (beat < 2) slot = 0;
    else if (beat < 4) slot = 1;
    else if (beat < 6) slot = 2;
    else slot = 1;

    /* Phrase A: C G A */
    if (phrase == 0 || phrase == 4) {
        if (slot == 0) return PHASE_C4;
        if (slot == 1) return PHASE_G4;
        return PHASE_A4;
    }
    /* Phrase B: F E D */
    if (phrase == 1 || phrase == 5) {
        if (slot == 0) return PHASE_F4;
        if (slot == 1) return PHASE_E4;
        return PHASE_D4;
    }
    /* Phrase C: G F E */
    if (slot == 0) return PHASE_G4;
    if (slot == 1) return PHASE_F4;
    return PHASE_E4;
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
