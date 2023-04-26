//
//  11-velocity_object.h
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
#define DynospriteObject_InitSize 14

#else

#ifndef _11_velocity_object_h
#define _11_velocity_object_h

#include "dynosprite.h"
#include "universal_object.h"


/** State of Velocity Object */
typedef struct Velocity_objectObjectState {
    UniversalObject *obj;
} Velocity_objectObjectState;


#endif /* _11_velocity_object_h */

#endif /* DynospriteObject_DataDefinition */

