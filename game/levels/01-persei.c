#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"

/* Phase increments: freq * 65536 / 2000 */
#define PHASE_C2  2143
#define PHASE_D2  2405
#define PHASE_E2  2700
#define PHASE_G2  3212
#define PHASE_A2  3605
#define PHASE_C3  4286
#define PHASE_D3  4811
#define PHASE_E3  5400
#define PHASE_F3  5722
#define PHASE_G3  6423
#define PHASE_A3  7209
#define PHASE_B3  8092
#define PHASE_C4  8573
#define PHASE_D4  9623
#define PHASE_E4  10801

#include "../shared/sequencer.h"

/*
 * "Omicron Persei" — spacey synth theme in A minor
 *
 * Slow, atmospheric melody with sustained bass and arpeggiated chords.
 * Evokes the tension of an alien invasion.
 *
 * Tempo: 15 frames/tick (~4 notes/sec)
 */

/* Voice 0: melody — slow, haunting line */
static word persei_v0_notes[] = {
    /* Phrase 1: rising tension */
    PHASE_A3, PHASE_A3, 0, PHASE_C4,
    PHASE_B3, PHASE_B3, 0, PHASE_A3,
    /* Phrase 2: peak and descend */
    PHASE_E4, PHASE_D4, 0, PHASE_C4,
    PHASE_B3, PHASE_A3, 0, 0,
    /* Phrase 3: darker turn */
    PHASE_E3, PHASE_E3, 0, PHASE_G3,
    PHASE_F3, PHASE_F3, 0, PHASE_E3,
    /* Phrase 4: resolve */
    PHASE_A3, PHASE_G3, 0, PHASE_E3,
    PHASE_D3, PHASE_C3, 0, 0
};
static byte persei_v0_durs[] = {
    2,1,1,2,  2,1,1,2,
    2,1,1,2,  2,1,1,2,
    2,1,1,2,  2,1,1,2,
    2,1,1,2,  2,1,1,2,
    0  /* loop */
};

/* Voice 1: arpeggiated pad — broken chords, eerie shimmer */
static word persei_v1_notes[] = {
    /* Am arpeggio */
    PHASE_E3, PHASE_A3, PHASE_C4, PHASE_A3,
    PHASE_E3, PHASE_A3, PHASE_C4, PHASE_A3,
    /* Am arpeggio (higher) */
    PHASE_E3, PHASE_A3, PHASE_C4, PHASE_E4,
    PHASE_C4, PHASE_A3, PHASE_E3, 0,
    /* Dm arpeggio */
    PHASE_D3, PHASE_F3, PHASE_A3, PHASE_F3,
    PHASE_D3, PHASE_F3, PHASE_A3, PHASE_F3,
    /* Am arpeggio resolve */
    PHASE_E3, PHASE_A3, PHASE_C4, PHASE_A3,
    PHASE_E3, PHASE_C3, PHASE_A3, 0
};
static byte persei_v1_durs[] = {
    2,2,2,2,  2,2,2,2,
    2,2,2,2,  2,2,2,2,
    2,2,2,2,  2,2,2,2,
    2,2,2,2,  2,2,2,2,
    0  /* loop */
};

/* Voice 2: deep bass — sustained low notes */
static word persei_v2_notes[] = {
    PHASE_A2,       /* Am */
    PHASE_A2,       /* Am */
    PHASE_E2,       /* Am/E */
    PHASE_E2,       /* Am/E */
    PHASE_D2,       /* Dm */
    PHASE_D2,       /* Dm */
    PHASE_A2,       /* Am */
    PHASE_E2        /* Am/E */
};
static byte persei_v2_durs[] = {
    8, 8, 8, 8, 8, 8, 8, 8,
    0  /* loop */
};


void PerseiInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 3;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = GameWavePerseiMoveInUnison;
}


byte PerseiCalculateBkgrndNewXY() {
    if (!seq_playing) {
        MusicSetWaveSineQuiet0();
        MusicSetWaveTriangleQuiet1();
        MusicSetWaveSawtoothQuiet2();
        SequencerPlay(persei_v0_notes, persei_v0_durs,
                      persei_v1_notes, persei_v1_durs,
                      persei_v2_notes, persei_v2_durs, 15);
    }
    SequencerTick();
    return 0;
}


RegisterLevel(PerseiInit, PerseiCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
