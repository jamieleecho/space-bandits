#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/14-ninja.h"

#define JAPAN_PLAY_AREA_WIDTH 1280
#define JAPAN_PLAY_AREA_HEIGHT 400
#define JAPAN_MAX_SCROLL_X ((JAPAN_PLAY_AREA_WIDTH - SCREEN_WIDTH) / 2)
#define JAPAN_MAX_SCROLL_Y (JAPAN_PLAY_AREA_HEIGHT - SCREEN_HEIGHT)


void JapanInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 1;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = 0;
}


byte JapanCalculateBkgrndNewXY() {
    /* Scroll the background to keep ninja at screen center.
     * The CoCo 3 can only scroll 2px horizontally (1 unit) or 1px vertically
     * per frame, so the camera "catches up" to the target gradually. */
    DynospriteCOB *ninjaCob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, NINJA_GROUP_IDX);
    if (ninjaCob) {
        /* Calculate desired horizontal scroll */
        int targetX = (int)(ninjaCob->globalX / 2) - 80;
        if (targetX < 0) {
            targetX = 0;
        } else if (targetX > JAPAN_MAX_SCROLL_X) {
            targetX = JAPAN_MAX_SCROLL_X;
        }

        /* Move at most 2 units per frame toward target */
        int curX = (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX;
        if (curX + 2 <= targetX) {
            curX += 2;
        } else if (curX - 2 >= targetX) {
            curX -= 2;
        } else {
            curX = targetX;
        }
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = curX;

        /* Calculate desired vertical scroll */
        int targetY = (int)ninjaCob->globalY - 160;
        if (targetY < 0) {
            targetY = 0;
        } else if (targetY > JAPAN_MAX_SCROLL_Y) {
            targetY = JAPAN_MAX_SCROLL_Y;
        }

        /* Move at most 4 pixels per frame toward target */
        int curY = (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
        if (curY + 4 <= targetY) {
            curY += 4;
        } else if (curY - 4 >= targetY) {
            curY -= 4;
        } else {
            curY = targetY;
        }
        DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = curY;
    }
    return 0;
}


RegisterLevel(JapanInit, JapanCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
