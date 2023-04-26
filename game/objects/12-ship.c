//
//  12-ship.c
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

#include "12-ship.h"
#include "../objects/object_info.h"


static GameGlobals *globals;


#ifdef __APPLE__
void Ship12ClassInit() {
    globals = NULL;
}
#endif


void Ship12Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
    }
}


byte Ship12Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte Ship12Update(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(Ship12ClassInit, Ship12Init, 0, Ship12Reactivate, Ship12Update, NULL, sizeof(Ship12ObjectState));

