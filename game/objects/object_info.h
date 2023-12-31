#ifndef _object_info_h
#define _object_info_h

#include "coco.h"
#include "dynosprite.h"


#define LEVEL_1 1

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define PLAYFIELD_WIDTH 352
#define PLAYFIELD_HEIGHT 224
#define PLAYFIELD_CENTER_WIDTH_OFFSET ((PLAYFIELD_WIDTH - SCREEN_WIDTH) / 2)
#define PLAYFIELD_CENTER_HEIGHT_OFFSET ((PLAYFIELD_HEIGHT - SCREEN_HEIGHT) / 2)


#define BADGUY_GROUP_IDX 3
#define SHIP_GROUP_IDX 4
#define MISSILE_GROUP_IDX 5
#define BOSS1_GROUP_IDX 9

#define SOUND_LASER 1

#define GAME_OVER_GROUP_IDX 6
#define BAD_MISSILE_GROUP_IDX 7

#define SOUND_LASER 1
#define SOUND_EXPLOSION 2
#define SOUND_CLICK 3

#define NUM_BAD_GUYS 45
#define BAD_GUY_ROWS 5
#define BAD_GUY_COLUMNS 9
#define BAD_GUY_FIRE_MAX_Y (PLAYFIELD_HEIGHT - PLAYFIELD_CENTER_HEIGHT_OFFSET - 62)
#define NUM_MISSILES 3
#define NUM_BAD_MISSILES 3

#define BADGUY_HALF_WIDTH 7
#define BADGUY_HALF_HEIGHT 7
#define SHIP_HALF_WIDTH 8
#define SHIP_THIN_HALF_WIDTH 5
#define SHIP_HALF_HEIGHT 15
#define SHIP_THICK_HALF_HEIGHT 7
#define MISSILE_HALF_WIDTH 2
#define MISSILE_HEIGHT 8

#define BOSS1_HALF_WIDTH 18
#define BOSS1_HALF_HEIGHT 12

#define BADGUY_SPRITE_ENEMY_SWATH_INDEX 0
#define BADGUY_SPRITE_BLADE_INDEX 3
#define BADGUY_SPRITE_DUDE_INDEX 7
#define BADGUY_SPRITE_TINY_INDEX 11
#define BADGUY_SPRITE_TIVO_INDEX 13
#define BADGUY_SPRITE_EXPLOSION_INDEX 15
#define BADGUY_SPRITE_LAST_INDEX 24
#define SHIP_SPRITE_MIDDLE_INDEX 1
#define SHIP_SPRITE_EXPLOSION_INDEX 3
#define SHIP_SPRITE_LAST_INDEX 12

#define SHIP_POSITION_Y (PLAYFIELD_HEIGHT - PLAYFIELD_CENTER_HEIGHT_OFFSET - 29)


enum GameState {
    GameStatePlaying = 0,
    GameStatePaused  = 1,
    GameStateQuit    = 2,
    GameStateOver    = 3
};


/** Global game data */
typedef struct GameGlobals {
    byte initialized;
    byte numShips;
    byte /* GameState */ gameState;
    byte score[3];
    word shootCounter[3];
    byte counter;
    byte gameWave;
    byte numInvaders;
} GameGlobals;


/** GameWave Definitions for Persei Level */
typedef enum GameWavePersei {
    /** All invaders move together */
    GameWavePerseiMoveInUnison = 0,

    /** All invaders in a column move together */
    GameWavePerseiMoveInColumn,

    /** All invaders in a row move together */
    GameWavePerseiMoveInRow,

    /** All invaders move in whatever direction they want */
    GameWavePerseiMoveAtWill,

    /** Boss stage  */
    GameWavePerseiBoss,

    /** Invalid grouping mode */
    GameWavePerseiInvalid
} GameWavePersei;


/**
 * Starting from obj, finds an object with the given group index.
 *
 * @param obj starting object
 * @param groupIdx groupIdx to look for
 * @return new obj or NULL
 */
MAYBE_UNUSED
static DynospriteCOB *findObjectByGroup(DynospriteCOB *obj, byte groupIdx) {
    DynospriteCOB *endObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
    for (; obj<endObj; ++obj) {
        if (obj->groupIdx == groupIdx) {
            return obj;
        }
    }
    return 0;
}


/**
 * Bumps the score by amount where amount must be a binary coded decimal number < 90.
 */
MAYBE_UNUSED
static void bumpScore(byte amount) {
#if __APPLE__
    byte *score0 = (byte *)&((GameGlobals *)DynospriteGlobalsPtr)->score;
    byte *score2 = score0 + 2;
    
    byte amount0 = amount & 0xf;
    byte amount1 = amount & 0xf0;
    for (byte *score = score2; score >=score0; score--) {
        byte lsd = ((*score & 0xf) + amount0);
        amount0 = 0;
        if (lsd > 9) {
            lsd = (lsd - 0x0a);
            amount1 = amount1 + 0x10;
        }

        byte msd = ((*score & 0xf0) + amount1);
        if (amount1) {
            if (msd > 0x90) {
                msd = (msd - 0xa0);
                amount0 = 1;
            }
            amount1 = 0;
        }
        
        *score = msd | lsd;

        if (!(amount0 | amount1)) {
            break;
        }
    }
#else
    byte *score0 = ((GameGlobals *)DynospriteGlobalsPtr)->score;
    asm {
        ldx score0

        lda 2,x
        adca amount
        daa
        sta 2,x

        lda 1,x
        adca #0
        daa
        sta 1,x

        lda ,x
        adca #0
        daa
        sta ,x
    }
#endif
}

#endif
