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
#define DynospriteObject_DataSize 1

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _9_boss1_h
#define _9_boss1_h

#include "dynosprite.h"


/** State of Boss1 Object */
typedef struct Boss1ObjectState {
    byte spriteIdx;
} Boss1ObjectState;


#endif /* _9_boss1_h */

#endif /* DynospriteObject_DataDefinition */
