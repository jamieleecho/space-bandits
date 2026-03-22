#ifdef __cplusplus
extern "C" {
#endif

#include "11-bird.h"
#include "object_info.h"

#define BIRD_PLAY_AREA_WIDTH 640
#define BIRD_MIN_X (BIRD_HALF_WIDTH + 1)
#define BIRD_MAX_X (BIRD_PLAY_AREA_WIDTH - BIRD_HALF_WIDTH - 1)
#define BIRD_BASE_Y 140
#define BIRD_BOB_AMPLITUDE 4
#define BIRD_FLAP_SPEED 6

/* Simple sine-like table for vertical bob: 0,1,2,3,4,3,2,1,0,-1,-2,-3,-4,-3,-2,-1 */
static signed char bobTable[16] = {
    0, 1, 2, 3, 4, 3, 2, 1, 0, -1, -2, -3, -4, -3, -2, -1
};

static byte didNotInit = TRUE;


#ifdef __APPLE__
void BirdClassInit() {
    didNotInit = TRUE;
}
#endif


void BirdInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
    }

    BirdObjectState *statePtr = (BirdObjectState *)(cob->statePtr);
    statePtr->spriteIdx = BIRD_SPRITE_WINGS_LEVEL;
    statePtr->direction = 1;
    statePtr->flapCounter = 0;
    statePtr->bobCounter = 0;
    statePtr->hideCounter = 0;
}


byte BirdReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte BirdUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    BirdObjectState *statePtr = (BirdObjectState *)(cob->statePtr);

    /* If hiding after being hit, count down and respawn */
    if (statePtr->hideCounter > 0) {
        statePtr->hideCounter--;
        cob->active = OBJECT_UPDATE_ACTIVE;
        if (statePtr->hideCounter == 0) {
            /* Respawn at a pseudo-random horizontal location */
            cob->globalX = BIRD_MIN_X + ((cob->globalY * 137 + statePtr->flapCounter * 79) % (BIRD_MAX_X - BIRD_MIN_X));
            statePtr->bobCounter = 0;
        }
        return 0;
    }

    byte delta = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2;

    /* Horizontal movement: fly back and forth */
    if (statePtr->direction) {
        cob->globalX += delta;
        if (cob->globalX > BIRD_MAX_X) {
            cob->globalX = BIRD_MAX_X;
            statePtr->direction = 0;
        }
    } else {
        if (cob->globalX < delta + BIRD_MIN_X) {
            cob->globalX = BIRD_MIN_X;
            statePtr->direction = 1;
        } else {
            cob->globalX -= delta;
        }
    }

    /* Vertical undulation */
    statePtr->bobCounter = (statePtr->bobCounter + 1) & 0x0F;
    cob->globalY = BIRD_BASE_Y + bobTable[statePtr->bobCounter];

    /* Wing flapping animation */
    statePtr->flapCounter++;
    if (statePtr->flapCounter >= BIRD_FLAP_SPEED * 3) {
        statePtr->flapCounter = 0;
    }
    if (statePtr->flapCounter < BIRD_FLAP_SPEED) {
        statePtr->spriteIdx = BIRD_SPRITE_WINGS_UP;
    } else if (statePtr->flapCounter < BIRD_FLAP_SPEED * 2) {
        statePtr->spriteIdx = BIRD_SPRITE_WINGS_LEVEL;
    } else {
        statePtr->spriteIdx = BIRD_SPRITE_WINGS_DOWN;
    }

    /* Hide bird when scrolled off screen */
    int screenX = (int)(cob->globalX / 2) - (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX;
    if (screenX + BIRD_HALF_WIDTH < 0 || screenX - BIRD_HALF_WIDTH > SCREEN_WIDTH) {
        cob->active = OBJECT_UPDATE_ACTIVE;
    } else {
        cob->active = OBJECT_ACTIVE;
    }

    return 0;
}


RegisterObject(BirdClassInit, BirdInit, 0, BirdReactivate, BirdUpdate, NULL, sizeof(BirdObjectState));

#ifdef __cplusplus
}
#endif
