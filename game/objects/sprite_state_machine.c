//
//  sprite_state_machine.c
//  Space Bandits
//
//  Created by Jamie Cho on 5/26/25.
//

#include "sprite_state_machine.h"


static void SpriteStateInit(SpriteState *state, SpriteStateMachineState *stateMachine) {
    state->state = 0;
    state->index = 0;
    SpriteStateMachineState *spriteStateMachineState = &(stateMachine[0]);
    state->timer = spriteStateMachineState->timePerSprite;
    state->spriteIdx = spriteStateMachineState->sprites[0];
}


static void SpriteStateIncrement(SpriteState *state, SpriteStateMachineState *stateMachine, byte time) {
    SpriteStateMachineState *spriteStateMachineState = &(stateMachine[state->state]);
    if (spriteStateMachineState->numSprites <= ++state->index) {
        state->state = spriteStateMachineState->nextState;
        state->index = 0;
        state->timer = spriteStateMachineState->timePerSprite;
        state->spriteIdx = spriteStateMachineState->sprites[0];
    } else {
        state->spriteIdx = spriteStateMachineState->sprites[state->index];
    }
}
