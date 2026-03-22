#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/10-littleguy.h"

#define CHIRICO_PLAY_AREA_WIDTH 640
#define CHIRICO_MAX_SCROLL ((CHIRICO_PLAY_AREA_WIDTH - SCREEN_WIDTH) / 2)


void ChiricoInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 1;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = 0;
}


byte ChiricoCalculateBkgrndNewXY() {
    /* Scroll the background to keep little guy at screen center */
    DynospriteCOB *guyCob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, LITTLEGUY_GROUP_IDX);
    if (guyCob) {
        int scroll = (int)(guyCob->globalX / 2) - 80;
        if (scroll < 0) {
            scroll = 0;
        } else if (scroll > CHIRICO_MAX_SCROLL) {
            scroll = CHIRICO_MAX_SCROLL;
        }
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = scroll;
    }
    return 0;
}


RegisterLevel(ChiricoInit, ChiricoCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
