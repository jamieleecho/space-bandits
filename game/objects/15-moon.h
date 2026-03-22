#ifdef DynospriteObject_DataDefinition

/** Size of MoonObjectState in bytes */
#define DynospriteObject_DataSize 1

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _15_moon_h
#define _15_moon_h

#include "dynosprite.h"

#define MOON_SPRITE 0

#define MOON_HALF_WIDTH  13
#define MOON_GROUP_IDX   15

/** State of Moon Object */
typedef struct MoonObjectState {
    byte spriteIdx;
} MoonObjectState;

#endif /* _15_moon_h */

#endif /* DynospriteObject_DataDefinition */
