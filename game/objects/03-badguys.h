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
#define DynospriteObject_DataSize 7

#else

#ifndef _03_badguys_h
#define _03_badguys_h

#include "dynosprite.h"


#define BADGUY_SPRITE_ENEMY_SWATH_INDEX 0
#define BADGUY_SPRITE_BLADE_INDEX 3
#define BADGUY_SPRITE_DUDE_INDEX 7
#define BADGUY_SPRITE_TINY_INDEX 11
#define BADGUY_SPRITE_TIVO_INDEX 13
#define BADGUY_SPRITE_EXPLOSION_INDEX 15
#define BADGUY_SPRITE_LAST_INDEX 24


/** State of BadGuyObject */
typedef struct BadGuyObjectState {
  byte spriteIdx;
  byte spriteMin;
  byte spriteMax;
} BadGuyObjectState;



#endif /* _03_badguys_h */

#endif /* DynospriteObject_DataDefinition */

