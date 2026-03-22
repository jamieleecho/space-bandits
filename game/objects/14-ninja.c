#ifdef __cplusplus
extern "C" {
#endif

#include "14-ninja.h"
#include "object_info.h"

#define NINJA_PLAY_AREA_WIDTH 1280
#define NINJA_MIN_X (NINJA_HALF_WIDTH + 1)
#define NINJA_MAX_X (NINJA_PLAY_AREA_WIDTH - NINJA_HALF_WIDTH - 1)
#define NINJA_GROUND_Y 360
#define NINJA_JUMP_VELOCITY -15
#define NINJA_GRAVITY 1

static byte didNotInit = TRUE;
static GameGlobals *globals;


#ifdef __APPLE__
void NinjaClassInit() {
    didNotInit = TRUE;
}
#endif


void NinjaInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
        globals = (GameGlobals *)DynospriteGlobalsPtr;
    }

    NinjaObjectState *statePtr = (NinjaObjectState *)(cob->statePtr);
    statePtr->spriteIdx = NINJA_SPRITE_CENTER;
    statePtr->jumpVelocity = 0;
    statePtr->isJumping = 1;
    statePtr->lastButtonState = 0;
    statePtr->walkCounter = 0;
}


byte NinjaReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte NinjaUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    NinjaObjectState *statePtr = (NinjaObjectState *)(cob->statePtr);
    byte delta = (DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2) * 2;

    unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;

    if (joyx < 16) {
        /* Move left */
        if (cob->globalX < delta + NINJA_MIN_X) {
            cob->globalX = NINJA_MIN_X;
        } else {
            cob->globalX -= delta;
        }
        statePtr->walkCounter++;
        if ((statePtr->walkCounter >> 2) & 1) {
            statePtr->spriteIdx = NINJA_SPRITE_LEFT_WALK_A;
        } else {
            statePtr->spriteIdx = NINJA_SPRITE_LEFT_WALK_B;
        }
    } else if (joyx > 48) {
        /* Move right */
        cob->globalX += delta;
        if (cob->globalX > NINJA_MAX_X) {
            cob->globalX = NINJA_MAX_X;
        }
        statePtr->walkCounter++;
        if ((statePtr->walkCounter >> 2) & 1) {
            statePtr->spriteIdx = NINJA_SPRITE_RIGHT_WALK_A;
        } else {
            statePtr->spriteIdx = NINJA_SPRITE_RIGHT_WALK_B;
        }
    } else {
        statePtr->walkCounter = 0;
        statePtr->spriteIdx = NINJA_SPRITE_CENTER;
    }

    /* Jump when fire button pressed (edge-triggered) */
    byte buttonDown = !(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1);
    if (buttonDown && !statePtr->lastButtonState && !statePtr->isJumping) {
        statePtr->isJumping = 1;
        statePtr->jumpVelocity = NINJA_JUMP_VELOCITY;
        PlaySound(SOUND_BOINK);
    }
    statePtr->lastButtonState = buttonDown;

    /* Override sprite when jumping */
    if (statePtr->isJumping) {
        statePtr->spriteIdx = NINJA_SPRITE_JUMP;
    }

    /* Apply jump physics */
    if (statePtr->isJumping) {
        cob->globalY += statePtr->jumpVelocity;
        statePtr->jumpVelocity += NINJA_GRAVITY;

        if (cob->globalY >= NINJA_GROUND_Y) {
            cob->globalY = NINJA_GROUND_Y;
            statePtr->isJumping = 0;
            statePtr->jumpVelocity = 0;
        }
    }

    /* Hide ninja when vertically clipped */
    int screenY = (int)cob->globalY - (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    if (screenY - NINJA_HALF_HEIGHT < 0 || screenY + NINJA_HALF_HEIGHT > SCREEN_HEIGHT) {
        cob->active = OBJECT_UPDATE_ACTIVE;
    } else {
        cob->active = OBJECT_ACTIVE;
    }

    return 0;
}


RegisterObject(NinjaClassInit, NinjaInit, 0, NinjaReactivate, NinjaUpdate, NULL, sizeof(NinjaObjectState));

#ifdef __cplusplus
}
#endif
