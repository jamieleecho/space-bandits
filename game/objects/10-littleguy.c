#ifdef __cplusplus
extern "C" {
#endif

#include "10-littleguy.h"
#include "object_info.h"

#define LITTLEGUY_MIN_X (PLAYFIELD_CENTER_WIDTH_OFFSET + LITTLEGUY_HALF_WIDTH + 1)
#define LITTLEGUY_MAX_X (SCREEN_WIDTH + PLAYFIELD_CENTER_WIDTH_OFFSET - LITTLEGUY_HALF_WIDTH - 1)
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

    return 0;
}


RegisterObject(LittleguyClassInit, LittleguyInit, 0, LittleguyReactivate, LittleguyUpdate, NULL, sizeof(LittleGuyObjectState));

#ifdef __cplusplus
}
#endif
