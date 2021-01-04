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

#define NUM_BAD_GUYS 55
#define NUM_MISSILES 3
#define NUM_BAD_MISSILES 3

#define BADGUY_HALF_WIDTH 7
#define BADGUY_HALF_HEIGHT 7
#define SHIP_HALF_WIDTH 10
#define SHIP_HALF_HEIGHT 10
#define MISSILE_HALF_WIDTH 2
#define MISSILE_HEIGHT 10

#define BADGUY_SPRITE_ENEMY_SWATH_INDEX 0
#define BADGUY_SPRITE_BLADE_INDEX 3
#define BADGUY_SPRITE_DUDE_INDEX 7
#define BADGUY_SPRITE_TINY_INDEX 11
#define BADGUY_SPRITE_TIVO_INDEX 13
#define BADGUY_SPRITE_EXPLOSION_INDEX 15
#define BADGUY_SPRITE_LAST_INDEX 24
#define SHIP_SPRITE_EXPLOSION_INDEX 3


typedef struct GameGlobals {
    byte initialized;
    byte numShips;
    unsigned score;
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

#endif
