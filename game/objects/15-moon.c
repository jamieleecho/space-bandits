#ifdef __cplusplus
extern "C" {
#endif

#include "15-moon.h"
#include "object_info.h"

#define MOON_CENTER_SCREEN_X 120
#define MOON_TOP_Y 130

static byte didNotInit = TRUE;


#ifdef __APPLE__
void MoonClassInit() {
    didNotInit = TRUE;
}
#endif


void MoonInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
    }

    MoonObjectState *statePtr = (MoonObjectState *)(cob->statePtr);
    statePtr->spriteIdx = MOON_SPRITE;
}


byte MoonReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte MoonUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    /* Parallax: moon moves 1 pixel for every 8 increments of scroll */
    unsigned int scrollX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX;
    cob->globalX = 2 * (MOON_CENTER_SCREEN_X + scrollX - (scrollX >> 3));

    cob->globalY = MOON_TOP_Y;

    /* Hide moon when vertically clipped */
    int screenY = (int)cob->globalY - (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    if (screenY - MOON_HALF_WIDTH < 0 || screenY + MOON_HALF_WIDTH > SCREEN_HEIGHT) {
        cob->active = OBJECT_UPDATE_ACTIVE;
    } else {
        cob->active = OBJECT_ACTIVE;
    }

    return 0;
}


RegisterObject(MoonClassInit, MoonInit, 0, MoonReactivate, MoonUpdate, NULL, sizeof(MoonObjectState));

#ifdef __cplusplus
}
#endif
