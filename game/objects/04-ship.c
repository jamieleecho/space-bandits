#ifdef __cplusplus
extern "C" {
#endif

#include "04-ship.h"
#include "object_info.h"


static byte didNotInit = TRUE;
static DynospriteCOB *missiles[3];


#ifdef __APPLE__
void ShipClassInit() {
    didNotInit = TRUE;
}
#endif


/**
 * @return a missile or NULL if no missile is available.
 */
DynospriteCOB *findFreeMissile() {
    // Return NULL if we fired a missile too recently
    for (byte ii=0; ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
        DynospriteCOB *missile = missiles[ii];
        if (missile->active && missile->globalY > 113) {
            return 0;
        }
    }
    
    // Return an available missile
    for (byte ii=0; ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
        DynospriteCOB *missile = missiles[ii];
        if (!missile->active) {
            return missile;
        }
    }
    
    return 0;
}


void ShipInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
        
        DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        for (byte ii=0; obj && ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
            obj = findObjectByGroup(obj, MISSILE_GROUP_IDX);
            
            if (obj) {
                missiles[ii] = obj;
                obj = obj + 1;
            }
        }
    }
    
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
    statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
    statePtr->counter = 0;
    return;
}


byte ShipReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 3));
    if (statePtr->counter < 64) {
        cob->active = OBJECT_ACTIVE;
        cob->globalX = 160;
        statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
    } else {
        statePtr->counter -= delta;
    }
    return 0;
}


byte ShipUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 3));
    
    if ((statePtr->spriteIdx >= SHIP_SPRITE_EXPLOSION_INDEX) && ((statePtr->spriteIdx < SHIP_SPRITE_LAST_INDEX))) {
        ++statePtr->spriteIdx;
        --statePtr->counter;
        if (statePtr->spriteIdx >= SHIP_SPRITE_LAST_INDEX) {
            statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
            cob->active = OBJECT_INACTIVE;
        }
        return 0;
    }
    
    if (statePtr->counter >= delta) {
        statePtr->counter -= delta;
        return 0;
    }
    statePtr->counter = 0;
    
    unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
    if (joyx < 16) {
        if (cob->globalX > delta) {
            cob->globalX -= delta;
            statePtr->spriteIdx = 0;
        } else {
            statePtr->spriteIdx = 1;
        }
    } else if (joyx > 48) {
        if (cob->globalX < 300 - delta) {
            cob->globalX += delta;
            statePtr->spriteIdx = 2;
        } else {
            statePtr->spriteIdx = 1;
        }
    } else {
        statePtr->spriteIdx = 1;
    }
    
    if (!(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1)) {
        DynospriteCOB *missile = findFreeMissile();
        if (missile) {
            missile->globalX = cob->globalX;
            missile->globalY = 165 - MISSILE_HEIGHT;
            missile->active = OBJECT_ACTIVE;
            PlaySound(SOUND_LASER);
        }
    }
    return 0;
}


RegisterObject(ShipClassInit, ShipInit, 0, ShipReactivate, ShipUpdate, NULL, sizeof(ShipObjectState));

#ifdef __cplusplus
}
#endif
