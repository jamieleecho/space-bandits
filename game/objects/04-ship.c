#ifdef __cplusplus
extern "C" {
#endif

#include "04-ship.h"
#include "object_info.h"

#define SHIP_MIN_X (PLAYFIELD_CENTER_WIDTH_OFFSET + SHIP_HALF_WIDTH + 3)
#define SHIP_MAX_X (SCREEN_WIDTH + PLAYFIELD_CENTER_WIDTH_OFFSET - SHIP_HALF_WIDTH - 4)

static byte didNotInit = TRUE;
static DynospriteCOB *missiles[3];
static GameGlobals *globals;
static byte startUpOffsetY;

static sbyte ExplosionOffsets[] = {
    9, 7,
    9, 6,
    8, 5,
    8, 5,
    7, 5,
    7, 6,
    7, 7,
    7, 8,
    7, 9,
    8, 10,
    8, 9,
    9, 9,
    9, 7,
    9, 6,
    9, 5,
    8, 4,
    7, 4,
    6, 5,
    6, 6,
    6, 8,
    6, 10,
    7, 11,
    8, 11,
    9, 10,
    10, 8,
    10, 6,
    9, 5,
    9, 3,
    8, 3,
    7, 3,
    6, 5,
    6, 7,
    6, 9,
    6, 11,
    8, 12,
    9, 11,
    10, 10,
    10, 8,
    10, 5,
    9, 3,
    8, 2,
    7, 2,
    6, 3,
    5, 5,
    5, 8,
    6, 11,
    7, 12,
    8, 13,
    9, 12,
    10, 9,
    11, 7,
    10, 4,
    9, 2,
    8, 1,
    6, 1,
    5, 4,
    5, 7,
    5, 10,
    6, 12,
    7, 14,
    9, 13,
    10, 12,
    11, 8,
    11, 5,
    10, 2,
    9, 0,
    7, 0,
    5, 1,
    4, 4,
    4, 8,
    5, 12,
    6, 14,
    8, 15,
    10, 14,
    11, 11
};


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
        globals = (GameGlobals *)DynospriteGlobalsPtr;
        DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        for (byte ii=0; obj && ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
            obj = findObjectByGroup(obj, MISSILE_GROUP_IDX);
            
            if (obj) {
                missiles[ii] = obj;
                obj = obj + 1;
            }
        }
        startUpOffsetY = 0;
    }
    
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
    statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
    globals->counter = 0;
    return;
}


byte ShipReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 3));
    if (globals->gameState) {
        if (globals->gameState == GameStateOver) {
            if (globals->counter >= delta) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = ExplosionOffsets[globals->counter/4];
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ExplosionOffsets[globals->counter/4 + 1];
                globals->counter -= delta;
            } else {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = 8;
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = 8;
            }
        }

        return 0;
    }

    if (globals->counter < 64) {
        cob->active = OBJECT_ACTIVE;
        cob->globalX = 160;
        statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
    } else {
        if (globals->counter > delta) {
            globals->counter -= delta;
        } else {
            globals->counter = 0;
        }
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = ExplosionOffsets[globals->counter/4];
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ExplosionOffsets[globals->counter/4 + 1];
    }
    return 0;
}


byte ShipUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (startUpOffsetY < 8) {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ++startUpOffsetY;
    }
    
    ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);    
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 3));
    if (globals->gameState && (statePtr->spriteIdx < SHIP_SPRITE_EXPLOSION_INDEX)) {
        if (globals->gameState == GameStateOver) {
            if (globals->counter >= delta) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = ExplosionOffsets[globals->counter/4];
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ExplosionOffsets[globals->counter/4 + 1];
                globals->counter -= delta;
            }
        }
        return 0;
    }

    if ((statePtr->spriteIdx >= SHIP_SPRITE_EXPLOSION_INDEX) && ((statePtr->spriteIdx < SHIP_SPRITE_LAST_INDEX))) {
        ++statePtr->spriteIdx;
        --globals->counter;
        if (statePtr->spriteIdx >= SHIP_SPRITE_LAST_INDEX) {
            statePtr->spriteIdx = SHIP_SPRITE_MIDDLE_INDEX;
            DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = ExplosionOffsets[globals->counter/4];
            DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ExplosionOffsets[globals->counter/4 + 1];
            cob->active = OBJECT_INACTIVE;
            if (--globals->numShips == 0x0) {
                globals->gameState = GameStateOver;
            }
        }
        return 0;
    }
    
    if (globals->counter >= delta) {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = ExplosionOffsets[globals->counter/4];
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = ExplosionOffsets[globals->counter/4 + 1];
        globals->counter -= delta;
        return 0;
    } else {
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = 8;
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = 8;
    }
    globals->counter = 0;
    
    unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
    if (joyx < 16) {
        if (cob->globalX < delta) {
            cob->globalX = SHIP_MIN_X;
        } else {
            cob->globalX -= delta;
        }
        if (cob->globalX < SHIP_MIN_X) {
            cob->globalX = SHIP_MIN_X;
            statePtr->spriteIdx = 1;
        } else {
            statePtr->spriteIdx = 0;
        }
    } else if (joyx > 48) {
        cob->globalX += delta;
        if (cob->globalX > SHIP_MAX_X) {
            cob->globalX = SHIP_MAX_X;
            statePtr->spriteIdx = 1;
        } else {
            statePtr->spriteIdx = 2;
        }
    } else {
        statePtr->spriteIdx = 1;
    }
    
    if (!(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1)) {
        DynospriteCOB *missile = findFreeMissile();
        if (missile) {
            missile->globalX = cob->globalX;
            missile->globalY = SHIP_POSITION_Y - MISSILE_HEIGHT;
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
