//
//  10-fixed_object.h
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//


/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of ShipObjectState in bytes */
#define DynospriteObject_DataSize 1

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 1

#else

#ifndef _10_fixed_object_h
#define _10_fixed_object_h

#include "dynosprite.h"


/** State of Fixed Object */
typedef struct FixedObjectState {
    byte spriteIdx;
} FixedObjectState;


#endif /* _10_fixed_object_h */

#endif /* DynospriteObject_DataDefinition */

