//
//  09-boss1.c
//  Space Bandits
//
//  Created by Jamie Cho on 3/14/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#include "dynosprite.h"
#include "object_info.h"
#include "04-ship.h"
#include "09-boss1.h"


#define SCREEN_LOCATION_MIN (PLAYFIELD_CENTER_HEIGHT_OFFSET + 26)
#define SCREEN_LOCATION_MAX (PLAYFIELD_WIDTH - PLAYFIELD_CENTER_WIDTH_OFFSET - 20)
#define MAX_Y (SHIP_POSITION_Y - 23)
#define END_Y (SHIP_POSITION_Y + 6)
#define DELTA_Y 8
#define DELTA_X 6
#define MAX_DELTA_X 6


typedef enum Boss1MoveMode {
    Boss1MoveModeRight = 0,
    Boss1MoveModeLeft = 1
} Boss1MoveMode;


static GameGlobals *globals;
static byte frameCounter = 0;
const static byte phases[] = {
    0x0, 0x1, 0x2, 0x2, 0x1, 0x0
};
static byte /* Boss1MoveMode */ moveMode;
static DynospriteCOB *ship;


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
        state->currentPhase = 0;
        state->resetPhase = 0xff;
        moveMode = Boss1MoveModeRight;
        ship = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, SHIP_GROUP_IDX);
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
    byte delta = timeDelta * DELTA_X;
    if (delta > MAX_DELTA_X) {
        delta = MAX_DELTA_X;
    }

    frameCounter += timeDelta;
    if (frameCounter >= BOSS1_SPRITE_EXPLOSTION_INDEX) {
        frameCounter = 0x0;
    }
    Boss1ObjectState *state = (Boss1ObjectState *)cob->statePtr;
    if (frameCounter == 0) {
        if (++state->currentPhase >= sizeof(phases)/sizeof(phases[0])) {
            state->currentPhase = 0;
        }
        if (state->currentPhase == state->resetPhase) {
            state->resetPhase = 0xff;
        }
        
        state->spriteIdx = ((state->resetPhase == 0xff) ? 0 : BOSS1_SPRITE_EXPLOSTION_INDEX) + phases[state->currentPhase];
    }
    
    if (globals->gameState) {
        return 0;
    }
    
    byte moveDown = FALSE;
    if (moveMode == Boss1MoveModeRight) {
        cob->globalX += delta;
        if (cob->globalX > SCREEN_LOCATION_MAX) {
            moveMode = Boss1MoveModeLeft;
            moveDown = TRUE;
        }
    } else {
        cob->globalX -= delta;
        if (cob->globalX < SCREEN_LOCATION_MIN) {
            moveMode = Boss1MoveModeRight;
            moveDown = TRUE;
        }
    }
    
    if (moveDown) {
        cob->globalY += DELTA_Y;
        if (cob->globalY > MAX_Y) {
            cob->globalY = END_Y;
            ((ShipObjectState *)ship->statePtr)->spriteIdx = SHIP_SPRITE_EXPLOSION_INDEX;
            globals->counter = 0xff;
            globals->gameState = GameStateOver;
            PlaySound(SOUND_EXPLOSION);
        }
    }

    return 0;
}


RegisterObject(Boss1ClassInit, Boss1Init, 0, Boss1Reactivate, Boss1Update, NULL, sizeof(Boss1ObjectState));
