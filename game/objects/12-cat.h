#ifdef DynospriteObject_DataDefinition

/** Size of CatObjectState in bytes */
#define DynospriteObject_DataSize 8

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _12_cat_h
#define _12_cat_h

#include "dynosprite.h"

/** Sprite indices for the cat */
#define CAT_SPRITE_SLEEP1        0
#define CAT_SPRITE_SLEEP2        1
#define CAT_SPRITE_SLEEP3        2
#define CAT_SPRITE_SIT           3
#define CAT_SPRITE_WALK_RIGHT_A  4
#define CAT_SPRITE_WALK_RIGHT_B  5
#define CAT_SPRITE_WALK_LEFT_A   6
#define CAT_SPRITE_WALK_LEFT_B   7
#define CAT_SPRITE_SNUGGLE1      8
#define CAT_SPRITE_SNUGGLE2      9
#define CAT_SPRITE_CHASE_RIGHT_A 10
#define CAT_SPRITE_CHASE_RIGHT_B 11
#define CAT_SPRITE_CHASE_LEFT_A  12
#define CAT_SPRITE_CHASE_LEFT_B  13

/** Cat moods */
#define CAT_MOOD_SLEEP   0
#define CAT_MOOD_CHASE   1
#define CAT_MOOD_SNUGGLE 2

#define CAT_HALF_WIDTH   14
#define CAT_HALF_HEIGHT  10
#define CAT_GROUP_IDX    12

/** State of Cat Object */
typedef struct CatObjectState {
    byte spriteIdx;
    byte mood;
    byte moodTimer;
    byte animCounter;
    byte walkCounter;
    byte snuggleProximity;
    signed char jumpVelocity;
    byte isJumping;
} CatObjectState;

#endif /* _12_cat_h */

#endif /* DynospriteObject_DataDefinition */
