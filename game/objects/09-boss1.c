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


typedef enum Boss1MoveMode {
    Boss1MoveModeRight = 0,
    Boss1MoveModeLeft = 1
} Boss1MoveMode;


static GameGlobals *globals;
static byte currentPhase = 0;
static byte frameCounter = 0;
const static byte phases[] = {
    0x0, 0x1, 0x2, 0x2, 0x1, 0x0
};
static byte /* Boss1MoveMode */ moveMode;


#ifdef __APPLE__
void Boss1ClassInit() {
    globals = NULL;
}
#endif


void Boss1Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
        globals = (GameGlobals *)DynospriteGlobalsPtr;
        Boss1ObjectState *state = (Boss1ObjectState *)cob->statePtr;
        state->spriteIdx = 0;
        currentPhase = 0;
        moveMode = Boss1MoveModeRight;
    }
}


byte Boss1Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (globals->gameWave == GameWavePerseiBoss) {
        cob->active = OBJECT_ACTIVE;
    }
    return 0;
}


byte Boss1Update(DynospriteCOB *cob, DynospriteODT *odt) {
    byte timeDelta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2));
    byte delta = timeDelta * 3;
    if (delta > 12) {
        delta = 12;
    }

    frameCounter += timeDelta;
    if (frameCounter >= 3) {
        frameCounter = 0x0;
    }
    if (frameCounter == 0) {
        if (++currentPhase >= sizeof(phases)/sizeof(phases[0])) {
            currentPhase = 0;
        }
        (((Boss1ObjectState *)(cob->statePtr))->spriteIdx) = phases[currentPhase];
    }
    if (moveMode == Boss1MoveModeRight) {
        cob->globalX += delta;
        if (cob->globalX > 320) {
            moveMode = Boss1MoveModeLeft;
            ++cob->globalY;
        }
    } else {
        cob->globalX -= delta;
        if (cob->globalX < 34) {
            moveMode = Boss1MoveModeRight;
            ++cob->globalY;
        }
    }

    return 0;
}


RegisterObject(Boss1ClassInit, Boss1Init, 0, Boss1Reactivate, Boss1Update, NULL, sizeof(Boss1ObjectState));
