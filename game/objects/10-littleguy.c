#ifdef __cplusplus
extern "C" {
#endif

#include "10-littleguy.h"
#include "11-bird.h"
#include "object_info.h"

#define LITTLEGUY_PLAY_AREA_WIDTH 640
#define LITTLEGUY_MIN_X (LITTLEGUY_HALF_WIDTH + 1)
#define LITTLEGUY_MAX_X (LITTLEGUY_PLAY_AREA_WIDTH - LITTLEGUY_HALF_WIDTH - 1)
#define LITTLEGUY_MAX_SCROLL ((LITTLEGUY_PLAY_AREA_WIDTH - SCREEN_WIDTH) / 2)
#define LITTLEGUY_HALF_HEIGHT 7
#define LITTLEGUY_GROUND_Y 183
#define LITTLEGUY_JUMP_VELOCITY -6
#define LITTLEGUY_GRAVITY 1

static byte didNotInit = TRUE;
static GameGlobals *globals;


#ifdef __APPLE__
void LittleguyClassInit() {
    didNotInit = TRUE;
}
#endif


void LittleguyInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
        globals = (GameGlobals *)DynospriteGlobalsPtr;
    }

    LittleGuyObjectState *statePtr = (LittleGuyObjectState *)(cob->statePtr);
    statePtr->spriteIdx = LITTLEGUY_SPRITE_CENTER;
    statePtr->jumpVelocity = 0;
    statePtr->isJumping = 0;
    statePtr->lastButtonState = 0;
}


byte LittleguyReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte LittleguyUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    LittleGuyObjectState *statePtr = (LittleGuyObjectState *)(cob->statePtr);
    byte delta = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2;

    unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;

    if (joyx < 16) {
        /* Move left */
        if (cob->globalX < delta + LITTLEGUY_MIN_X) {
            cob->globalX = LITTLEGUY_MIN_X;
        } else {
            cob->globalX -= delta;
        }
        statePtr->spriteIdx = LITTLEGUY_SPRITE_LEFT;
    } else if (joyx > 48) {
        /* Move right */
        cob->globalX += delta;
        if (cob->globalX > LITTLEGUY_MAX_X) {
            cob->globalX = LITTLEGUY_MAX_X;
        }
        statePtr->spriteIdx = LITTLEGUY_SPRITE_RIGHT;
    } else {
        statePtr->spriteIdx = LITTLEGUY_SPRITE_CENTER;
    }

    /* Jump when fire button pressed (edge-triggered) */
    byte buttonDown = !(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1);
    if (buttonDown && !statePtr->lastButtonState && !statePtr->isJumping) {
        statePtr->isJumping = 1;
        statePtr->jumpVelocity = LITTLEGUY_JUMP_VELOCITY;
        PlaySound(SOUND_BOINK);
    }
    statePtr->lastButtonState = buttonDown;

    /* Apply jump physics */
    if (statePtr->isJumping) {
        cob->globalY += statePtr->jumpVelocity;
        statePtr->jumpVelocity += LITTLEGUY_GRAVITY;

        if (cob->globalY >= LITTLEGUY_GROUND_Y) {
            cob->globalY = LITTLEGUY_GROUND_Y;
            statePtr->isJumping = 0;
            statePtr->jumpVelocity = 0;
        }
    }

    /* Check collision with bird */
    DynospriteCOB *birdCob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, BIRD_GROUP_IDX);
    if (birdCob) {
        BirdObjectState *birdState = (BirdObjectState *)(birdCob->statePtr);
        if (birdState->hideCounter == 0) {
            int dx = (int)cob->globalX - (int)birdCob->globalX;
            int dy = (int)cob->globalY - (int)birdCob->globalY;
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;
            if (dx < (LITTLEGUY_HALF_WIDTH + BIRD_HALF_WIDTH) &&
                dy < (LITTLEGUY_HALF_HEIGHT + BIRD_HALF_HEIGHT)) {
                PlaySound(SOUND_OUCH);
                bumpScore(1);
                birdState->hideCounter = BIRD_HIDE_DURATION;
            }
        }
    }

    /* Scroll the background to keep little guy at screen center */
    int scroll = (int)(cob->globalX / 2) - 80;
    if (scroll < 0) {
        scroll = 0;
    } else if (scroll > LITTLEGUY_MAX_SCROLL) {
        scroll = LITTLEGUY_MAX_SCROLL;
    }
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = scroll;

    return 0;
}


RegisterObject(LittleguyClassInit, LittleguyInit, 0, LittleguyReactivate, LittleguyUpdate, NULL, sizeof(LittleGuyObjectState));

#ifdef __cplusplus
}
#endif
