//
//  12-shipx.c
//  Space Bandits
//
//  Created by Jamie Cho on 4/22/23.
//  Copyright © 2024 Jamie Cho. All rights reserved.
//
//  The file defines UniversalObjects which are dynosprite objects that have
//  some subset of basic phyical properties such as boundaries, position,
//  velocity and  momentum.
//
//  Due to limitations in the way linking is (not) defined on the CoCo 3
//  version of Space Bandits, this file must be included directly by
//  objects that use it.

#include "12-shipx.h"
#include "universal_object.c"
#include "../objects/object_info.h"


static GameGlobals *globals;


#ifdef __APPLE__
void ShipxClassInit() {
    globals = NULL;
}
#endif


void ShipxInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
    }
    UniversalObjectFixedObjectInit(cob, odt, initData);
}


byte ShipxReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte ShipxUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    UniversalObject *state = (UniversalObject *)cob->statePtr;

    byte joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
    if (joyx < 16) {
        state->position[0] = state->position[0] - 1;
    } else if (joyx >= 48) {
        state->position[0] = state->position[0] + 1;
    }
    if (state->position[0] >= 159) {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = (state->position[0] - 159) / 2;
    } else {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = 0;
    }

    byte joyy = DynospriteDirectPageGlobalsPtr->Input_JoystickY;
    if (joyy < 16) {
        state->position[1] = state->position[1] - 1;
    } else if (joyy >= 48) {
        state->position[1] = state->position[1] + 1;
    }
    if (state->position[1] >= 99) {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = (state->position[1] - 99);
    } else {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = 0;
    }

    return 0;
}


RegisterObject(ShipxClassInit, ShipxInit, UNIVERSAL_FIXED_OBJECT_INIT_SIZE, ShipxReactivate, ShipxUpdate, NULL, sizeof(ShipxObjectState));

