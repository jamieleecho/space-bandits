#ifdef __cplusplus
extern "C" {
#endif

#include "07-badmissile.h"
#include "03-badguy.h"
#include "04-ship.h"
#include "object_info.h"


static void checkHitShip(DynospriteCOB *cob);


static byte didInit = FALSE;
static DynospriteCOB *shipCob;


#ifdef __APPLE__
void BadmissileClassInit() {
    didInit = FALSE;
}
#endif


void BadmissileInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!didInit) {
	didInit = TRUE;
    }
    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    shipCob = findObjectByGroup(obj, SHIP_GROUP_IDX);
    BadMissileObjectState *statePtr = (BadMissileObjectState *)(cob->statePtr);
    statePtr->spriteIdx = 0;
}


byte BadmissileReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte BadmissileUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (cob->globalY > 175) {
        cob->globalY = 10;
    } else {
        byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;
        cob->globalY += delta;
        checkHitShip(cob);
    }
    return 0;
}

static void checkHitShip(DynospriteCOB *cob) {
    int xx0 = cob->globalX - MISSILE_HALF_WIDTH - SHIP_HALF_WIDTH;
    int xx1 = cob->globalX + MISSILE_HALF_WIDTH + SHIP_HALF_WIDTH;
    int yy0 = cob->globalY - MISSILE_HEIGHT - SHIP_HALF_HEIGHT;
    int yy1 = cob->globalY + SHIP_HALF_HEIGHT;
    
    if (shipCob->active &&
        (shipCob->globalY >= yy0) && (shipCob->globalY <= yy1) &&
        (shipCob->globalX >= xx0) && (shipCob->globalX <= xx1)) {
        ((ShipObjectState *)shipCob->statePtr)->spriteIdx = SHIP_SPRITE_EXPLOSION_INDEX;
        ShipObjectState *statePtr = (ShipObjectState *)(shipCob->statePtr);
        if (statePtr->spriteIdx < SHIP_SPRITE_EXPLOSION_INDEX) {
            statePtr->spriteIdx = SHIP_SPRITE_EXPLOSION_INDEX;
            cob->globalX &= 0xfffe;
        }
        return;
    }
}

RegisterObject(BadmissileClassInit, BadmissileInit, 0, BadmissileReactivate, BadmissileUpdate, sizeof(BadMissleObjectState));

#ifdef __cplusplus
}
#endif
