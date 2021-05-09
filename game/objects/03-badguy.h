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

/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of BadGuyObjectState in bytes */
#define DynospriteObject_DataSize 12

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 4

#else

#ifndef _03_badguy_h
#define _03_badguy_h

#include "dynosprite.h"
#include "object_info.h"


#define BADGUY_NUM_COLUMNS 9
#define BADGUY_NUM_ROWS 5


/** State of BadGuyObject */
typedef struct BadGuyObjectState {
    byte spriteIdx;
    byte spriteMin;
    byte spriteMax;
    byte direction;
    word originalGlobalX;
    word originalGlobalY;
    byte column;
    byte row;
    byte originalSpriteIdx;
    byte originalDirection;
} BadGuyObjectState;


#ifdef __cplusplus
[[maybe_unused]]
#endif
static DynospriteCOB *CreateBadGuy(word x, byte y, byte direction) {
    DynospriteCOB *cob = NULL;
    DynospriteCOB *firstBadGuy = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, BADGUY_GROUP_IDX);
    for(byte jj=0; jj < BADGUY_NUM_COLUMNS; ++jj) {
        cob = firstBadGuy + jj;
        for(byte ii=0; ii < BADGUY_NUM_ROWS; ++ii, cob += BADGUY_NUM_COLUMNS) {
            if (cob->active == OBJECT_INACTIVE) {
                cob->active = OBJECT_ACTIVE;
                cob->globalX = x;
                cob->globalY = y;
                ((BadGuyObjectState *)cob->statePtr)->spriteIdx = ((BadGuyObjectState *)cob->statePtr)->originalSpriteIdx;
                GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
                ++(globals->numInvaders);
                ((BadGuyObjectState *)cob->statePtr)->direction = direction;
                ((BadGuyObjectState *)cob->statePtr)->originalDirection = direction;
                return cob;
            }
        }
    }
    
    return NULL;
}


#ifdef __cplusplus
[[maybe_unused]]
#endif
static DynospriteCOB *CreateBadGuyWithSpriteIdx(word x, byte y, byte spriteIdx) {
    DynospriteCOB *cob = CreateBadGuy(x, y, 0);
    ((BadGuyObjectState *)cob->statePtr)->spriteIdx = spriteIdx;
    return cob;
}


#endif /* _03_badguy_h */

#endif /* DynospriteObject_DataDefinition */

