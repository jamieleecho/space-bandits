/*********************************************************************************
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *********************************************************************************/

#ifdef DynospriteObject_DataDefinition

/** Size of LittleGuyObjectState in bytes */
#define DynospriteObject_DataSize 5

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _10_littleguy_h
#define _10_littleguy_h

#include "dynosprite.h"

/** Sprite indices for the little guy */
#define LITTLEGUY_SPRITE_LEFT_STAND  0
#define LITTLEGUY_SPRITE_LEFT_WALK_A 1
#define LITTLEGUY_SPRITE_LEFT_WALK_B 2
#define LITTLEGUY_SPRITE_CENTER      3
#define LITTLEGUY_SPRITE_RIGHT_STAND 4
#define LITTLEGUY_SPRITE_RIGHT_WALK_A 5
#define LITTLEGUY_SPRITE_RIGHT_WALK_B 6
#define LITTLEGUY_SPRITE_JUMP        7

#define LITTLEGUY_HALF_WIDTH  10
#define LITTLEGUY_GROUP_IDX   10

/** State of Little Guy Object */
typedef struct LittleGuyObjectState {
    byte spriteIdx;
    signed char jumpVelocity;
    byte isJumping;
    byte lastButtonState;
    byte walkCounter;
} LittleGuyObjectState;

#endif /* _10_littleguy_h */

#endif /* DynospriteObject_DataDefinition */
