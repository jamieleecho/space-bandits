//
//  08-shipcounter.c
//  Space Bandits
//
//  Created by Jamie Cho on 2/18/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#include "dynosprite.h"
#include "object_info.h"
#include "08-shipcounter.h"


static GameGlobals *globals;


#ifdef __APPLE__
void ShipcounterClassInit() {
}
#endif


void ShipcounterInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    globals = (GameGlobals *)DynospriteGlobalsPtr;
    ShipCounterObjectState *state = (ShipCounterObjectState *)cob->statePtr;
    state->spriteIdx = 0;
    state->numShips = initData[0];
    state->initX = cob->globalX - (2 * DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX);
    state->initY = cob->globalY - DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
}


byte ShipcounterReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    cob->active = (((ShipCounterObjectState *)cob->statePtr)->numShips <= globals->numShips) ? OBJECT_ACTIVE : OBJECT_INACTIVE;
    return 0;
}


byte ShipcounterUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    ShipCounterObjectState *state = (ShipCounterObjectState *)cob->statePtr;
    cob->active = (state->numShips <= globals->numShips) ? OBJECT_ACTIVE : OBJECT_INACTIVE;
    cob->globalX = state->initX + (2 * DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX);
    cob->globalY = state->initY + DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    return 0;
}


RegisterObject(ShipcounterClassInit, ShipcounterInit, 0, ShipcounterReactivate, ShipcounterUpdate, NULL, sizeof(ShipCounterObjectState));
