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


#include "13-candle.h"
#include "sprite_state_machine.c"

// Lookup tables for sine and cosine (32 steps, scaled by 10)
static const int8_t circleSin[32] = {
    0, 2, 4, 6, 8, 9, 10, 10, 10, 9, 8, 6, 4, 2, 0, -2,
    -4, -6, -8, -9, -10, -10, -10, -9, -8, -6, -4, -2, 0, 2, 4, 6
};
static const int8_t circleCos[32] = {
    10, 10, 10, 9, 8, 6, 4, 2, 0, -2, -4, -6, -8, -9, -10, -10,
    -10, -9, -8, -6, -4, -2, 0, 2, 4, 6, 8, 9, 10, 10, 10, 9
};

static byte sprites0[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
static SpriteStateMachineState state0 = {0, 0, 14, sprites0};
static SpriteStateMachineState spriteStateMachine[1];


#ifdef __APPLE__
void CandleClassInit(void) {
}
#endif


void CandleInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    spriteStateMachine[0] = state0;

    CandleObjectState *state = ((CandleObjectState *)(cob->statePtr));
    SpriteStateInit(&(state->spriteState), spriteStateMachine);
    state->angleIdx = 0; // Initialize angle index
    state->centerX = cob->globalX; // Initialize centerX from current globalX
    state->centerY = cob->globalY; // Initialize centerY from current globalY
}


byte CandleReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte CandleUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    CandleObjectState *state = ((CandleObjectState *)(cob->statePtr));
    SpriteStateIncrement(&(state->spriteState), spriteStateMachine, 1);

    // Circle motion using integer lookup table
    state->angleIdx = (state->angleIdx + 1) & 0x1F; // 32 steps, wrap around

    cob->globalX = state->centerX + circleCos[state->angleIdx];
    cob->globalY = state->centerY + circleSin[state->angleIdx];

    return 0;
}


RegisterObject(CandleClassInit, CandleInit, 0, CandleReactivate, CandleUpdate, NULL, sizeof(CandleObjectState));

