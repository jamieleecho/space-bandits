//
//  dynosprite.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#ifndef dynosprite_h
#define dynosprite_h

#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include "coco.h"
#include "DynospriteDirectPageGlobals.h"

/** Joystick 1 button 1 mask */
#define Joy1Button1 1

/** Joystick 2 button 1 mask */
#define Joy2Button1 2

/** Joystick 1 button 2 mask */
#define Joy1Button2 4

/** Joystick 2 button 2 mask */
#define Joy2Button2 8


/** DynospriteCOB.active flag indicating item inactive */
#define OBJECT_INACTIVE 0

/** DynospriteCOB.active flag indicating to update item */
#define OBJECT_UPDATE_ACTIVE 1

/** DynospriteCOB.active flag indicating to draw item */
#define OBJECT_DRAW_ACTIVE 2

/** DynospriteCOB.active flag indicating to draw and update item */
#define OBJECT_ACTIVE 3


/**
 * Registers the given level into the shared registry.
 * @param init level initialization function
 * @param backgroundNewXY function used to compute new XY location
 * @param file path to file that defines the functions - ust begin with XY where XY are digits
 * @return some value
 */
int DSLevelRegistryRegister(void init(void), byte backgroundNewXY(void), const char *file);

/**
  * Registers the given level into the shared registry.
 * @param classInitMethod method used to initialize the class
 * @param initMethod method used to initialize the object
 * @param reactivateMethod function used to reinitialize the object
 * @param updateMethod function used to update the method on each cycle
 * @param drawMethod function used to draw the sprite
  * @param stateSize size of the state informtaion in bytes
  * @param path location of the object
  * @return some value
 */
int DSObjectClassDataRegistryRegisterClassData(void(*classInitMethod)(void), void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), size_t initSize, byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), void(*drawMethod)(struct DynospriteCOB *, void *, void *, void *, void *), size_t stateSize, const char *path);


#define RegisterLevel(init, calcuateBackgroundNewXY) static int levelInit = DSLevelRegistryRegister(init, calcuateBackgroundNewXY, __FILE__)
#define RegisterObject(classInit, init, initSize, reactivate, update, draw, stateSize) static int objectInit = DSObjectClassDataRegistryRegisterClassData(classInit, init, initSize, reactivate, update, draw, stateSize, __FILE__)

extern DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr;
extern DynospriteGlobals *DynospriteGlobalsPtr;

void PlaySound(int soundIndex);

#ifdef __cplusplus
}
#endif

#endif /* dynosprite_h */
