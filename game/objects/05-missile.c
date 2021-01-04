#ifdef __cplusplus
extern "C" {
#endif

#include "05-missile.h"
#include "03-badguy.h"
#include "object_info.h"


static byte didNotInit = TRUE;
DynospriteCOB *badGuys[NUM_BAD_GUYS];
DynospriteCOB **endBadGuys;


#ifdef __APPLE__
void MissileClassInit() {
    didNotInit = TRUE;
}
#endif


void MissileInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
        endBadGuys = &(badGuys[sizeof(badGuys)/sizeof(badGuys[0])]);
        DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        for (byte ii=0; obj && ii<sizeof(badGuys)/sizeof(badGuys[0]); ii++) {
            obj = findObjectByGroup(obj, BADGUY_GROUP_IDX);
            badGuys[ii] = obj;
            obj = obj + 1;
        }
    }
    MissileObjectState *statePtr = (MissileObjectState *)(cob->statePtr);
    statePtr->spriteIdx = 0;
}


byte MissileReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


static void checkHitBadGuy(DynospriteCOB *cob) {
    int xx0 = cob->globalX - MISSILE_HALF_WIDTH - BADGUY_HALF_WIDTH;
    int xx1 = cob->globalX + MISSILE_HALF_WIDTH + BADGUY_HALF_WIDTH;
    int yy0 = cob->globalY - MISSILE_HEIGHT - BADGUY_HALF_HEIGHT;
    int yy1 = cob->globalY + BADGUY_HALF_HEIGHT;
    for (DynospriteCOB **badGuy=badGuys; badGuy < endBadGuys; ++badGuy) {
        DynospriteCOB *obj = *badGuy;
        if (obj->active &&
            (obj->globalY >= yy0) && (obj->globalY <= yy1) &&
            (obj->globalX >= xx0) && (obj->globalX <= xx1)) {
            cob->active = OBJECT_INACTIVE;
            BadGuyObjectState *statePtr = (BadGuyObjectState *)(obj->statePtr);
            if (statePtr->spriteIdx < BADGUY_SPRITE_EXPLOSION_INDEX) {
                statePtr->spriteIdx = BADGUY_SPRITE_EXPLOSION_INDEX;
                obj->globalX &= 0xfffe; // explosions must be on even byte boundaries
            }
            return;
        }
    }
}


byte MissileUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (cob->globalY < 10) {
        cob->active = 0;
    } else {
        byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;
        cob->globalY -= delta;
        checkHitBadGuy(cob);
    }
    return 0;
}


RegisterObject(MissileClassInit, MissileInit, 0, MissileReactivate, MissileUpdate, sizeof(MissileObjectState));


#ifdef __cplusplus
}
#endif
