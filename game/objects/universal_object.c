//
//  universal_object.c
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//
//  The file defines UniversalObjects which are dynosprite objects that have
//  some subset of basic phyical properties such as boundaries, position,
//  velocity and  momentum.
//
//  Due to limitations in the way linking is (not) defined on the CoCo 3
//  version of Space Bandits, this file must be included directly by
//  objects that use it.

#ifndef _universal_object_c
#define _universal_object_c

#include "universal_object.h"
#include "dynosprite.h"


MAYBE_UNUSED
static void UniversalObjectFixedObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    UniversalObject *state = (UniversalObject *)cob->statePtr;
    byte ii = 0;
    state->magicNumber = UNIVERSAL_OBJECT_MAGIC_NUMBER;
    state->spriteIdx = initData[ii++];

    state->depth = initData[ii++];

    state->boundingBox[0] = initData[ii++];
    state->boundingBox[1] = initData[ii++];
    state->boundingBox[2] = initData[ii++];
    state->boundingBox[3] = initData[ii++];

    state->position[0] = (((short)initData[ii]) << 8) | initData[ii + 1];
    ii = ii + 2;
    state->position[1] = (((short)initData[ii]) << 8) | initData[ii + 1];
    cob->globalX = state->position[0];
    cob->globalY = state->position[1];
}


MAYBE_UNUSED
static void UniversalObjectFixedObjectClip(DynospriteCOB *cob, DynospriteODT *odt) {    
}


MAYBE_UNUSED
static void UniversalObjectVelocityObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    UniversalObjectFixedObjectInit(cob, odt, initData);
    UniversalObject *state = (UniversalObject *)cob->statePtr;
    byte ii = UNIVERSAL_FIXED_OBJECT_INIT_SIZE;
    state->velocity[0] = (((short)initData[ii]) << 8) | initData[ii+1];
    ii = ii + 2;
    state->velocity[1] = (((short)initData[ii]) << 8) | initData[ii+1];
}


MAYBE_UNUSED
static void UniversalObjectVelocityObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    UniversalObject *state = (UniversalObject *)cob->statePtr;
    state->position[0] = state->position[0] + state->velocity[0];
    state->position[1] = state->position[1] + state->velocity[1];
    
    byte offset = state->depth - 1;
    cob->globalX = state->position[0] >> offset;
    cob->globalY = state->position[1] >> offset;
}

#endif /* _universal_object_c */
