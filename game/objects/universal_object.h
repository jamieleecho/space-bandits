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

#define UNIVERSAL_FIXED_OBJECT_INIT_SIZE 10
#define UNIVERSAL_FIXED_OBJECT_SIZE 12

#define UNIVERSAL_VELOCITY_OBJECT_INIT_SIZE 14
#define UNIVERSAL_VELOCITY_OBJECT_SIZE 16

#define UNIVERSAL_OBJECT_MAGIC_NUMBER 0xf00f

#ifndef DynospriteObject_DataDefinition

#include "dynosprite.h"

typedef sword Vector[2];
typedef sbyte BoundingBox[4];

typedef struct UniversalObject {
    /** Index of current sprite to show */
    byte spriteIdx;

    /** Magic numbers */
    word magicNumber;

    /** Depth of object - 1 is closest to user, 4 is deepest depth.  */
    byte depth;

    /** bounding box to use for intersections */
    BoundingBox boundingBox;

    /** actual position of the object before depth transformation */
    Vector position;

    /** velocity of the current object */
    Vector velocity;
} UniversalObject;

MAYBE_UNUSED
static void UniversalObjectFixedObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData);
MAYBE_UNUSED
static void UniversalObjectFixedObjectClip(DynospriteCOB *cob, DynospriteODT *odt);

MAYBE_UNUSED
static void UniversalObjectVelocityObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData);
MAYBE_UNUSED
static void UniversalObjectVelocityObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt);

#endif /* DynospriteObject_DataDefinition */

#endif /* _universal_object_h */
