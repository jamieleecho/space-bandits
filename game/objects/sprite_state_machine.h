//
//  sprite_state_machine.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/26/25.
//

#ifndef _sprite_state_machine_h
#define _sprite_state_machine_h


#include "dynosprite.h"


typedef struct SpriteStateMachineState {
    /** the amount of time to spend on each srpite  */
    byte timePerSprite;

    /** index of the next SpriteState */
    byte nextState;

    /** number of sprites in this state */
    byte numSprites;
    
    /** sprite indices of the sprites in this sprite space */
    byte *sprites;
} SpriteStateMachineState;


typedef struct SpriteState {
    /** Index of current sprite to show */
    byte spriteIdx;
    
    /** Current state machine state */
    byte state;
    
    /** Index into the current state */
    byte index;
    
    /** countdown timer */
    byte timer;
} SpriteState;


/**
 * Initializes the sprite state
 * state - the state to initialize
 * stateMachine - state machine that this state will run from
 */
static void SpriteStateInit(SpriteState *state, SpriteStateMachineState *stateMachine);


/**
 * Increments the current sprite state to the next state in stateMachine
 * state current sprite state
 * stateMachine the state machine that state is following
 * time time of the last iteration
 */
static void SpriteStateIncrement(SpriteState *state, SpriteStateMachineState *stateMachine, byte time);


#endif
