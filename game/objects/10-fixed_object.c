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
#include "universal_object.c"


static GameGlobals *globals;


#ifdef __APPLE__
void Fixed_objectClassInit() {
    globals = NULL;
}
#endif


void Fixed_objectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
        globals = (GameGlobals *)DynospriteGlobalsPtr;
    }
    
    UniversalObjectFixedObjectInit(cob, odt, initData);
    Fixed_objectState *state = (Fixed_objectState *)cob->statePtr;
    state->spriteIdx = initData[0];
}


byte Fixed_objectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte Fixed_objectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(Fixed_objectClassInit, Fixed_objectInit, UNIVERSAL_FIXED_OBJECT_INIT_SIZE, Fixed_objectReactivate, Fixed_objectUpdate, NULL, sizeof(Fixed_objectObjectState));
