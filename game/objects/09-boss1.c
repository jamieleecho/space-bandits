//
//  09-boss1.c
//  Space Bandits
//
//  Created by Jamie Cho on 3/14/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#include "dynosprite.h"
#include "object_info.h"
#include "09-boss1.h"


static GameGlobals *globals;


#ifdef __APPLE__
void Boss1ClassInit() {
}
#endif


void Boss1Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    globals = (GameGlobals *)&DynospriteGlobalsPtr->UserGlobals_Init;
    Boss1ObjectState *state = (Boss1ObjectState *)cob->statePtr;
    state->spriteIdx = 0;
}


byte Boss1Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte Boss1Update(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(Boss1ClassInit, Boss1Init, 0, Boss1Reactivate, Boss1Update, NULL, sizeof(Boss1ObjectState));
