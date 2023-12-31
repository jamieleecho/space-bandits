//
//  10-fixed_object.c
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#include "dynosprite.h"
#include "object_info.h"
#include "10-fixed_object.h"


static GameGlobals *globals;


#ifdef __APPLE__
void FixedObjectClassInit() {
    globals = NULL;
}
#endif


void FixedObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
        globals = (GameGlobals *)DynospriteGlobalsPtr;
    }
    
    FixedObjectState *state = (FixedObjectState *)cob->statePtr;
    state->spriteIdx = initData[0];
}


byte FixedObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte FixedObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(FixedObjectClassInit, FixedObjectInit, 1, FixedObjectReactivate, FixedObjectUpdate, NULL, sizeof(FixedObjectState));
