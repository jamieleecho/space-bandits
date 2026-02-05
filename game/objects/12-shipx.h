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
#define DynospriteObject_DataSize 12

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 10

#else

#ifndef _12_shipx_h
#define _12_shipx_h

#include "dynosprite.h"
#include "universal_object.h"


/** State of Ship Object */
typedef struct ShipxObjectState {
    UniversalObject obj;
} ShipxObjectState;


#endif /* _12_shipx_h */

#endif /* DynospriteObject_DataDefinition */
