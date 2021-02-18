//
//  08-shipcounter.h
//  Space Bandits
//
//  Created by Jamie Cho on 2/18/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//


/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of ShipObjectState in bytes */
#define DynospriteObject_DataSize 2

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 1

#else

#ifndef _8_shipcounter_h
#define _8_shipcounter_h

#include "dynosprite.h"


/** State of Missile Object */
typedef struct ShipCounterObjectState {
    byte spriteIdx;
    byte numShips;
} ShipCounterObjectState;


#endif /* _8_shipcounter_h */

#endif /* DynospriteObject_DataDefinition */
