//
//  12-ship.h
//  Space Bandits
//
//  Created by Jamie Cho on 2/18/21.
//  Copyright © 2023 Jamie Cho. All rights reserved.
//


/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of ShipCounterObjectState in bytes */
#define DynospriteObject_DataSize 14

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 14

#else

#ifndef _12_ship_h
#define _12_ship_h

#include "dynosprite.h"


/** State of Ship Object */
typedef struct Ship12ObjectState {
} Ship12CounterObjectState;


#endif /* _12_ship_h */

#endif /* DynospriteObject_DataDefinition */
