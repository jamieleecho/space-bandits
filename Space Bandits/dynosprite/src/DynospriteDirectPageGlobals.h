//
//  DynospriteDirectPageGlobals.h
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#ifndef DynospriteDirectPageGlobals_h
#define DynospriteDirectPageGlobals_h

#include "coco.h"

struct DynospriteCOB;
struct DynospriteODT;

/** Object Data Table */
typedef struct DynospriteODT {
    byte dataSize;
    byte drawType;
    byte initSize;
    byte res1;
    void(*init)(struct DynospriteCOB *, struct DynospriteODT *, byte *);
    byte(*reactivate)(struct DynospriteCOB *, struct DynospriteODT *);
    byte(*update)(struct DynospriteCOB *, struct DynospriteODT *);
    void (*draw)(struct DynospriteCOB *, void *, void *, void *, void *, bool hide);
    byte res2[4];
} DynospriteODT;

/** Curent Object Buffer */
typedef struct DynospriteCOB {
    byte groupIdx;
    byte objectIdx;
    byte active;
    byte res1;
    unsigned globalX;
    unsigned globalY;
    byte *statePtr;
    DynospriteODT *odtPtr;
} DynospriteCOB;

/** Datastructure for DynospriteDirectPageGlobals */
typedef struct DynospriteDirectPageGlobals {
    /** X coordinates of last rendered buffer pair */
    word Gfx_BkgrndLastX;

    /** Y coordinates of last rendered buffer pair */
    word Gfx_BkgrndLastY;
    
    /** New X coordinates of buffer pair which is being redrawn */
    word Gfx_BkgrndNewX;

    /** New Y coordinates of buffer pair which is being redrawn */
    word Gfx_BkgrndNewY;

    sbyte Obj_MotionFactor;
    
    byte Obj_NumCurrent;
    DynospriteCOB *Obj_CurrentTablePtr;
    unsigned Obj_StateDataPtr;
    
    byte Input_UseKeyboard;
    byte Input_JoystickX;
    byte Input_JoystickY;
    byte Input_Buttons;
    
    byte Input_KeyMatrix[8];
} DynospriteDirectPageGlobals;

/** Datastructure for DynospriteGlobals */
typedef union DynospriteGlobals {
    byte UserGlobals_Init;
    byte UserGlobals[32];
} DynospriteGlobals;

#endif /* DynospriteDirectPageGlobals_h */
