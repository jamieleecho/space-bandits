//
//  dynosprite.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#ifndef dynosprite_h
#define dynosprite_h

#include "coco.h"


/** DynospriteCOB.active flag indicating item inactive */
#define OBJECT_INACTIVE 0

/** DynospriteCOB.active flag indicating to update item */
#define OBJECT_UPDATE_ACTIVE 1

/** DynospriteCOB.active flag indicating to draw item */
#define OBJECT_DRAW_ACTIVE 2

/** DynospriteCOB.active flag indicating to draw and update item */
#define OBJECT_ACTIVE 3


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


typedef struct DynospriteODT {
    byte foo;
} DynospriteODT;


/**
 * Registers the given level into the shared registry.
 * @param init level initialization function
 * @param backgroundNewXY function used to compute new XY location
 * @param file path to file that defines the functions - ust begin with XY where XY are digits
 * @return some value
 */
int DSLevelRegistryRegister(void init(void), byte backgroundNewXY(void), const char *file);

#define RegisterLevel(init, calcuateBackgroundNewXY) static int levelInit = DSLevelRegistryRegister(init, calcuateBackgroundNewXY, __FILE__)

#endif /* dynosprite_h */
