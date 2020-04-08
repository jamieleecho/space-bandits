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


typedef struct DynospriteCOB {
    byte groupIdx;
    byte objectIdx;
    byte active;
    byte res1;
    unsigned globalX;
    unsigned globalY;
    byte *statePtr;
    byte *odtPtr;
} DynospriteCOB;

/** Datastructure for DynospriteDirectPageGlobals */
typedef struct DynospriteDirectPageGlobals {
  byte Obj_MotionFactor;

  byte Obj_NumCurrent;
  DynospriteCOB *Obj_CurrentTablePtr;
  unsigned Obj_StateDataPtr;

  byte Input_UseKeyboard;
  byte Input_JoystickX;
  byte Input_JoystickY;
  byte Input_Buttons;
} DynospriteDirectPageGlobals;

#endif /* DynospriteDirectPageGlobals_h */
