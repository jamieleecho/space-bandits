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
}


byte ShipxReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte ShipxUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(ShipxClassInit, ShipxInit, 0, ShipxReactivate, ShipxUpdate, NULL, sizeof(ShipxObjectState));

