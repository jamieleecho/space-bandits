#ifdef DynospriteObject_DataDefinition

/** Size of BirdObjectState in bytes */
#define DynospriteObject_DataSize 4

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _11_bird_h
#define _11_bird_h

#include "dynosprite.h"

#define BIRD_SPRITE_WINGS_UP    0
#define BIRD_SPRITE_WINGS_LEVEL 1
#define BIRD_SPRITE_WINGS_DOWN  2

#define BIRD_HALF_WIDTH  6
#define BIRD_GROUP_IDX   11

/** State of Bird Object */
typedef struct BirdObjectState {
    byte spriteIdx;
    byte direction;
    byte flapCounter;
    byte bobCounter;
} BirdObjectState;

#endif /* _11_bird_h */

#endif /* DynospriteObject_DataDefinition */
