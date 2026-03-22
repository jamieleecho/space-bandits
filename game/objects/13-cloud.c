#ifdef __cplusplus
extern "C" {
#endif

#include "13-cloud.h"
#include "object_info.h"

#define CLOUD_CENTER_SCREEN_X 80
#define CLOUD_TOP_Y 16

static byte didNotInit = TRUE;


#ifdef __APPLE__
void CloudClassInit() {
    didNotInit = TRUE;
}
#endif


void CloudInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
    }

    CloudObjectState *statePtr = (CloudObjectState *)(cob->statePtr);
    statePtr->spriteIdx = CLOUD_SPRITE;
}


byte CloudReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte CloudUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    /* Parallax: cloud moves 1 pixel for every 8 increments of scroll.
     * screenX = globalX/2 - scroll
     * We want: screenX = CLOUD_CENTER_SCREEN_X - scroll/8
     * So: globalX = 2 * (CLOUD_CENTER_SCREEN_X + scroll - scroll/8)
     *             = 2 * (CLOUD_CENTER_SCREEN_X + scroll * 7 / 8)
     */
    unsigned int scroll = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX;
    cob->globalX = 2 * (CLOUD_CENTER_SCREEN_X + scroll - (scroll >> 3));

    return 0;
}


RegisterObject(CloudClassInit, CloudInit, 0, CloudReactivate, CloudUpdate, NULL, sizeof(CloudObjectState));

#ifdef __cplusplus
}
#endif
