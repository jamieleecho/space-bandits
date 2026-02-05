//
//  13-candle.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/21/24.
//  Copyright © 2024 Jamie Cho. All rights reserved.
//

/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of CandleObjectState in bytes */
#define DynospriteObject_DataSize 4

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _13_candle_h
#define _13_candle_h

#include "dynosprite.h"
#include "sprite_state_machine.h"


/** State of Ship Object */
typedef struct CandleObjectState {
    SpriteState spriteState;
    uint8_t angleIdx; // Track the current angle index for circular motion
    int centerX;      // Center X coordinate for the circle
    int centerY;      // Center Y coordinate for the circle
} CandleObjectState;


#endif /* _13_candle_h */

#endif /* DynospriteObject_DataDefinition */
