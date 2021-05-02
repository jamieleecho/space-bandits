#ifdef __cplusplus
extern "C" {
#endif

#include "05-missile.h"
#include "03-badguy.h"
#include "09-boss1.h"
#include "object_info.h"


static byte didNotInit = TRUE;
DynospriteCOB *badGuys[NUM_BAD_GUYS];
DynospriteCOB *boss;
DynospriteCOB **endBadGuys;
static GameGlobals *globals;


#ifdef __APPLE__
void MissileClassInit() {
    didNotInit = TRUE;
}
#endif


void MissileInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
        globals = (GameGlobals *)DynospriteGlobalsPtr;
        endBadGuys = &(badGuys[sizeof(badGuys)/sizeof(badGuys[0])]);
        DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        for (byte ii=0; obj && ii<sizeof(badGuys)/sizeof(badGuys[0]); ii++) {
            obj = findObjectByGroup(obj, BADGUY_GROUP_IDX);
            badGuys[ii] = obj;
            obj = obj + 1;
        }
    }

    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    boss = findObjectByGroup(obj, BOSS1_GROUP_IDX);

    MissileObjectState *statePtr = (MissileObjectState *)(cob->statePtr);
    statePtr->spriteIdx = 0;
}


byte MissileReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


static void checkHitBadGuy(DynospriteCOB *cob, byte bossMode) {
    DynospriteCOB **startBadGuy = bossMode ? &boss : badGuys;
    DynospriteCOB **endOfBadGuys = bossMode ? &boss + 1 : endBadGuys;

    int xx0 = cob->globalX - MISSILE_HALF_WIDTH - (bossMode ? BOSS1_HALF_WIDTH : BADGUY_HALF_WIDTH);
    int xx1 = cob->globalX + MISSILE_HALF_WIDTH + (bossMode ? BOSS1_HALF_WIDTH : BADGUY_HALF_WIDTH);
    int yy0 = cob->globalY - MISSILE_HEIGHT - (bossMode ? BOSS1_HALF_HEIGHT : BADGUY_HALF_HEIGHT);
    int yy1 = cob->globalY + (bossMode ? BOSS1_HALF_HEIGHT : BADGUY_HALF_HEIGHT) ;
    
    for (DynospriteCOB **badGuy=startBadGuy; badGuy < endOfBadGuys; ++badGuy) {
        DynospriteCOB *obj = *badGuy;
        if (obj->active &&
            (obj->globalY >= yy0) && (obj->globalY <= yy1) &&
            (obj->globalX >= xx0) && (obj->globalX <= xx1)) {
            
            if (bossMode) {
                Boss1ObjectState *statePtr = (Boss1ObjectState *)(obj->statePtr);
                cob->active = OBJECT_INACTIVE;
                statePtr->resetPhase = statePtr->currentPhase;
                if (--statePtr->hitsRemaining == 0) {
                    obj->active = OBJECT_INACTIVE;
                    PlaySound(SOUND_EXPLOSION);
                    
                    CreateBadGuyWithSpriteIdx(cob->globalX - BOSS1_HALF_WIDTH / 4,
                                              (byte)cob->globalY - BOSS1_HALF_HEIGHT / 4,
                                              BADGUY_SPRITE_EXPLOSION_INDEX);
                    CreateBadGuyWithSpriteIdx(cob->globalX - BOSS1_HALF_WIDTH / 4,
                                              (byte)cob->globalY + BOSS1_HALF_HEIGHT / 4,
                                              BADGUY_SPRITE_EXPLOSION_INDEX);
                    CreateBadGuyWithSpriteIdx(cob->globalX + BOSS1_HALF_WIDTH / 4,
                                              (byte)cob->globalY - BOSS1_HALF_HEIGHT / 4,
                                              BADGUY_SPRITE_EXPLOSION_INDEX);
                    CreateBadGuyWithSpriteIdx(cob->globalX + BOSS1_HALF_WIDTH / 4,
                                              (byte)cob->globalY + BOSS1_HALF_HEIGHT / 4,
                                              BADGUY_SPRITE_EXPLOSION_INDEX);
                } else {
                    PlaySound(SOUND_CLICK);
                }
            } else {
                BadGuyObjectState *statePtr = (BadGuyObjectState *)(obj->statePtr);
                if (statePtr->spriteIdx < BADGUY_SPRITE_EXPLOSION_INDEX) {
                    cob->active = OBJECT_INACTIVE;
                    statePtr->spriteIdx = BADGUY_SPRITE_EXPLOSION_INDEX;
                    obj->globalX &= 0xfffe; // explosions must be on even byte boundaries
                    bumpScore(0x10);
                } else {
                    continue;
                }
            }
    
            return;
        }
    }
}


byte MissileUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (globals->gameState && globals->gameState != GameStateOver) {
        return 0;
    }

    if (cob->globalY < 22) {
        cob->active = OBJECT_INACTIVE;
    } else {
        byte delta = (DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2) << 1;
        cob->globalY -= delta;

        if (globals->gameState) {
            return 0;
        }

        checkHitBadGuy(cob, FALSE);
        checkHitBadGuy(cob, TRUE);
    }
    return 0;
}


RegisterObject(MissileClassInit, MissileInit, 0, MissileReactivate, MissileUpdate, NULL, sizeof(MissileObjectState));


#ifdef __cplusplus
}
#endif
