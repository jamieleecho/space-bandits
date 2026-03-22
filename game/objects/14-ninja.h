#ifdef DynospriteObject_DataDefinition

/** Size of NinjaObjectState in bytes */
#define DynospriteObject_DataSize 5

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _14_ninja_h
#define _14_ninja_h

#include "dynosprite.h"

/** Sprite indices for the ninja */
#define NINJA_SPRITE_LEFT_WALK_A  0
#define NINJA_SPRITE_LEFT_WALK_B  1
#define NINJA_SPRITE_CENTER       2
#define NINJA_SPRITE_RIGHT_WALK_A 3
#define NINJA_SPRITE_RIGHT_WALK_B 4
#define NINJA_SPRITE_JUMP         5

#define NINJA_HALF_WIDTH  10
#define NINJA_HALF_HEIGHT 14
#define NINJA_GROUP_IDX   14

/** State of Ninja Object */
typedef struct NinjaObjectState {
    byte spriteIdx;
    signed char jumpVelocity;
    byte isJumping;
    byte lastButtonState;
    byte walkCounter;
} NinjaObjectState;

#endif /* _14_ninja_h */

#endif /* DynospriteObject_DataDefinition */
