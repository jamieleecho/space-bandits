//
//  universal_object.h
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//
//  Universal object definition

#ifndef _universal_object_h
#define _universal_object_h

#define UNIVERSAL_FIXED_OBJECT_INIT_SIZE 5
#define UNIVERSAL_VELOCITY_OBJECT_SIZE 9

#define UNIVERSAL_FIXED_OBJECT_SIZE 5
#define UNIVERSAL_VELOCITY_OBJECT_SIZE 9

#ifndef DynospriteObject_DataDefinition

#include "dynosprite.h"

typedef word Vector[2];

typedef struct UniversalObject {
    // All universal objects have these attributes
    byte spriteIdx;
    Vector clip;
    
    // Velocity objects have these attributes
    Vector velocity;
} UniversalObject;

static void UniversalObjectFixedObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData);
static void UniversalObjectFixedObjectClip(DynospriteCOB *cob, DynospriteODT *odt);

static void UniversalObjectVelocityObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData);
static void UniversalObjectVelocityObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt);

#endif /* DynospriteObject_DataDefinition */

#endif /* _universal_object_h */
