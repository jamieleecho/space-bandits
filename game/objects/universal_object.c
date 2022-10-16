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
    word ii = 0;
    state->spriteIdx = initData[ii];
    ii = ii + 1;
    state->clip[0] = (((short)initData[ii]) << 8) | initData[ii+1];
    ii = ii + 2;
    state->clip[1] = (((short)initData[ii]) << 8) | initData[ii+1];
}


MAYBE_UNUSED
static void UniversalObjectFixedObjectClip(DynospriteCOB *cob, DynospriteODT *odt) {    
}


MAYBE_UNUSED
static void UniversalObjectVelocityObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    UniversalObjectFixedObjectInit(cob, odt, initData);
    UniversalObject *state = (UniversalObject *)cob->statePtr;
    word ii = 5;
    state->velocity[0] = (((short)initData[ii]) << 8) | initData[ii+1];
    ii = ii + 2;
    state->velocity[1] = (((short)initData[ii]) << 8) | initData[ii+1];
}


MAYBE_UNUSED
static void UniversalObjectVelocityObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    UniversalObject *state = (UniversalObject *)cob->statePtr;
    cob->globalX = cob->globalX + state->velocity[0];
    cob->globalY = cob->globalY + state->velocity[1];
}

#endif /* _universal_object_c */
