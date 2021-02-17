#ifndef _object_info_h
#define _object_info_h

#include "coco.h"
#include "dynosprite.h"


#define LEVEL_1 1

#define BADGUY_GROUP_IDX 3
#define SHIP_GROUP_IDX 4
#define MISSILE_GROUP_IDX 5

#define SOUND_LASER 1

#define GAME_OVER_GROUP_IDX 6
#define BAD_MISSILE_GROUP_IDX 7

#define SOUND_LASER 1
#define SOUND_EXPLOSION 2

#define NUM_BAD_GUYS 45
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


typedef struct GameGlobals {
    byte initialized;
    byte numShips;
    byte score[6];
    word shootCounter[3];
} GameGlobals;


/**
 * Starting from obj, finds an object with the given group index.
 *
 * @param obj starting object
 * @param groupIdx groupIdx to look for
 * @return new obj or NULL
 */
#ifdef __cplusplus
[[maybe_unused]]
#endif
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
#ifdef __cplusplus
[[maybe_unused]]
#endif
static void bumpScore(byte amount) {
#if __APPLE__
    byte *score0 = ((GameGlobals *)&(DynospriteGlobalsPtr->UserGlobals_Init))->score;
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
    byte *score0 = ((GameGlobals *)&(DynospriteGlobalsPtr->UserGlobals_Init))->score;
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
