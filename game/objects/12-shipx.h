//
//  12-shipx.h
//  Space Bandits
//
//  Created by Jamie Cho on 2/18/21.
//  Copyright © 2023 Jamie Cho. All rights reserved.
//


/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of ShipCounterObjectState in bytes */
#define DynospriteObject_DataSize 16

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 14

#else

#ifndef _12_shipx_h
#define _12_shipx_h

#include "dynosprite.h"


/** State of Ship Object */
typedef struct ShipxObjectState {
} ShipxCounterObjectState;


#endif /* _12_shipx_h */

#endif /* DynospriteObject_DataDefinition */
