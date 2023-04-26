//
//  10-fixed_object.h
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//


/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

#include "universal_object.h"

/** Defines at least the size of Fixedobject_State in bytes */
#define DynospriteObject_DataSize 16

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 12

#else

#ifndef _10_fixed_object_h
#define _10_fixed_object_h

#include "dynosprite.h"
#include "universal_object.h"


/** State of Fixed Object */
typedef struct Fixed_objectObjectState {
    UniversalObject obj;
} Fixed_objectObjectState;


#endif /* _10_fixed_object_h */

#endif /* DynospriteObject_DataDefinition */

